//
//  HealthDataStep.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import HealthKit
import ResearchKit

class CKHealthDataStep: ORKInstructionStep {
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        /* **************************************************************
         * customize the instruction text that user sees when
         * requesting health data permissions.
        **************************************************************/
        
        let config = CKConfig.shared
        
        title = config.read(query: "Health Permissions Title") ?? "Permission to read Acceleration Data"
        text = config.read(query: "Health Permissions Text") ?? """
           We will use this data to predict negative health outcomes related to alcohol!
        """
    }

    @available(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 Wrapper for the `CKHealthDataStep` into a ResearchKit `ORKInstructionStepViewController`.
 
 This class was created to override the `goForward` functionality for when the `CKHealthDataStep`
 is presented in a task view.
*/
class CKHealthDataStepViewController: ORKInstructionStepViewController {
    /**
     When this step is being dismissed, get `HealthKit`  authorization in the process.
     
     Relies on a `CKHealthDataStep` instance as `self.step`.
    */
    override func goForward() {
        self.showActivityIndicator(inContinueButton: true)
        
        let manager = CKHealthKitManager.shared
        manager.getHealthAuthorization { _, _ in
            OperationQueue.main.addOperation {
                super.goForward()
            }
        }
    }
}
