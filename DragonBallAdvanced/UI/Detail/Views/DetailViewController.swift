//
//  DetailViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 14/9/22.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var annotation: CustomMKAnnotation?
    var hero: PersistenceHeros?
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var heroMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroImage.layer.cornerRadius = heroImage.bounds.size.width / 2
        if annotation == nil {
            setHero()
        } else {
            setData()
        }
        
    }
    
    // MARK: - FUNCTIONS
    
    func setData() {
        heroImage.downloadImage(from: self.annotation?.photo ?? "")
        heroName.text = self.annotation?.title
        heroDescription.text = self.annotation?.descriptionHero
        let point = MKPointAnnotation()
        point.title = self.annotation?.title
        point.coordinate = CLLocationCoordinate2D(latitude: annotation?.coordinate.latitude ?? 0,
                                                  longitude: annotation?.coordinate.longitude ?? 0)
        let region = MKCoordinateRegion(center: point.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        heroMap.addAnnotation(point)
        heroMap.setRegion(region, animated: true)
    }
    
    func setHero() {
        heroImage.downloadImage(from: self.hero?.photo ?? "")
        heroName.text = self.hero?.name
        heroDescription.text = self.hero?.descripcion
        
        
        let point = MKPointAnnotation()
        point.title = self.hero?.name
        
        if self.hero?.latitud == 0.0 && self.hero?.longitud == 0.0 {
            self.hero?.latitud = Double((0...90).randomElement() ?? 0)
            self.hero?.longitud = Double((-180...180).randomElement() ?? 0)
        }
        point.coordinate = CLLocationCoordinate2D(latitude: self.hero?.latitud ?? 0,
                                                  longitude: self.hero?.longitud ?? 0)
        
        let region = MKCoordinateRegion(center: point.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        heroMap.addAnnotation(point)
        heroMap.setRegion(region, animated: true)
    }
}
