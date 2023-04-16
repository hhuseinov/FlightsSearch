//
//  FlightsSearchViewModel.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation

final class FlightsSearchViewModel: FlightsSearchViewModelCoordination {

    weak var coordinationDelegate: FlightsSearchViewModelCoordinationDelegate?
    weak var presentationDelegate: FlightsSearchViewModelPresentationDelegate?

    private let flightSearchUseCase: FlightSearchUseCase

    // MARK: Lifecycle

    init(flightSearchUseCase: FlightSearchUseCase) {
        self.flightSearchUseCase = flightSearchUseCase
    }

    // MARK: Properties
    var allFlights: [Flight] = []
    var route: Route?

}

// MARK: - FlightsSearchViewModelPresentation

extension FlightsSearchViewModel: FlightsSearchViewModelPresentation {
    
    func didSearch(from: String?, to: String?) {
        route = nil
        guard let from, let to else {
            //TODO: Handle "empty fields" error
            presentationDelegate?.routeDidNotFound()
            return
        }
        guard searchEdgeCasesValidated(from: from, to: to) else {
            return
        }
        if let route = flightSearchUseCase.findCheapestRoute(from: from, to: to, flights: allFlights) {
            self.route = route
            presentationDelegate?.routeFound(route: route)
        } else {
            presentationDelegate?.routeDidNotFound()
        }
    }

    func viewOnMapTapped() {
        guard let route else {
            //TODO: Handle "No route" error
            return
        }
        coordinationDelegate?.showFlightDetails(route)
    }
    
    func viewDidLoad() {
        Task(priority: .high) {
            switch await flightSearchUseCase.getFlightsList() {
            case let .success(flights):
                allFlights = flights
            case .failure(_):
                //TODO: Handle errors
                break
            }
        }
    }
}

//MARK: - Helpers
extension FlightsSearchViewModel {
    private func searchEdgeCasesValidated(from: String?, to: String?) -> Bool {
        guard !allFlights.isEmpty else {
            //TODO: Handle "empty list" error
            presentationDelegate?.routeDidNotFound()
            return false
        }
        guard allFlights.contains(where: {$0.from == from}) else {
            //TODO: Handle "departure not found" error
            presentationDelegate?.routeDidNotFound()
            return false
        }
        guard allFlights.contains(where: {$0.to == to}) else {
            //TODO: Handle "departure not found" error
            presentationDelegate?.routeDidNotFound()
            return false
        }
        return true
    }
}
