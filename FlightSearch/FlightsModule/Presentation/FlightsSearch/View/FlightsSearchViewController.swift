//
//  FlightsSearchViewController.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import UIKit

final class FlightsSearchViewController: UIViewController {
        
    private var viewModel: FlightsSearchViewModelPresentation!

    @IBOutlet weak var viewOnMapButton: UIButton!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var fromField: UITextField!
    // MARK: Life Cycle

    static func create(with viewModel: FlightsSearchViewModelPresentation) -> FlightsSearchViewController {
        let view = FlightsSearchViewController.fromStoryboard(.flights)
        view.viewModel = viewModel
        view.viewModel.presentationDelegate = view
        return view
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        resetResults()
        viewModel.didSearch(from: fromField.text, to: toField.text)
    }
    
    @IBAction func viewOnMapTapped(_ sender: Any) {
        viewModel.viewOnMapTapped()
    }
}

// MARK: - FlightsSearchViewModelPresentationDelegate

extension FlightsSearchViewController: FlightsSearchViewModelPresentationDelegate {
    
    func routeFound(route: Route) {
        viewOnMapButton.isEnabled = true
        routeLabel.text = route.routeDescription
        costLabel.text = String(format: "%i$", route.totalCost)
    }
    
    func routeDidNotFound() {
        resetFields()
    }
}

// MARK: - Helpers

extension FlightsSearchViewController {
    
    func resetResults() {
        costLabel.text = "Total cost will appear here"
        routeLabel.text = "Route will appear here"
        viewOnMapButton.isEnabled = false
    }
    func resetFields() {
        toField.text = ""
        fromField.text = ""
    }
}
