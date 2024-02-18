//
//  LearnUIView.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/22/20.
//  Copyright © 2020 CardinalKit. All rights reserved.
//

import SwiftUI

struct LearnUIView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("CKLogo")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.paddingHorizontalMain * 4)
                .padding(.trailing, Metrics.paddingHorizontalMain * 4)
                .accessibilityLabel(Text("Logo"))
            
            Text("""
                
                SafeSip is an innovative mobile application designed to enhance personal safety and well-being by leveraging advanced accelerometer and digital health sensor technologies to monitor users' intoxication levels.
                
                Whether you're out with friends or enjoying a solo evening, SafeSip acts as your vigilant companion, ensuring your night out remains within the bounds of safety and enjoyment.

                """)
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .regular, design: .default))
                .padding(.leading, Metrics.paddingHorizontalMain * 2)
                .padding(.trailing, Metrics.paddingHorizontalMain * 2)
            
            Spacer()
            
            Image("SBDLogoGrey")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.paddingHorizontalMain * 1)
                .padding(.trailing, Metrics.paddingHorizontalMain * 1)
                .accessibilityLabel(Text("Logo"))
        }
    }
}

struct LearnUIView_Previews: PreviewProvider {
    static var previews: some View {
        LearnUIView()
    }
}
