//
//  FlightsSearchBuilder.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation
import class UIKit.UIViewController

enum FlightsSearchBuilder {
    
    // MARK: Typealiases

    typealias FlightsSearchBuild = (UIViewController, FlightsSearchViewModelCoordination)

    // MARK: Public Methods

    static func build(searchEngine: FlightsSearchEngine) -> FlightsSearchBuild {
        let viewModel = FlightsSearchViewModel(
            flightSearchUseCase: makeFlightSearchUseCase(searchEngine: searchEngine)
        )
        let viewController = FlightsSearchViewController.create(with: viewModel)
        return (viewController, viewModel)
    }

    // MARK: Private Methods
    private static func makeFlightSearchUseCase(searchEngine: FlightsSearchEngine) -> FlightSearchUseCase {
        DefaultFlightSearchUseCase(flightRepository: makeFlightRepository(), searchEngine: searchEngine)
    }
    
    private static func makeFlightRepository() -> FlightRepository {
        DefaultFlightRepository(path: Bundle.main.path(forResource: "flights", ofType: "json"))
    }
}
