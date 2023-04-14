//
//  FlightSearchUseCaseTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
@testable import FlightSearch
import XCTest

class DefaultFlightSearchUseCaseTests: XCTestCase {

    var flightRepository: MockFlightRepository!
    var FlightsSearchEngine: MockFlightsSearchEngine!
    var flightSearchUseCase: FlightSearchUseCase!
    
    override func setUp() {
        super.setUp()
        flightRepository = MockFlightRepository()
        FlightsSearchEngine = MockFlightsSearchEngine()
        flightSearchUseCase = DefaultFlightSearchUseCase(
            flightRepository: flightRepository,
            searchEngine: FlightsSearchEngine
        )
    }
    
    func testGetFlightsListSuccessAndSorted() async {
        // given
        let expectedFlights = [
            Flight(id: 707860, coordinates: .init(), name: "Hurzuf", country: "UA"),
            Flight(id: 519188, coordinates: .init(), name: "Novinki", country: "RU"),
            Flight(id: 1283378, coordinates: .init(), name: "Gorkhā", country: "NP"),
            Flight(id: 1270260, coordinates: .init(), name: "State of Haryāna", country: "IN")
        ]
        flightRepository.getFlightsListReturnValue = .success(expectedFlights)
        
        // when
        let result = await flightSearchUseCase.getFlightsList()
        
        //then
        XCTAssertEqual(result, .success(expectedFlights.sorted()))
    }
    
    func testGetFlightsListFailure() async {
        // given
        flightRepository.getFlightsListReturnValue = .failure(.unknown)
        
        // when
        let result = await flightSearchUseCase.getFlightsList()
        
        //then
        XCTAssertEqual(result, .failure(.unknown))
    }
    
    func testSearchForFlightsSuccess() {
        // given
        let query = "query"
        let expectedFlights: [Flight] = [
            Flight(id: 1, coordinates: .init(), name: "Flight1", country: "Country1"),
            Flight(id: 2, coordinates: .init(), name: "Flight2", country: "Country2")
        ]
        let expectedResults: ArraySlice<Flight> = expectedFlights[0...0]
        FlightsSearchEngine.findCheapestRouteReturnValue = expectedResults
        
        // when
        let result = flightSearchUseCase.findCheapestRoute(query: query, initialCollection: expectedFlights)
        
        //then
        XCTAssertEqual(result, expectedResults)
    }
}

class MockFlightRepository: FlightRepository {
    var getFlightsListCalled = false
    var getFlightsListReturnValue: Result<[Flight], RequestError>!
    
    func getFlightsList() async -> Result<[Flight], RequestError> {
        getFlightsListCalled = true
        return getFlightsListReturnValue
    }
}

class MockFlightsSearchEngine: FlightsSearchEngine {
    var findCheapestRouteCalled = false
    var findCheapestRouteReturnValue: ArraySlice<Flight>?
    
    func findCheapestRoute(query: String, initialCollection: [Flight]) -> ArraySlice<Flight>? {
        findCheapestRouteCalled = true
        return findCheapestRouteReturnValue
    }
}
