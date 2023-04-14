//
//  FlightsSearchViewModelTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 19.04.2023.
//

import XCTest
@testable import FlightSearch

class FlightsSearchViewModelTests: XCTestCase {

    var viewModel: FlightsSearchViewModel!
    var flightSearchUseCase: FlightSearchUseCaseMock!
    let flights = [
        Flight(id: 1, coordinates: .init(), name: "London", country: "UK"),
        Flight(id: 1, coordinates: .init(), name: "London", country: "US"),
        Flight(id: 2, coordinates: .init(), name: "New York", country: "US"),
        Flight(id: 3, coordinates: .init(), name: "San Francisco", country: "US"),
        Flight(id: 4, coordinates: .init(), name: "Tokyo", country: "Japan")
    ]
    
    override func setUp() {
        super.setUp()
        flightSearchUseCase = FlightSearchUseCaseMock()
        viewModel = FlightsSearchViewModel(flightSearchUseCase: flightSearchUseCase)
    }

    override func tearDown() {
        viewModel = nil
        flightSearchUseCase = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCase.getFlightsListReturnValue = .success(flights)

        // when
        viewModel.viewDidLoad()

        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.displayFlights, ArraySlice(self.flights))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testViewDidLoadFailure() {
        // given
        flightSearchUseCase.getFlightsListReturnValue = .failure(.decode)

        // when
        viewModel.viewDidLoad()

        // then
        XCTAssertEqual(viewModel.displayFlights, [])
    }

    func testDidSearchEmptyQuery() {
        // given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCase.getFlightsListReturnValue = .success(flights)
        viewModel.viewDidLoad()
        flightSearchUseCase.findCheapestRouteReturnValue = ArraySlice(flights)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // when
            self.viewModel.didSearch(query: "")
            
            // then
            XCTAssertEqual(self.viewModel.displayFlights, ArraySlice(self.flights))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDidSearchNoResults() {
        // given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCase.getFlightsListReturnValue = .success(flights)
        viewModel.viewDidLoad()
        flightSearchUseCase.findCheapestRouteReturnValue = ArraySlice<Flight>()

        XCTAssertEqual(viewModel.displayFlights, [])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // when
            self.viewModel.didSearch(query: "Chicago")
            
            // then
            XCTAssertEqual(self.viewModel.displayFlights, [])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDidSearchWithResults() {
        // given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCase.getFlightsListReturnValue = .success(flights)
        viewModel.viewDidLoad()
        flightSearchUseCase.findCheapestRouteReturnValue = flights[2...2]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // when
            self.viewModel.didSearch(query: "New")
            
            // then
            XCTAssertEqual(self.viewModel.displayFlights, self.flights[2...2])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDidCancelSearch() {
        // given
        let expectation = XCTestExpectation(description: "View did load")
        flightSearchUseCase.getFlightsListReturnValue = .success(flights)
        viewModel.viewDidLoad()
        flightSearchUseCase.findCheapestRouteReturnValue = flights[2...2]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // when
            self.viewModel.didSearch(query: "New")
            self.viewModel.didCancelSearch()
            
            // then
            XCTAssertEqual(self.viewModel.displayFlights, ArraySlice(self.flights))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

}

class FlightSearchUseCaseMock: FlightSearchUseCase {

    var getFlightsListReturnValue: Result<[Flight], RequestError> = .failure(.decode)
    var findCheapestRouteReturnValue: ArraySlice<Flight>?

    func getFlightsList() async -> Result<[Flight], RequestError> {
        return getFlightsListReturnValue
    }

    func findCheapestRoute(query: String, initialCollection: [Flight]) -> ArraySlice<Flight>? {
        return findCheapestRouteReturnValue
    }
}
