//
//  CustomMKAnnotation.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 16/9/22.
//

import UIKit
import MapKit

class CustomMKAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var descriptionHero: String
    var photo: String
    
    init(title: String, coordenates: CLLocationCoordinate2D, descriptionHero: String, photo: String) {
        self.title = title
        self.coordinate = coordenates
        self.descriptionHero = descriptionHero
        self.photo = photo
    }
}
