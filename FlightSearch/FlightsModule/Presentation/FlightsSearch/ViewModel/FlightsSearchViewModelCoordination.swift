//
//  FlightsListCoordination.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation

protocol FlightsSearchViewModelCoordinationDelegate: AnyObject {
    func showFlightDetails(_ route: Route)
}

protocol FlightsSearchViewModelCoordination: AnyObject {

    var coordinationDelegate: FlightsSearchViewModelCoordinationDelegate? { get set }

}
