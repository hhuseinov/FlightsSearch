//
//  Flight.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
import CoreLocation

struct Flight: Decodable {

    let coordinates: Coordinates
    var from: String
    var to: String
    let price: Int

    var flightDescription: String {
        from + " -> " + to
    }

    struct Coordinates: Decodable {
        private let from: Location
        private let to: Location
        
        var fromCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: from.lat, longitude: from.long)
        }
        
        var toCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: to.lat, longitude: to.long)
        }
    }

    private struct Location: Decodable {
        let lat: Double
        let long: Double
    }
}

extension Flight: Graphable {
    var weight: Int {
        get {
            price
        }
        set {}
    }
}
