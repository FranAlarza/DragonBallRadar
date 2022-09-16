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
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var heroMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroImage.layer.cornerRadius = heroImage.bounds.size.width / 2
        setData()
        
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
    
    
}
