//
//  SpeedometerView.swift
//  MyVehicle
//
//  Created by Chatsopon Deepateep on 23/2/25.
//

import SwiftUI

struct SpeedometerView: View {
    @Binding var speed: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(135))
            
                Circle()
                    .trim(from: 0.0, to: CGFloat(speed.clamped(to: 0...75) / 100))
                    .stroke(
                        .red,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))

                VStack {
                    Text("\(Int(speed))")
                        .contentTransition(.numericText())
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                    Text("km/h")
                        .fontDesign(.rounded)
                }
            }
            .frame(width: 200, height: 200)
        }
        .padding(15)
    }
}

#Preview {
    struct Preview: View {
        @State var speed: Double = 100
        var body: some View {
            SpeedometerView(speed: $speed)
        }
    }

    return Preview()
    
}
