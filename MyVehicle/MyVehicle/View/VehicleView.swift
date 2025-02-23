//
//  VehicleView.swift
//  MyVehicle
//
//  Created by Chatsopon Deepateep on 23/2/25.
//

import Combine
import SwiftUI

final class VehicleViewModel: ObservableObject {
    private let vehicle = Vehicle()
    @Published var speed: Double = 0
    @Published var presentedAlert = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        vehicle
            .$speed
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }
                withAnimation {
                    self.speed = value
                }
            })
            .store(in: &cancellables)
    }
    
    func startObserving() async {
        do {
            try await vehicle.observe()
        } catch {
            print("error: \(error)")
            presentedAlert = true
        }
    }
}

struct VehicleView: View {
    @StateObject private var viewModel = VehicleViewModel()
    
    var body: some View {
        SpeedometerView(speed: $viewModel.speed)
            .task {
                await viewModel.startObserving()
            }
            .alert("We can’t connect to your car right now.", isPresented: $viewModel.presentedAlert) {
                Button(action: {
                    Task {
                        await viewModel.startObserving()
                    }
                }, label: {
                    Text("Try again")
                })
            }
            .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}

#Preview {
    VehicleView()
}
