//
//  FlightsListPresentation.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation

protocol FlightsSearchViewModelPresentationDelegate: AnyObject {
    func routeFound(route: Route)
    func routeDidNotFound()
}

protocol FlightsSearchViewModelPresentation: AnyObject {
    
    var presentationDelegate: FlightsSearchViewModelPresentationDelegate? { get set }

    func viewDidLoad()
    func didSearch(from: String?, to: String?)
    func viewOnMapTapped()
}
