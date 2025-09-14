//
//  CarExtensions.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import Foundation

extension Car {
    public var id: UUID {
        carId ?? UUID()
    }
}
