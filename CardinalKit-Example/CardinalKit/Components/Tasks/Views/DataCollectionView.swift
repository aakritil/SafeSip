//
//  DataCollectionView.swift
//  CardinalKit_Example
//
//  Created by aakriti lakshmanan on 2/17/24.
//  Copyright © 2024 CardinalKit. All rights reserved.
//

import Firebase
import SwiftUI
import CoreMotion
import Foundation

import CardinalKit
import CareKit
import CareKitFHIR
import CareKitStore
import HealthKit


struct AccelerometerDataUploaderView: View {
    let motionManager = CMMotionManager()
    let identifier = "1"
    
    
    var body: some View {
        VStack {
            Button(action: {
                startAccelerometerUpdates()
            }) {
                Text("Start Accelerometer Updates")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
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
}

#Preview {
    AccelerometerDataUploaderView()
}
