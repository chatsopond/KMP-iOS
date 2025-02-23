//
//  Vehicle.swift
//  MyVehicle
//
//  Created by Chatsopon Deepateep on 23/2/25.
//

import SwiftUI
import Foundation
import SharedKMP

enum VehicleObserverError: Error {
    case requestFailed
}

final class Vehicle: ObservableObject {
    let vehicleId: String
    @Published var battery: Int
    @Published var speed: Double
    
    let observer: VehicleObserver = VehicleObserver()
    
    init(
        vehicleId: String = UUID().uuidString,
        battery: Int = 0,
        speed: Double = 0
    ) {
        self.vehicleId = vehicleId
        self.battery = battery
        self.speed = speed
        observer.delegate = self
    }
    
    @MainActor
    func observe() async throws(VehicleObserverError) {
        do {
            try await observer.observe(vehicleId: vehicleId)
        } catch {
            print("\(#function) - failed to observe vehicleId:\(vehicleId), error: \(error)")
            throw .requestFailed
        }
    }
    
    @MainActor
    func stopObserving() async throws(VehicleObserverError) {
        do {
            try await observer.stopObserving(vehicleId: vehicleId)
        } catch {
            print("\(#function) - failed to stop observing vehicleId:\(vehicleId), error: \(error)")
            throw .requestFailed
        }
    }
}

extension Vehicle: VehicleObserverDelegate {
    func vehicleObserver(observer: VehicleObserver, vehicleId: String, status: VehicleStatus) {
        Task {
            self.battery = Int(status.battery)
            self.speed = Double(status.speed)
        }
    }
}
