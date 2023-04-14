//
//  FlightDetailsBuilder.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import CoreLocation
import UIKit

enum FlightDetailsBuilder {

    static func build(route: Route) -> UIViewController {
        let viewModel = FlightDetailsViewModel(
            route: route
        )
        return FlightDetailsViewController.create(with: viewModel)
    }
}
