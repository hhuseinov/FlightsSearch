//
//  FlightRepositoryTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 19.04.2023.
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
                Flight(id: 707860, coordinates: CLLocationCoordinate2D(latitude: 44.549999, longitude: 34.283333), name: "Hurzuf", country: "UA"),
                Flight(id: 519188, coordinates: CLLocationCoordinate2D(latitude: 55.683334, longitude: 37.666668), name: "Novinki", country: "RU"),
                Flight(id: 1283378, coordinates: CLLocationCoordinate2D(latitude: 28, longitude: 84.633331), name: "Gorkhā", country: "NP"),
                Flight(id: 1270260, coordinates: CLLocationCoordinate2D(latitude: 29, longitude: 76), name: "State of Haryāna", country: "IN")
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
