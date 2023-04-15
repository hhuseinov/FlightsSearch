//
//  FlightSearchUseCaseTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 15.04.2023.
//

import XCTest
@testable import FlightSearch

class FlightSearchUseCaseTests: XCTestCase {
    
    // MARK: - Mocks
    
    class MockFlightRepository: FlightRepository {
        var getFlightsListResult: Result<[Flight], RequestError>?
        var getFlightsListCalled = false
        
        func getFlightsList() async -> Result<[Flight], RequestError> {
            getFlightsListCalled = true
            return getFlightsListResult ?? .success([])
        }
    }
    
    class MockFlightsSearchEngine: FlightsSearchEngine {
        var findCheapestRouteResult: Route?
        var findCheapestRouteCalled = false
        
        func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route? {
            findCheapestRouteCalled = true
            return findCheapestRouteResult
        }
    }
    
    // MARK: - Tests
    
    func testGetFlightsList_Success_CallsFlightRepository() async {
        // Given
        let mockFlightRepository = MockFlightRepository()
        mockFlightRepository.getFlightsListResult = .success([Flight]())
        let sut = DefaultFlightSearchUseCase(flightRepository: mockFlightRepository, searchEngine: MockFlightsSearchEngine())
        
        // When
        let result = await sut.getFlightsList()
        
        // Then
        XCTAssertTrue(mockFlightRepository.getFlightsListCalled)
        XCTAssertNotNil(result)
    }
    
    func testGetFlightsList_Failure_CallsFlightRepository() async {
        // Given
        let mockFlightRepository = MockFlightRepository()
        mockFlightRepository.getFlightsListResult = .failure(.decode)
        let sut = DefaultFlightSearchUseCase(flightRepository: mockFlightRepository, searchEngine: MockFlightsSearchEngine())
        
        // When
        let result = await sut.getFlightsList()
        
        // Then
        XCTAssertTrue(mockFlightRepository.getFlightsListCalled)
        XCTAssertNotNil(result)
    }
    
    func testFindCheapestRoute_Success_CallsFlightsSearchEngine() {
        // Given
        let mockFlightsSearchEngine = MockFlightsSearchEngine()
        mockFlightsSearchEngine.findCheapestRouteResult = Route(flights: [], totalCost: 0)
        let sut = DefaultFlightSearchUseCase(flightRepository: MockFlightRepository(), searchEngine: mockFlightsSearchEngine)
        
        // When
        let result = sut.findCheapestRoute(from: "", to: "", flights: [])
        
        // Then
        XCTAssertTrue(mockFlightsSearchEngine.findCheapestRouteCalled)
        XCTAssertNotNil(result)
    }
    
    func testFindCheapestRoute_Failure_CallsFlightsSearchEngine() {
        // Given
        let mockFlightsSearchEngine = MockFlightsSearchEngine()
        mockFlightsSearchEngine.findCheapestRouteResult = nil // Set failure result in mock
        let sut = DefaultFlightSearchUseCase(flightRepository: MockFlightRepository(), searchEngine: mockFlightsSearchEngine)
        
        // When
        let result = sut.findCheapestRoute(from: "", to: "", flights: [])
        
        // Then
        XCTAssertTrue(mockFlightsSearchEngine.findCheapestRouteCalled)
        XCTAssertNil(result)
    }
}
