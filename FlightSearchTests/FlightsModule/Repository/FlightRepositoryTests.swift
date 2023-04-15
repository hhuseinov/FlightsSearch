//
//  FlightRepositoryTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 15.04.2023.
//

import XCTest
@testable import FlightSearch
import CoreLocation

class DefaultFlightRepositoryTests: XCTestCase {

    func testGetFlightsListSuccess() async {
        // given
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "correct", ofType: "json") else {
            XCTFail("Failed to load JSON file")
            return
        }
        let repository = DefaultFlightRepository(path: path)
        
        // when
        let result = await repository.getFlightsList()

        //then
        switch result {
        case .success(let flights):
            XCTAssertEqual(flights.count, 4)
            let expectedFlights = [
                Flight(
                    coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 51.5285582, long: -0.241681),
                                                     to: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478)),
                    from: "London",
                    to: "Tokyo",
                    price: 220
                ),
                Flight(
                    coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                     to: Flight.Coordinates.Location(lat: 51.5285582, long: -0.241681)),
                    from: "Tokyo",
                    to: "London",
                    price: 200
                ),
                Flight(
                    coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 51.5285582, long: -0.241681),
                                                     to: Flight.Coordinates.Location(lat: 41.14961, long: -8.61099)),
                    from: "London",
                    to: "Porto",
                    price: 50
                ),
                Flight(
                    coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 35.652832, long: 139.839478),
                                                     to: Flight.Coordinates.Location(lat: -33.865143, long: 151.2099)),
                    from: "Tokyo",
                    to: "Sydney",
                    price: 100
                )
            ]
            XCTAssertEqual(flights, expectedFlights)
        case .failure:
            XCTFail("Expected success, got failure")
        }
    }

    func testGetFlightsListDecodeError() async {
        // given
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "decodeError", ofType: "json") else {
            XCTFail("Failed to load JSON file")
            return
        }
        let repository = DefaultFlightRepository(path: path)
        
        // when
        let result = await repository.getFlightsList()

        //then
        switch result {
        case .success:
            XCTFail("Expected failure, got success")
        case .failure(let error):
            XCTAssertEqual(error, .decode)
        }
    }
}
