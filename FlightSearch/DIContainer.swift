//
//  DIContainer.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
final class AppDIContainer {
    
    lazy var searchEngine: SearchEngine = {
        DefaultSearchEngine()
    }()
}
