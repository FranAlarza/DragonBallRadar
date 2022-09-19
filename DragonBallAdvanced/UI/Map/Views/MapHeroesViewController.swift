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
    func createPointAnnotation(with model: PersistenceHeros)
}

class MapHeroesViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var heroMap: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - VARIABLES
    var viewModel: MapHeroesViewModelProtocol?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUserLocation()
        viewModel?.getCharacters()
        viewModel?.onViewsLoaded()
        heroMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension MapHeroesViewController: MapHeroesProtocol {
    func showUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
        }
        heroMap.showsUserLocation = true
    }
    
    func createPointAnnotation(with model: PersistenceHeros) {
        let characterLocation = CustomMKAnnotation(title: model.name ?? "",
                                                   coordenates: CLLocationCoordinate2D(latitude: model.latitud, longitude: model.longitud),
                                                   descriptionHero: model.descripcion ?? "",
                                                   photo: model.photo ?? "")
        heroMap.addAnnotation(characterLocation)
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
