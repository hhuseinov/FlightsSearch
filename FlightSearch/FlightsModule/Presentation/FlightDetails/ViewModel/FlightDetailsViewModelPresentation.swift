//
//  FlightDetailsViewModelPresentation.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
import CoreLocation
protocol FlightDetailsViewModelPresentation: AnyObject {
    
    func getCoordinates() -> [CLLocationCoordinate2D]
}
