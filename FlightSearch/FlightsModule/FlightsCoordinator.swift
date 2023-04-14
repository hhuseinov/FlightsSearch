//
//  FlightsCoordinator.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import UIKit

final class FlightsCoordinator: BaseCoordinator {

    // MARK: Private Variables

    private weak var navigationController: UINavigationController?
    private let searchEngine: FlightsSearchEngine

    // MARK: Lifecycle

    init(
        navigationController: UINavigationController,
        searchEngine: FlightsSearchEngine
    ) {
        self.navigationController = navigationController
        self.searchEngine = searchEngine
    }

    func start() {
        navigateToFlightSearch()
    }

    private func navigateToFlightSearch() {
        let (flightsListViewController, flightsViewModel) = FlightsSearchBuilder.build(searchEngine: searchEngine)
        flightsViewModel.coordinationDelegate = self
        navigationController?.viewControllers = [flightsListViewController]
    }

    private func navigateToFlightDetails(_ route: Route) {
        let vc = FlightDetailsBuilder.build(route: route)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: -

extension FlightsCoordinator: FlightsSearchViewModelCoordinationDelegate {
    func showFlightDetails(_ route: Route) {
        navigateToFlightDetails(route)
    }
}
