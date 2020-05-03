//
//  Marker.swift
//  Compass
//
//  Created by Erkam Kucet on 3.05.2020.
//  Copyright © 2020 ekucet. All rights reserved.
//

import Foundation

struct Marker: Hashable {
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0),
            Marker(degrees: 30),
            Marker(degrees: 60),
            Marker(degrees: 90),
            Marker(degrees: 120),
            Marker(degrees: 150),
            Marker(degrees: 180, label: "Q"),
            Marker(degrees: 210),
            Marker(degrees: 240),
            Marker(degrees: 270),
            Marker(degrees: 300),
            Marker(degrees: 330)
        ]
    }
    
    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }
}
