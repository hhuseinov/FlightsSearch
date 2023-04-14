//
//  FlightDetailsViewModel.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation
import CoreLocation

final class FlightDetailsViewModel {

    var route: Route
    
    init(route: Route) {
        self.route = route
    }
}
extension FlightDetailsViewModel: FlightDetailsViewModelPresentation {
    
    func getCoordinates() -> [CLLocationCoordinate2D] {
        var result: [CLLocationCoordinate2D] = []
        guard let first = route.flights.first else {
            return result
        }
        result.append(first.coordinates.fromCoordinate)
        for flight in route.flights {
            result.append(flight.coordinates.toCoordinate)
        }
        return result
    }
}
