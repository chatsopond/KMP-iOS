//
//  Clamped.swift
//  MyVehicle
//
//  Created by Chatsopon Deepateep on 23/2/25.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return max(limits.lowerBound, min(self, limits.upperBound))
    }
}
