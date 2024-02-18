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
import CoreMotion
import Foundation


class ApiResponseManager {
    static let shared = ApiResponseManager()
    var apiResponse: responseAPI?
    
    private init() {}
}

struct AccelerometerData: Encodable {
    let acceleration: CMAcceleration
    let timestamp: Date

    init(acceleration: CMAcceleration, timestamp: TimeInterval) {
        self.acceleration = acceleration
        self.timestamp = Date(timeIntervalSinceReferenceDate: timestamp)
    }

    // Implement Encodable protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(acceleration.x, forKey: .x)
        try container.encode(acceleration.y, forKey: .y)
        try container.encode(acceleration.z, forKey: .z)
        try container.encode(timestamp, forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
        case timestamp
    }
    
}

// Convert [CMAccelerometerData] to [AccelerometerData]
func convertToCustomData(accelerometerDataArray: [CMAccelerometerData]) -> [AccelerometerData] {
    return accelerometerDataArray.map { data in
        AccelerometerData(acceleration: data.acceleration, timestamp: data.timestamp)
    }
}
    
func convertToDict(accelerometerDataArray: [CMAccelerometerData]) -> [[String: Any]] {
        return accelerometerDataArray.map { data in
            return [
                "acceleration": [
                    "x": data.acceleration.x,
                    "y": data.acceleration.y,
                    "z": data.acceleration.z
                ],
                "timestamp": data.timestamp
            ]
        }
}

func createCombinedDictionary(dataJSON: [[String: Any]], response: responseAPI) -> [String: Any] {
    return [
        "data": dataJSON,
        "tac": response.toDictionary()
    ]
}

class PeriodicAccelerometerRecorder {
    let motion = CMMotionManager()
    var accelerometerData: [CMAccelerometerData] = []
    var timer: Timer?
    let interval: TimeInterval = 1.0 / 20.0 // 20 Hz
    let recordingDuration: TimeInterval = 10.0 // 10 seconds
    let recordingInterval: TimeInterval = 300.0 // 5 minutes
    
    func startRecording() {
        guard motion.isAccelerometerAvailable else {
            print("Accelerometer is not available")
            return
        }
        
        // Schedule timer to start recording periodically
        timer = Timer.scheduledTimer(withTimeInterval: recordingInterval, repeats: true) { timer in
            self.recordData()
        }
        
        // Immediately start recording for the first time
        recordData()
    }
    
    func recordData() {
        // Reset data array
        accelerometerData.removeAll()
        
        motion.accelerometerUpdateInterval = interval
        motion.startAccelerometerUpdates()
        
        // Schedule timer to stop recording after duration
        timer = Timer.scheduledTimer(withTimeInterval: recordingDuration, repeats: false) { timer in
            self.stopRecording()
        }
        
        // Configure a timer to fetch accelerometer data at interval
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if let data = self.motion.accelerometerData {
                self.accelerometerData.append(data)
            }
        }
    }
    
    func stopRecording() {
        motion.stopAccelerometerUpdates()
        timer?.invalidate()
        timer = nil
        
        guard let authCollection = CKStudyUser.shared.authCollection else {
            return
        }
        
        let route = "\(authCollection)\(Constants.dataBucketFHIRQuestionnaireResponse)/\(Date().timeIntervalSince1970)"
        
        callVertexAIModel(with: self.accelerometerData) { result in
            switch result {
            case .success(let response_got):
                print("Received response from Vertex AI:")
                print("Integer value:", response_got.intValue)
                print("Boolean value:", response_got.boolValue)
                
                ApiResponseManager.shared.apiResponse = response_got
                
                CKApp.sendData(route: route, data: createCombinedDictionary(dataJSON: convertToDict(accelerometerDataArray:self.accelerometerData), response: response_got), params: nil) { success, error in
                    if success {
                        print("Accelerometer data uploaded successfully!")
                    } else {
                        print("Error uploading accelerometer data:", error?.localizedDescription ?? "Unknown error")
                    }
                }
                
            case .failure(let error):
                print("Error occurred:", error)
            }
        }
        
    }
    
}

struct responseAPI: Decodable {
    let intValue: Int
    let boolValue: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        intValue = try container.decode(Int.self, forKey: .intValue)
        boolValue = try container.decode(Bool.self, forKey: .boolValue)
    }
    
    func toDictionary() -> [String: Any] {
            return [
                "intValue": intValue,
                "boolValue": boolValue
            ]
        }

    enum CodingKeys: String, CodingKey {
        case intValue
        case boolValue
    }
}

func callVertexAIModel(with data: [CMAccelerometerData] , completion: @escaping (Result<responseAPI, Error>) -> Void) {
    let url = URL(string: "https://vertex-ai-endpoint-url")! // Replace with your actual Vertex AI endpoint URL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    do {
        request.httpBody = try JSONEncoder().encode(convertToCustomData(accelerometerDataArray:data))
    } catch {
        completion(.failure(error))
        return
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(.failure(error ?? URLError(.badServerResponse)))
            return
        }
        
        do {
            let response = try JSONDecoder().decode(responseAPI.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}




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
    let recorder = PeriodicAccelerometerRecorder()

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
    
    @State private var apiResponse = ApiResponseManager.shared.apiResponse

    let threshold: Double = 0.7 // Example threshold
   
       
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
                recorder.startRecording()
            }) {
                Text("Start Accelerometer Updates")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .padding()
            
            HStack {
                Image(systemName: (apiResponse?.intValue ?? 0) < Int(threshold) ? "checkmark.circle" : "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor((apiResponse?.intValue ?? 0) < Int(threshold) ? .green : .red)
                    .background(Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60))
                // Use string interpolation to create the status text
                let statusText = (apiResponse?.intValue ?? 0) < Int(threshold) ? "Normal" : "Warning"
                // Format the value as a string with two decimal places
                let valueText = String(format: "%.2f", apiResponse?.intValue ?? 0)
                // Combine status and value texts
                Text("\(statusText) \(valueText)")
                    .foregroundColor((apiResponse?.intValue ?? 0) < Int(threshold) ? .green : .black) // Use .black for value color
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
            Text(apiResponse != nil ? "API Response: \(apiResponse!.intValue.description)" : "No response yet")
        }
        .onAppear(perform: {
            self.useCloudSurveys = config.readBool(query: "Use Cloud Surveys") ?? false
            if self.useCloudSurveys {
                getRemoteItems()
            }
            
        })
        
    }
}

struct TasksUIView_Previews: PreviewProvider {
    static var previews: some View {
        TasksUIView(color: Color.red)
    }
}
