//
//  MapHeroesViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 9/9/22.
//

import UIKit
import MapKit
import CoreLocation

protocol MapHeroesProtocol: AnyObject {
    func showUserLocation()
}

class MapHeroesViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var heroMap: MKMapView!
    
    // MARK: - VARIABLES
    var viewModel = MapHeroesViewModel()
    
    // MARK: - CONSTANTS
    let locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        showUserLocation()
        // View Model Calls
        viewModel.onSuccess = { [weak self] in
            self?.heroMap.addAnnotations(self?.viewModel.putHeroInMap() ?? [])
        }
        viewModel.createCustomMKAnnotation = { hero in
            let characterLocation = CustomMKAnnotation(title: hero.name ?? "",
                                                               coordenates: CLLocationCoordinate2D(latitude: hero.latitud, longitude: hero.longitud),
                                                               descriptionHero: hero.descripcion ?? "",
                                                               photo: hero.photo ?? "")
            return characterLocation
            
        }
        viewModel.getCharacters()
        viewModel.onViewsLoaded()
        heroMap.delegate = self
        searchController.searchResultsUpdater = self
    }
}


extension MapHeroesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CustomMKAnnotation else { return nil }
        
        let identifier = "custom"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? CustomMKAnnotation else { return }
        let nextVC = DetailViewController()
        nextVC.annotation = annotation
        navigationController?.pushViewController(nextVC, animated: true)
        view.setSelected(false, animated: true)
    }
}

extension MapHeroesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let predicate = NSPredicate(format: "name CONTAINS %@", text)
        guard let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultController.viewModel = SearchResultsViewModel(delegate: resultController)
        resultController.viewModel?.fetchResultHeroes(with: predicate)
    }
}

extension MapHeroesViewController: MapHeroesProtocol {
    func showUserLocation() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.requestAlwaysAuthorization()
            }
            self?.heroMap.showsUserLocation = true
        }
    }
}
