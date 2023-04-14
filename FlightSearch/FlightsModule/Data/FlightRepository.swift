//
//  FlightRepository.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 19.04.2023.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidFile
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidFile:
            return "Invalid url"
        case .unknown:
            return "Unknown error"
        }
    }
}

protocol FlightRepository {
    func getFlightsList() async -> Result<[Flight], RequestError>
}

final class DefaultFlightRepository: FlightRepository {
    
    let path: String?

    init(path: String?) {
        self.path = path
    }

    func getFlightsList() async -> Result<[Flight], RequestError> {
        guard let path else {
            return .failure(.invalidFile)
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let flights = try decoder.decode(FlightsDTO.self, from: jsonData).connections
            return .success(flights)
        } catch {
            return .failure(.decode)
        }
    }
}
