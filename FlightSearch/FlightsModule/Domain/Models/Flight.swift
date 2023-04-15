//
//  Flight.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
import CoreLocation

struct Flight: Decodable, Equatable {
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        lhs.from == rhs.from && lhs.to == rhs.to && lhs.price == rhs.price
    }
    

    let coordinates: Coordinates
    var from: String
    var to: String
    let price: Int

    var flightDescription: String {
        from + " -> " + to
    }

    struct Coordinates: Decodable {
        struct Location: Decodable {
            let lat: Double
            let long: Double
        }

        let from: Location
        let to: Location
        
        var fromCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: from.lat, longitude: from.long)
        }
        
        var toCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: to.lat, longitude: to.long)
        }
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
