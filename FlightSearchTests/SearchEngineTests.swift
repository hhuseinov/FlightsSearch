//
//  SearchEngineTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 19.04.2023.
//

import XCTest
@testable import FlightSearch
import CoreLocation

class DefaultSearchEngineTests: XCTestCase {
    
    var searchEngine: DefaultSearchEngine!
    let flights = [
        Flight(id: 1, coordinates: .init(), name: "London", country: "UK"),
        Flight(id: 1, coordinates: .init(), name: "London", country: "US"),
        Flight(id: 2, coordinates: .init(), name: "New York", country: "US"),
        Flight(id: 3, coordinates: .init(), name: "San Francisco", country: "US"),
        Flight(id: 4, coordinates: .init(), name: "Tokyo", country: "Japan")
    ]
    
    override func setUp() {
        super.setUp()
        searchEngine = DefaultSearchEngine()
    }
    
    override func tearDown() {
        searchEngine = nil
        super.tearDown()
    }
    
    func testBinarySearchWithNumbersSortedArrayMissingResults() {
        // given
        let sortedArray = [1, 3, 5, 7, 9]
        
        // when
        let missingResult = searchEngine.binarySearch(
            array: sortedArray,
            predicate: { $0 == 4 },
            isBiggerThan: { $0 > 4 }
        )
        
        //then
        XCTAssertNil(missingResult)
    }
    
    func testBinarySearchWithNumbersSortedArray() {
        // given
        let sortedArray = [1, 3, 5, 7, 9]
        
        // when
        let result = searchEngine.binarySearch(
            array: sortedArray,
            predicate: { $0 == 5 },
            isBiggerThan: { $0 > 5 }
        )
        
        //then
        XCTAssertEqual(result, sortedArray[2...2])
    }
    
    func testBinarySearchWithNumbersUnsortedArray() {
        // given
        let unsortedArray = [9, 5, 1, 7, 3]
        
        // when
        let sortedResult = searchEngine.binarySearch(
            array: unsortedArray,
            predicate: { $0 == 5 },
            isBiggerThan: { $0 > 5 }
        )
        
        //then
        XCTAssertEqual(sortedResult, unsortedArray[1...1])
    }

    func testSearchForFlightsFirstLetter() {
        // when
        let result = searchEngine.findCheapestRoute(query: "n", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0 + (result?.startIndex ?? 0)].id, 2)
        XCTAssertEqual(result?[0 + (result?.startIndex ?? 0)].name, "New York")
        XCTAssertEqual(result?[0 + (result?.startIndex ?? 0)].country, "US")
    }
    
    func testSearchForFlightsWithNonExistentQuery() {
        // when
        let result = searchEngine.findCheapestRoute(query: "x", initialCollection: flights)
        
        //then
        XCTAssertNil(result)
    }
    
    func testSearchForFlightsWithEmptyQuery() {
        // when
        let result = searchEngine.findCheapestRoute(query: "", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, flights.count)
    }
    
    func testSearchForFlightsPrefix() {
        // when
        let result = searchEngine.findCheapestRoute(query: "Lon", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.first?.name, "London")
    }
    
    func testSearchForFlightsPrefixLowercase() {
        // when
        let result = searchEngine.findCheapestRoute(query: "lon", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.first?.name, "London")
    }
    
    func testSearchForFlightsPrefixUppercase() {
        // when
        let result = searchEngine.findCheapestRoute(query: "LON", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.first?.name, "London")
    }
    
    func testSearchForFlightsSameFlightsDifferentCountriesOrder() {
        // when
        let result = searchEngine.findCheapestRoute(query: "LON", initialCollection: flights)
        
        //then
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.first?.name, "London")
        XCTAssertEqual(result?.first?.country, "UK")
        XCTAssertEqual(result?.last?.name, "London")
        XCTAssertEqual(result?.last?.country, "US")
    }
    
    func testSearchForFlightsNoMatch() {
        // when
        let result = searchEngine.findCheapestRoute(query: "Foo", initialCollection: flights)
        
        //then
        XCTAssertNil(result)
    }
}
