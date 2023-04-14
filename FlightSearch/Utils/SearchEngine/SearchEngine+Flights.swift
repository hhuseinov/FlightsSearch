//
//  SearchEngine+Flights.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 14.04.2023.
//

import Foundation

protocol FlightsSearchEngine {
    func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route?
}

extension DefaultSearchEngine: FlightsSearchEngine {

    func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route? {
        let graph = buildGraph(initialArray: flights)
        if let (path, totalCost) = dijkstra(start: from, end: to, graph: graph) {
            let route = convertPathToRoute(path: path, flights: flights)
            return Route(flights: route, totalCost: totalCost)
         } else {
             return nil
         }
    }
}

//MARK: - Helpers
extension DefaultSearchEngine {
    func convertPathToRoute(path: [String], flights: [Flight]) -> [Flight] {
        var route: [Flight] = []
        for i in 0..<path.count-1 {
            let fromCity = path[i]
            let toCity = path[i+1]
            if let flight = flights.first(where: { $0.from == fromCity && $0.to == toCity }) {
                route.append(flight)
            }
        }
        return route
    }
}

