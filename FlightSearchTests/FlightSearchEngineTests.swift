//
//  FlightSearchTests.swift
//  FlightSearchTests
//
//  Created by Husein Huseinau on 15.04.2023.
//

import XCTest
@testable import FlightSearch

final class DefaultSearchEngineTests: XCTestCase {
    
    var searchEngine: DefaultSearchEngine!
    var flights: [Flight]!
    
    let testGraph: [String: [(to: String, weight: Int)]] = [
        "A": [("B", 1), ("C", 2)],
        "B": [("D", 3)],
        "C": [("E", 1)],
        "D": [("E", 2), ("F", 4)],
        "E": [("F", 1), ("G", 3)],
        "F": [("G", 2)],
        "G": []
    ]
    
    override func setUp() {
        super.setUp()
        searchEngine = DefaultSearchEngine()
        
        let flight1 = Flight(coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 0, long: 0),
                                                             to: Flight.Coordinates.Location(lat: 1, long: 1)),
                             from: "A", to: "B", price: 100)
        let flight2 = Flight(coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 0, long: 0),
                                                             to: Flight.Coordinates.Location(lat: 2, long: 2)),
                             from: "A", to: "C", price: 200)
        let flight3 = Flight(coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 1, long: 1),
                                                             to: Flight.Coordinates.Location(lat: 2, long: 2)),
                             from: "B", to: "C", price: 50)
        let flight4 = Flight(coordinates: Flight.Coordinates(from: Flight.Coordinates.Location(lat: 2, long: 2),
                                                             to: Flight.Coordinates.Location(lat: 3, long: 3)),
                             from: "C", to: "D", price: 150)
        
        flights = [flight1, flight2, flight3, flight4]
    }
    
    override func tearDown() {
        super.tearDown()
        searchEngine = nil
        flights = nil
    }
    
    func testDijkstra() {
        // Test case 1: Finding path from "A" to "G"
        let result1 = searchEngine.dijkstra(start: "A", end: "G", graph: testGraph)
        XCTAssertEqual(result1?.path, ["A", "C", "E", "G"])
        XCTAssertEqual(result1?.totalCost, 6)
        
        // Test case 2: Finding path from "B" to "F"
        let result2 = searchEngine.dijkstra(start: "B", end: "F", graph: testGraph)
        XCTAssertEqual(result2?.path, ["B", "D", "E", "F"])
        XCTAssertEqual(result2?.totalCost, 6)
        
        // Test case 3: Finding path from "A" to "H" (Non-existent end node)
        let result3 = searchEngine.dijkstra(start: "A", end: "H", graph: testGraph)
        XCTAssertNil(result3)
        
        // Test case 4: Finding path from "G" to "F" (Non-existent start node)
        let result4 = searchEngine.dijkstra(start: "G", end: "F", graph: testGraph)
        XCTAssertNil(result4)
        
        // Test case 5: Finding path from "D" to "A" (Backward path)
        let result5 = searchEngine.dijkstra(start: "D", end: "A", graph: testGraph)
        XCTAssertNil(result5)
    }
    
    func testDijkstra_WithDisconnectedGraph() {
        let start = "A"
        let end = "G"
        let disconnectedGraph = [
            "A": [(to: "B", weight: 1)],
            "B": [(to: "C", weight: 2)],
            "C": [(to: "D", weight: 3)],
            "D": [(to: "E", weight: 4)],
            "E": [(to: "F", weight: 5)],
            "G": [] // Disconnected node
        ]
        let result = searchEngine.dijkstra(start: start, end: end, graph: disconnectedGraph)
        XCTAssertNil(result, "Result should be nil for disconnected graph")
    }
    
    func testDijkstra_WithEmptyGraph() {
        let start = "A"
        let end = "F"
        let emptyGraph: [String: [(to: String, weight: Int)]] = [:] // Empty graph
        let result = searchEngine.dijkstra(start: start, end: end, graph: emptyGraph)
        XCTAssertNil(result, "Result should be nil for empty graph")
    }
    
    func testBuildGraph() {
        // Create an array of MockGraphable objects
        let initialArray = [
            MockGraphable(from: "A", to: "B", weight: 1),
            MockGraphable(from: "B", to: "C", weight: 2),
            MockGraphable(from: "A", to: "C", weight: 3),
            MockGraphable(from: "D", to: "A", weight: 4)
        ]
        
        // Create an instance of DefaultSearchEngine
        let searchEngine = DefaultSearchEngine()
        
        // Call the buildGraph method with the initialArray
        let graph = searchEngine.buildGraph(initialArray: initialArray)
        
        // Assert the expected graph structure
        XCTAssertEqual(graph.count, 3)
        XCTAssertEqual(graph["A"]?.count, 2)
        XCTAssertEqual(graph["B"]?.count, 1)
        XCTAssertEqual(graph["C"]?.count, nil)
        XCTAssertEqual(graph["D"]?.count, 1)
        
        // Assert the expected connections for each node
        XCTAssertEqual(graph["A"]?.contains(where: { $0.to == "B" && $0.weight == 1 }), true)
        XCTAssertEqual(graph["A"]?.contains(where: { $0.to == "C" && $0.weight == 3 }), true)
        XCTAssertEqual(graph["B"]?.contains(where: { $0.to == "C" && $0.weight == 2 }), true)
        XCTAssertEqual(graph["D"]?.contains(where: { $0.to == "A" && $0.weight == 4 }), true)
    }
    
    func testConvertPathToRoute() {
        // Test with valid path
        let path = ["A", "B", "C", "D"]
        let convertedRoute = searchEngine.convertPathToRoute(path: path, flights: flights)
        XCTAssertEqual(convertedRoute.count, 3)
        
        // Test with invalid path
        let invalidPath = ["A", "C", "D"]
        let invalidConvertedRoute = searchEngine.convertPathToRoute(path: invalidPath, flights: flights)
        XCTAssertEqual(invalidConvertedRoute.count, 2)
    }
}

final class MockGraphable<T: Hashable>: Graphable {
    var from: T
    var to: T
    var weight: Int
    
    init(from: T, to: T, weight: Int) {
        self.from = from
        self.to = to
        self.weight = weight
    }
}
