//
//  FlightsSearchViewModelTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 15.04.2023.
//

import XCTest
@testable import FlightSearch

final class FlightsSearchViewModelTests: XCTestCase {
    
    var flightSearchUseCaseMock: FlightSearchUseCaseMock!
    var coordinationDelegateMock: FlightsSearchViewModelCoordinationDelegateMock!
    var presentationDelegateMock: FlightsSearchViewModelPresentationDelegateMock!
    var viewModel: FlightsSearchViewModel!
    
    override func setUp() {
        super.setUp()
        
        flightSearchUseCaseMock = FlightSearchUseCaseMock()
        viewModel = FlightsSearchViewModel(flightSearchUseCase: flightSearchUseCaseMock)
        coordinationDelegateMock = FlightsSearchViewModelCoordinationDelegateMock()
        presentationDelegateMock = FlightsSearchViewModelPresentationDelegateMock()
        viewModel.coordinationDelegate = coordinationDelegateMock
        viewModel.presentationDelegate = presentationDelegateMock
    }
    
    override func tearDown() {
        super.tearDown()
        flightSearchUseCaseMock = nil
        viewModel = nil
        coordinationDelegateMock = nil
        presentationDelegateMock = nil
    }
    
    func testDidSearch_WithValidRoutes_ShouldCallRouteFound() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.findCheapestRouteResult = Route(flights: [], totalCost: 0)
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        viewModel.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // When
            self.viewModel.didSearch(from: "Tokyo", to: "Sydney")
            
            // Then
            XCTAssertNotNil(self.viewModel.route)
            XCTAssertTrue(self.presentationDelegateMock.routeFoundCalled)
            XCTAssertFalse(self.presentationDelegateMock.routeDidNotFoundCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDidSearch_WithValidRoutes_ShouldCallRouteNotFound_WrongDestination() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.findCheapestRouteResult = nil
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        viewModel.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // When
            self.viewModel.didSearch(from: "Tokyo", to: "NotSydney")
            
            // Then
            XCTAssertNil(self.viewModel.route)
            XCTAssertFalse(self.presentationDelegateMock.routeFoundCalled)
            XCTAssertTrue(self.presentationDelegateMock.routeDidNotFoundCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDidSearch_WithValidRoutes_ShouldCallRouteNotFound_WrongDeparture() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.findCheapestRouteResult = nil
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        viewModel.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // When
            self.viewModel.didSearch(from: "NotTokyo", to: "Sydney")
            
            // Then
            XCTAssertNil(self.viewModel.route)
            XCTAssertFalse(self.presentationDelegateMock.routeFoundCalled)
            XCTAssertTrue(self.presentationDelegateMock.routeDidNotFoundCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDidSearch_WithValidRoutes_ShouldCallRouteNotFound_EmptyFields() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.findCheapestRouteResult = nil
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        viewModel.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // When
            self.viewModel.didSearch(from: "", to: "")
            
            // Then
            XCTAssertNil(self.viewModel.route)
            XCTAssertFalse(self.presentationDelegateMock.routeFoundCalled)
            XCTAssertTrue(self.presentationDelegateMock.routeDidNotFoundCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testDidSearch_WithValidRoutes_ShouldCallRouteNotFound_InvalidSearchAfterSuccessSearch() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.findCheapestRouteResult = Route(flights: [], totalCost: 0)
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        viewModel.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.didSearch(from: "Tokyo", to: "Sydney")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // When
            self.viewModel.didSearch(from: "Tokyo", to: "NotSydney")
            
            // Then
            XCTAssertNil(self.viewModel.route)
            XCTAssertTrue(self.presentationDelegateMock.routeDidNotFoundCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewOnMapTapped_WithRoute_ShouldCallShowFlightDetails() {
        // Given
        viewModel.route = Route(flights: [], totalCost: 0)
        
        // When
        viewModel.viewOnMapTapped()
        
        // Then
        XCTAssertTrue(coordinationDelegateMock.showFlightDetailsCalled)
    }
    
    func testViewOnMapTapped_WithoutRoute_ShouldNotCallShowFlightDetails() {
        // Given
        viewModel.route = nil
        
        // When
        viewModel.viewOnMapTapped()
        
        // Then
        XCTAssertFalse(coordinationDelegateMock.showFlightDetailsCalled)
    }
    
    func testViewDidLoad_WithSuccess_ShouldSetAllFlights() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.getFlightsListResult = .success([
            Flight(
                coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                from: "Tokyo",
                to: "Sydney",
                price: 100
            )
        ])
        
        // When
        viewModel.viewDidLoad()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.allFlights.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_WithFailure_ShouldNotSetAllFlights() {
        // Given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCaseMock.getFlightsListResult = .failure(.unknown)
        viewModel.allFlights = []
        
        // When
        viewModel.viewDidLoad()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.allFlights.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}

// Mock classes for testing

final class FlightSearchUseCaseMock: FlightSearchUseCase {
    
    var findCheapestRouteResult: Route?
    var getFlightsListResult: Result<[Flight], RequestError> = .success([])
    
    func findCheapestRoute(from: String, to: String, flights: [Flight]) -> Route? {
        return findCheapestRouteResult
    }
    
    func getFlightsList() async -> Result<[Flight], RequestError> {
        return getFlightsListResult
    }
}


final class FlightsSearchViewModelPresentationDelegateMock: FlightsSearchViewModelPresentationDelegate {
    var routeFoundCalled = false
    var routeFoundRoute: Route?
    var routeDidNotFoundCalled = false
    
    func routeFound(route: Route) {
        routeFoundCalled = true
        routeFoundRoute = route
    }
    
    func routeDidNotFound() {
        routeDidNotFoundCalled = true
    }
}

final class FlightsSearchViewModelCoordinationDelegateMock: FlightsSearchViewModelCoordinationDelegate {
    var showFlightDetailsCalled = false
    var showFlightDetailsRoute: Route?
    
    func showFlightDetails(_ route: Route) {
        showFlightDetailsCalled = true
        showFlightDetailsRoute = route
    }
}
