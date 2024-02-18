//
//  HotlineUIView.swift
//  CardinalKit_Example
//
//  Created by aakriti lakshmanan on 2/17/24.
//  Copyright © 2024 CardinalKit. All rights reserved.
//

import SwiftUI

struct Hotline: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
}

struct HotlineUIView: View {
    let hotlines = [
        Hotline(name: "National Drug and Alcohol Treatment Referral Routing Service (SAMHSA)", phoneNumber: "1-800-662-HELP (1-800-662-4357)"),
        Hotline(name: "Alcoholics Anonymous (AA) Hotline", phoneNumber: "(212) 870-3400"),
        Hotline(name: "National Council on Alcoholism and Drug Dependence (NCADD) Hopeline", phoneNumber: "1-800-NCA-CALL (1-800-622-2255)"),
        Hotline(name: "Al-Anon Family Groups Helpline", phoneNumber: "1-888-4AL-ANON (1-888-425-2666)"),
        Hotline(name: "National Suicide Prevention Lifeline", phoneNumber: "1-800-273-TALK (1-800-273-8255)")
    ]

    var body: some View {
        NavigationView {
            List(hotlines) { hotline in
                VStack(alignment: .leading) {
                    Text(hotline.name)
                        .font(.headline)
                    Text(hotline.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Alcohol Hotlines")
        }
    }
}


#Preview {
    HotlineUIView()
}
