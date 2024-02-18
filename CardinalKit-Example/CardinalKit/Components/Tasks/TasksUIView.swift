//
//  StudyActivitiesUIView.swift
//  CardinalKit_Example
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//
import ResearchKit
import SwiftUI
import CardinalKit
import CareKit
import CareKitFHIR
import CareKitStore
import HealthKit
import UIKit



struct TasksUIView: View {
    var date = ""

    let color: Color
    let config = CKConfig.shared

    @State var useCloudSurveys = false

    @State var listItems = [CloudTaskItem]()
    @State var listItemsPerHeader = [String: [CloudTaskItem]]()
    @State var listItemsSections = [String]()

    let localListItems = LocalTaskItem.allValues
    var localListItemsPerHeader = [String: [LocalTaskItem]]()
    var localListItemsSections = [String]()

    init(color: Color) {
        self.color = color
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM. d, YYYY"
        date = formatter.string(from: Date())

        if localListItemsPerHeader.isEmpty { // init
            for item in localListItems {
                if localListItemsPerHeader[item.section] == nil {
                    localListItemsPerHeader[item.section] = [LocalTaskItem]()
                    localListItemsSections.append(item.section)
                }
                localListItemsPerHeader[item.section]?.append(item)
            }
        }
    }
    
    func getRemoteItems() {
        CKResearchSurveysManager.shared.getTaskItems { results in
            if let results = results as? [CloudTaskItem] {
                listItems = results
                var headerCopy = listItemsPerHeader
                var sectionsCopy = listItemsSections
                if listItemsPerHeader.isEmpty {
                    for item in results {
                        if headerCopy[item.section] == nil {
                            headerCopy[item.section] = [CloudTaskItem]()
                            sectionsCopy.append(item.section)
                        }
                        if ((headerCopy[item.section]?.contains(item)) ?? false) == false {
                            headerCopy[item.section]?.append(item)
                        }
                    }
                }
                listItemsPerHeader = headerCopy
                listItemsSections = sectionsCopy
            }
        }
    }
    
    let motionManager = CMMotionManager()
    
    func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let accelerometerData = data else { return }
                
                let dataDictionary: [String: Any] = [
                    "x": accelerometerData.acceleration.x,
                    "y": accelerometerData.acceleration.y,
                    "z": accelerometerData.acceleration.z,
                    "timestamp": Date().timeIntervalSince1970
                ]
                
                guard let authCollection = CKStudyUser.shared.authCollection else {
                       return
                   }
                
                let route = "\(authCollection)\(Constants.dataBucketFHIRQuestionnaireResponse)/\(Date().timeIntervalSince1970)"
             

               
                CKApp.sendData(route: route, data: dataDictionary, params: nil) { success, error in
                    if success {
                        print("Accelerometer data uploaded successfully!")
                    } else {
                        print("Error uploading accelerometer data:", error?.localizedDescription ?? "Unknown error")
                    }
                }
            }
        } else {
            print("Accelerometer is not available")
        }
    }
    
    
    struct AIModelResponse: Codable {
        let userId: Int
        let id: Int
        let title: String
        let completed: Bool
        let value: Double
    }
    
    @State private var apiResponse: AIModelResponse?

    let threshold: Double = 0.7 // Example threshold
   
       
    func callAPI() {
       guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
           print("Invalid URL")
           return
       }
       
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
           if let error = error {
               print("Error: \(error)")
               return
           }
           
           guard let httpResponse = response as? HTTPURLResponse,
                 (200...299).contains(httpResponse.statusCode) else {
               print("Invalid response")
               return
           }
           
           if let data = data {
               do {
                   let apiResponse = try JSONDecoder().decode(AIModelResponse.self, from: data)
                   print("API Response: \(apiResponse)")
                   
                   DispatchQueue.main.async {
                            self.apiResponse = apiResponse // Update the state on the main thread
                        }
               } catch {
                   print("Error decoding JSON: \(error)")
               }
           }
       }
       
       task.resume()
   }
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(config.read(query: "Study Title") ?? "CardinalKit")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(self.color)
                .padding(.top, 17)
                .padding(.bottom, 3)
            Text(config.read(query: "Team Name") ?? "Stanford Byers Center for Bidoesign")
                .font(.system(size: 15, weight: .light))
        
            Text(date).font(.system(size: 18, weight: .regular)).padding()
            Button(action: {
                startAccelerometerUpdates()
            }) {
                Text("Start Accelerometer Updates")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .padding()
            
            HStack {
                Image(systemName: (apiResponse?.value ?? 0) < threshold ? "checkmark.circle" : "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor((apiResponse?.value ?? 0) < threshold ? .green : .red)
                    .background(Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60))
                // Use string interpolation to create the status text
                let statusText = (apiResponse?.value ?? 0) < threshold ? "Normal" : "Warning"
                // Format the value as a string with two decimal places
                let valueText = String(format: "%.2f", apiResponse?.value ?? 0)
                // Combine status and value texts
                Text("\(statusText) \(valueText)")
                    .foregroundColor((apiResponse?.value ?? 0) < threshold ? .green : .black) // Use .black for value color
                    .font(.system(size: 30))
            }
            .padding()


            if useCloudSurveys {
                List {
                    ForEach(listItemsSections, id: \.self) { key in
                        if let items = listItemsPerHeader[key] {
                            Section(header: Text(key)) {
                                ForEach(items, id: \.self) { item in
                                    CloudTaskListItemView(item: item)
                                }
                            }.listRowBackground(Color.white)
                        }
                    }
                }.listStyle(GroupedListStyle())
            } else {
                List {
                    ForEach(localListItemsSections, id: \.self) { key in
                        if let items = localListItemsPerHeader[key] {
                            Section(header: Text(key)) {
                                ForEach(items, id: \.self) { item in
                                    LocalTaskListItemView(item: item)
                                }
                            }.listRowBackground(Color.white)
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
//            Text(apiResponse != nil ? "API Response: \(apiResponse!.completed.description)" : "No response yet")
        }
        .onAppear(perform: {
            self.useCloudSurveys = config.readBool(query: "Use Cloud Surveys") ?? false
            if self.useCloudSurveys {
                getRemoteItems()
            }
            
        })
        .onReceive(timer) { _ in
             print("Timer ticked!")
                        // Call the function at each timer tick
                self.callAPI()
        }
        
    }
}

struct TasksUIView_Previews: PreviewProvider {
    static var previews: some View {
        TasksUIView(color: Color.red)
    }
}
