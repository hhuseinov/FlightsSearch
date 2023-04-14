//
//  SearchEngine.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation

typealias SearchEngine = FlightsSearchEngine

protocol Graphable {
    associatedtype T: Hashable
    var from: T { get set }
    var to: T { get set }
    var weight: Int { get set }
}

private protocol SearchMethods {
    func dijkstra<T: Hashable>(
        start: T,
        end: T,
        graph: [T: [(to: T, weight: Int)]]
    ) -> (path: [T], totalCost: Int)?
}

final class DefaultSearchEngine: SearchMethods {
    func dijkstra<T: Hashable>(
        start: T,
        end: T,
        graph: [T: [(to: T, weight: Int)]]
    ) -> (path: [T], totalCost: Int)? {
        
        var costs: [T: Int] = [:]
        var parents: [T: T] = [:]
        var processed: Set<T> = []
        
        costs[start] = 0
        
        var queue: [(node: T, cost: Int)] = [(node: start, cost: 0)]
        
        while !queue.isEmpty {
            queue.sort { $0.cost < $1.cost }
            let current = queue.removeFirst()
            
            let node = current.node
            let cost = current.cost
            
            if node == end {
                break
            }
            
            if processed.contains(node) {
                continue
            }
            
            processed.insert(node)
            
            guard let connections = graph[node] else {
                continue
            }
            
            for connection in connections {
                let nextNode = connection.to
                let nextCost = cost + connection.weight
                
                if let existingCost = costs[nextNode], existingCost <= nextCost {
                    continue
                }
                
                costs[nextNode] = nextCost
                parents[nextNode] = node
                
                queue.append((node: nextNode, cost: nextCost))
            }
        }
        if parents[end] == nil {
            return nil
        }
        
        var path: [T] = []
        var currentNode = end
        while let parentNode = parents[currentNode] {
            path.append(currentNode)
            currentNode = parentNode
        }
        
        path.append(start)
        path.reverse()
        let totalCost = costs[end]!
        
        return (path, totalCost)
    }
}

//MARK: - Helpers
extension DefaultSearchEngine {
    
    func buildGraph<T: Hashable, G: Graphable>(
        initialArray: [G]
    ) -> [T: [(to: T, weight: Int)]] where G.T == T {
        var graph: [T: [(to: T, weight: Int)]] = [:]
        for value in initialArray {
            if graph[value.from] == nil {
                graph[value.from] = []
            }
            graph[value.from]?.append((to: value.to, weight: value.weight))
        }
        return graph
    }
}
