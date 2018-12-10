//
//  VenuePin.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/9/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class VenuePin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
        super.init()
    }
}
