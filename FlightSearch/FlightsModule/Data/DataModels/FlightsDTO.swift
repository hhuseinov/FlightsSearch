//
//  FlightDTO.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation
import CoreLocation

// MARK: - Data Transfer Object
struct FlightsDTO: Decodable {
    let connections: [Flight]
}
