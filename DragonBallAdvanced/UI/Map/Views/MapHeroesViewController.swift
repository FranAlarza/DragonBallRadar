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
    func createPointAnnotation(heroName: String, latitud: Double, longitud: Double)
}

class MapHeroesViewController: UIViewController{
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var heroMap: MKMapView!
    
    // MARK: - VARIABLES
    var viewModel: MapHeroesViewModelProtocol?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getCharacters()
        viewModel?.fetchHeroesFromCoreData()
        showUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.putHeroInMap()
    }


}

extension MapHeroesViewController: MapHeroesProtocol {
    func showUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
        }
        heroMap.showsUserLocation = true
    }
    
    func createPointAnnotation(heroName: String, latitud: Double, longitud: Double) {
        let characterLocation = MKPointAnnotation()
        characterLocation.title = heroName
        characterLocation.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        heroMap.addAnnotation(characterLocation)
    }
}
