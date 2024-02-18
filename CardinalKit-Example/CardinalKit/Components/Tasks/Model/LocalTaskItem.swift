//
//  LocalTaskItem.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import ResearchKit
import SwiftUI
import UIKit

enum LocalTaskItem: Int {
    /*
     * STEP (1) APPEND TABLE ITEMS HERE,
     * Give each item a recognizable name!
     */
    case alchoholHotlines,
//         sampleResearchKitActiveTask,
         sampleFHIRSurvey,
         sampleFunCoffeeSurvey
//         sampleFunCoffeeResult,
//         sampleCoreMotionAppleWatch,
//         sampleLearnItem

    /*
     * STEP (2) for each item, what should its
     * title on the list be?
     */
    var title: String {
        switch self {
        case .alchoholHotlines:
            return "Hotlines"
        case .sampleFHIRSurvey:
            return "The Science of Alcohol"
//        case .sampleResearchKitActiveTask:
//            return "Active Task (ResearchKit)"
//        case .sampleCoreMotionAppleWatch:
//            return "Sensors Demo"
        case .sampleFunCoffeeSurvey:
            return "Alcohol Survey"
//        case .sampleFunCoffeeResult:
//            return "Survey Results"
//        case .sampleLearnItem:
//            return "About CardinalKit"
        }
    }

    /*
     * STEP (3) do you need a subtitle?
     */
    var subtitle: String {
        switch self {
        case .alchoholHotlines:
            return "Important Hotlines!"
        case .sampleFHIRSurvey:
            return "Learn more! "
//        case .sampleResearchKitActiveTask:
//            return "Sample sensor/data collection activities."
//        case .sampleCoreMotionAppleWatch:
//            return "CoreMotion & Cloud Storage"
        case .sampleFunCoffeeSurvey:
            return "How do you like your alcohol?"
//        case .sampleFunCoffeeResult:
//            return "ResearchKit Charts"
//        case .sampleLearnItem:
//            return "Visit cardinalkit.org"
        }
    }

    /*
     * STEP (4) what image would you like to associate
     * with this item under the list view?
     * Check the Assets directory.
     */
    var image: UIImage? {
        switch self {
        case .alchoholHotlines:
            return getImage(named: "SurveyIcon")
        case .sampleFHIRSurvey:
            return getImage(named: "DataIcon")
        case .sampleFunCoffeeSurvey:
            return getImage(named: "CoffeeIcon")
//        case .sampleFunCoffeeResult:
//            return getImage(named: "DataIcon")
//        case .sampleCoreMotionAppleWatch:
//            return getImage(named: "WatchIcon")
//        case .sampleLearnItem:
//            return getImage(named: "CKLogoIcon")
        default:
            return getImage(named: "SurveyIcon")
        }
    }

    /*
     * STEP (5) what section should each item be under?
     */
    var section: String {
        switch self {
        case .alchoholHotlines, .sampleFunCoffeeSurvey:
            return "Important Information"
        case .sampleFHIRSurvey:
            return "Education Tab"
    
        }
    }

    /*
     * STEP (6) when each element is tapped, what should happen?
     * define a SwiftUI View & return as AnyView.
     */
    var action: some View {
        switch self {
        case .alchoholHotlines:
            return AnyView(HotlineUIView())
        case .sampleFHIRSurvey:
            return AnyView(EducationView())
            //return AnyView(CKFHIRTaskViewController(tasks: TaskSamples.sampleFHIRTask))
       
        case .sampleFunCoffeeSurvey:
            return AnyView(CKTaskViewController(tasks: TaskSamples.sampleCoffeeTask))
        }
    }

    /*
     * HELPERS
     */
    fileprivate func getImage(named: String) -> UIImage? {
        UIImage(named: named) ?? UIImage(systemName: "questionmark.square")
    }

    static var allValues: [LocalTaskItem] {
        var index = 0
        return Array(
            AnyIterator {
                let returnedElement = self.init(rawValue: index)
                index += 1
                return returnedElement
            }
        )
    }
}
