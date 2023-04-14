//
//  FlightDetailsViewController.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import MapKit
import UIKit

final class FlightDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var viewModel: FlightDetailsViewModelPresentation!

    // MARK: Life Cycle

    static func create(with viewModel: FlightDetailsViewModelPresentation) -> FlightDetailsViewController {
        let view = FlightDetailsViewController.fromStoryboard(.flights)
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Route"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildRoute()
    }

    func buildRoute() {
        let coordinates = viewModel.getCoordinates()
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
    }
}

extension FlightDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}
