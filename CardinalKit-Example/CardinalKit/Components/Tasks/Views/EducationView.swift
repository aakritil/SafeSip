//
//  EducationView.swift
//  CardinalKit_Example
//
//  Created by James Pan on 2024/2/18.
//  Copyright © 2024 CardinalKit. All rights reserved.
//

import Foundation

import SwiftUI

struct EducationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The Science of Alcohol")
                    .font(.title)
                    .bold()
                
                Text("Alcohol, or ethanol, is a psychoactive substance found in alcoholic beverages. It is produced by the fermentation of sugars by yeasts. When consumed, alcohol affects various parts of the brain, impacting behavior, mood, and neuromuscular coordination.")
                    .font(.body)
                
                Text("Safe Drinking Practices")
                    .font(.title2)
                    .bold()
                
                Text("1. Understand your limits: Be aware of how much alcohol is safe for you to consume based on your body weight and personal tolerance.")
                    .font(.body)
                
                Text("2. Stay hydrated: Drink plenty of water before, during, and after drinking alcohol to prevent dehydration.")
                    .font(.body)
                
                Text("3. Don't drink and drive: Always plan for a safe way to get home if you've been drinking.")
                    .font(.body)
                
                Text("4. Eat before drinking: Consuming alcohol on an empty stomach can lead to faster absorption and intoxication.")
                    .font(.body)
                
                Text("5. Pace yourself: Limit your alcohol intake to one standard drink per hour.")
                    .font(.body)
                
                Text("Remember, moderation is key to enjoying alcohol safely and responsibly.")
                    .font(.body)
                    .bold()
            }
            .padding()
        }
    }
}

struct EducationView_Previews: PreviewProvider {
    static var previews: some View {
        EducationView()
    }
}
