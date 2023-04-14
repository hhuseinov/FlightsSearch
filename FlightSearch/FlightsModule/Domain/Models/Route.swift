//
//  Route.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 14.04.2023.
//

import Foundation

struct Route {
    let flights: [Flight]
    let totalCost: Int
    
    var routeDescription: String {
        flights.map({$0.flightDescription}).joined(separator: "\n")
    }
}
