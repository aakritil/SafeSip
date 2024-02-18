//
//  ScheduleViewController.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/21/20.
//  Copyright © 2020 CardinalKit. All rights reserved.
//

import CareKit
import CareKitStore
import SwiftUI
import UIKit

class ScheduleViewController: OCKDailyPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
    }

    // swiftlint:disable function_body_length
    override func dailyPageViewController(
        _ dailyPageViewController: OCKDailyPageViewController,
        prepare listViewController: OCKListViewController,
        for date: Date
    ) {
        let identifiers = [
            "doxylamine",
            "nausea",
            "coffee",
            "survey",
            "steps",
            "heartRate",
            "surveys"
        ]
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true

        // swiftlint:disable closure_body_length
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):

                // Add a non-CareKit view into the list
                let tipTitle = "Track your alcohol intake!"
                let tipText = "Swipe to see how your alcohol intake has changed throughout theweek"

                // Only show the tip view on the current date
                if Calendar.current.isDate(date, inSameDayAs: Date()) {
                    let tipView = TipView()
                    tipView.headerView.titleLabel.text = tipTitle
                    tipView.headerView.detailLabel.text = tipText
                    tipView.imageView.image = UIImage(named: "GraphicOperatingSystem")
                    listViewController.appendView(tipView, animated: false)
                }
                
                struct SpeedometerView: View {
                    let value: Double // Value to display, between 0 and 0.2

                    var body: some View {
                        // This ensures the proportion of the circle filled corresponds to the value
                        let gradientStop = min(value / 0.2, 1)

                        // Define a full gradient from green to red
                        let gradient = AngularGradient(
                            gradient: Gradient(colors: [.green, .red]),
                            center: .center,
                            // Adjust the start and end angles to match the circle's rotation
                            startAngle: .degrees(-2), // Start from the bottom (270 degrees)
                            endAngle: .degrees(358)    // End at the bottom after a full circle (270 + 360 degrees)
                        )

                        ZStack {
                            Circle()
                                .stroke(lineWidth: 15)
                                .opacity(0.3)
                            
                            // Apply the gradient to a full circle but trim it to show only the part that corresponds to the current value
                            Circle()
                                .trim(from: 0, to: CGFloat(gradientStop))
                                .stroke(gradient, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .rotationEffect(Angle(degrees: 270)) // Rotate to start from the bottom
                            
                            VStack {
                                Text("Daily Average TAC:")
                                    .font(.title)
                                    .bold()
                                Text("(Transdermal Alcohol Concentration)")
                                    .font(.subheadline)
                                    .bold()
                                    .padding()
                                Text(String(format: "%.2f", min(self.value, 0.2)))
                                    .font(.title)
                                    .bold()
                            }
                        }
                    }
                }

                
               if Calendar.current.isDateInToday(date) || date <= Date() {
                        // Generate a random value between 0 and 0.2
                        let randomValue = Double.random(in: 0...0.2)
                        
                        // Create the custom Speedometer SwiftUI view with the random value
                        let speedometerView = SpeedometerView(value: randomValue)
                        
                        // Use a UIHostingController to wrap the SwiftUI view
                        let hostingController = UIHostingController(rootView: speedometerView)
                        hostingController.view.backgroundColor = .clear
                        
                        // Adjust the size of the hosting controller's view if necessary
                        hostingController.preferredContentSize = CGSize(width: 200, height: 200) // Adjust size as needed
                        
                        // Append the hosting controller to the listViewController
                        listViewController.appendViewController(hostingController, animated: false)
                }


//                if #available(iOS 14, *), let walkTask = tasks.first(where: { $0.id == "steps" }) {
//                    let view = NumericProgressTaskView(
//                        task: walkTask,
//                        eventQuery: OCKEventQuery(for: date),
//                        storeManager: self.storeManager
//                    ).padding([.vertical], 10)
//
//                    listViewController.appendViewController(view.formattedHostingController(), animated: false)
//                }

                // Since the coffee task is only scheduled every other day, there will be cases
                // where it is not contained in the tasks array returned from the query.
                if let coffeeTask = tasks.first(where: { $0.id == "coffee" }) {
                    let coffeeCard = OCKSimpleTaskViewController(
                        task: coffeeTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager
                    )
                    listViewController.appendViewController(coffeeCard, animated: false)

                    let secondCoffeeCard = TestViewController(
                        viewSynchronizer: TestItemViewSynchronizer(),
                        task: coffeeTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager
                    )
                    listViewController.appendViewController(secondCoffeeCard, animated: false)
                }

                if let surveyTask = tasks.first(where: { $0.id == "survey" }) {
                    let surveyCard = SurveyItemViewController(
                        viewSynchronizer: SurveyItemViewSynchronizer(),
                        task: surveyTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager
                    )

                    listViewController.appendViewController(surveyCard, animated: false)
                }
                // Create a card with all surveys events
//                let surveys = tasks.filter({ $0.id.contains("Survey_") })
//                if surveys.count>0{
//                    for survey in surveys{
//
//                    }
//                }

                if let surveysTask = tasks.first(where: { $0.id == "surveys" }) {
                    let surveysCard = CheckListItemViewController(
                        viewSynchronizer: CheckListItemViewSynchronizer(),
                        task: surveysTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager
                    )
                    listViewController.appendViewController(surveysCard, animated: false)
                }

//                // Create a card for the water task if there are events for it on this day.
//                if let doxylamineTask = tasks.first(where: { $0.id == "doxylamine" }) {
//
//                    let doxylamineCard = CheckListItemViewController(
//                        viewSynchronizer: CheckListItemViewSynchronizer(),
//                        task: doxylamineTask,
//                        eventQuery: .init(for: date),
//                        storeManager: self.storeManager)
//
//                    listViewController.appendViewController(doxylamineCard, animated: false)
//                }

                // Create a card for the nausea task if there are events for it on this day.
                // Its OCKSchedule was defined to have daily events, so this task should be
                // found in `tasks` every day after the task start date.
                if let nauseaTask = tasks.first(where: { $0.id == "nausea" }) {
                    // dynamic gradient colors
                    let nauseaGradientStart = UIColor { traitCollection -> UIColor in
                        traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                    }
                    let nauseaGradientEnd = UIColor { traitCollection -> UIColor in
                        traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                    }

                    // Create a plot comparing nausea to medication adherence.
                    let nauseaDataSeries = OCKDataSeriesConfiguration(
                        taskID: "nausea",
                        legendTitle: "Nausea",
                        gradientStartColor: nauseaGradientStart,
                        gradientEndColor: nauseaGradientEnd,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues
                    )

                    let doxylamineDataSeries = OCKDataSeriesConfiguration(
                        taskID: "doxylamine",
                        legendTitle: "Doxylamine",
                        gradientStartColor: .systemGray2,
                        gradientEndColor: .systemGray,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues
                    )

                    let insightsCard = OCKCartesianChartViewController(
                        plotType: .bar,
                        selectedDate: date,
                        configurations: [nauseaDataSeries, doxylamineDataSeries],
                        storeManager: self.storeManager
                    )

                    insightsCard.chartView.headerView.titleLabel.text = "Nausea & Doxylamine Intake"
                    insightsCard.chartView.headerView.detailLabel.text = "This Week"
                    insightsCard.chartView.headerView.accessibilityLabel = "Nausea & Doxylamine Intake, This Week"
                    listViewController.appendViewController(insightsCard, animated: false)

                    // Also create a card that displays a single event.
                    // The event query passed into the initializer specifies that only
                    // today's log entries should be displayed by this log task view controller.
                    let nauseaCard = OCKButtonLogTaskViewController(
                        task: nauseaTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager
                    )
                    listViewController.appendViewController(nauseaCard, animated: false)
                }
            }
        }
    }
}

extension View {
    func formattedHostingController() -> UIHostingController<Self> {
        let viewController = UIHostingController(rootView: self)
        viewController.view.backgroundColor = .clear
        return viewController
    }
}
