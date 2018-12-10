//
//  ForsquareVenue.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/4/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Venue {
    
    //MARK:- Venue Properties
    
    var venueID: String = ""
    var venueName: String = ""
    var venueDistance: Int = 0
    var venueCity: String = ""
    var latitudeString: String = ""
    var longitudeString: String = ""
    var image: UIImage = UIImage()
    
    //computed property
    var venueLocation: CLLocationCoordinate2D {
        
        guard let latitudeDouble = latitudeString.toDouble(),
            let longitudeDouble = longitudeString.toDouble() else { return CLLocationCoordinate2D() }
        
        let latidudeLocation = CLLocationDegrees(exactly: latitudeDouble)
        let longitudeLocation = CLLocationDegrees(exactly: longitudeDouble)
        
        let location = CLLocation(latitude: latidudeLocation!, longitude: longitudeLocation!)
        
        return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    //MARK:- JSON init
    
    //Keys
    let kVenueID = "id"
    let kVenueName = "name"
    let kLocation = "location"
    let kCity = "city"
    let kDistance = "distance"
    let kLat = "lat"
    let kLong = "lng"
    
    init(jsonData: [String:Any]) {
        
        //small error handling normally would have done the data parsing with a seperatecontroller
        if let venueName = jsonData[kVenueName] as? String { self.venueName = venueName }
          else { NSLog("Error loading venue name"); self.venueName = "unknown"}
        
        if let venueID = jsonData[kVenueID] as? String { self.venueID = venueID }
          else { NSLog("Error loading venue id"); self.venueID = "0" }
        
        if let locationJson = jsonData[kLocation] as? [String:Any] {
            
            if let latitude = locationJson[kLat] as? String { self.latitudeString = latitude}
            else { NSLog("Error loading venue latitude"); self.latitudeString = "0" }
            
            if let longitude = locationJson[kLong] as? String { self.longitudeString = longitude}
            else { NSLog("Error loading venue latitude"); self.latitudeString = "0" }
            
            if let city = locationJson[kCity] as? String { self.venueCity = city }
              else { NSLog("Error loading venue city"); self.venueCity = "unknown" }
            
        if let distance = locationJson[kDistance] as? Int { self.venueDistance = distance}
              else { NSLog("Error loading distance to venue"); self.venueDistance = 0 }
            
        } else { NSLog("Error loading venue all location details"); self.venueCity = "unknown"}
        }

}
