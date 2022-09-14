//
//  Extension+MapView.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 12/9/22.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        
        self.setRegion(coordinateRegion, animated: true)
    }
}
