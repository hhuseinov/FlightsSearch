//
//  FlightSearchUseCase.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation

protocol FlightSearchUseCase {
    func getFlightsList() async -> Result<[Flight], RequestError>
    func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route?
}

final class DefaultFlightSearchUseCase {

    private let flightRepository: FlightRepository
    private let searchEngine: FlightsSearchEngine

    init(
        flightRepository: FlightRepository,
        searchEngine: FlightsSearchEngine
    ) {
        self.flightRepository = flightRepository
        self.searchEngine = searchEngine
    }
}

extension DefaultFlightSearchUseCase: FlightSearchUseCase {
    func getFlightsList() async -> Result<[Flight], RequestError> {
        return await flightRepository.getFlightsList()
    }
    
    func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route? {
        searchEngine.findCheapestRoute(from: from, to: to, flights: flights)
    }
}
