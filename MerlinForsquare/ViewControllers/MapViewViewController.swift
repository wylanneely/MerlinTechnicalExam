//
//  MapViewViewController.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/7/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapViewViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    //MARK:- Properties
    let manager = CLLocationManager()
    let controller = NetworkController()
    var venuePins: [VenuePin] = []
    var venues: [Venue]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        //check if venues have been loaded
        if let venues = venues {
            self.createPinsFrom(venues: venues)
        }
    }
    
    //MARK:- Annotation Pins
    
    func createPinsFrom(venues: [Venue]) {
        var pins: [VenuePin] = []
        for venue in venues {
            let pin: VenuePin = VenuePin(pinTitle: venue.venueName, pinSubtitle:"\( venue.venueDistance) meters away", location: venue.venueLocation)
            pins.append(pin)
        }
        self.venuePins = pins
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.venuePins)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let venueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            venueAnnotationView.animatesWhenAdded = true
            venueAnnotationView.titleVisibility = .adaptive
            venueAnnotationView.subtitleVisibility = .adaptive
            return venueAnnotationView
        }
        return nil
    }
    
    func addAnnotations(){
        if let venues = venues {
            for venue in venues {
                let annotation = VenuePin(pinTitle: venue.venueName, pinSubtitle: "\(venue.venueDistance) meters away", location: venue.venueLocation)
                self.venuePins.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.venuePins)
            }
        }
    }
    
    //MARK:- Map Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        self.mapView.showsUserLocation = true
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let clLocation = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude); NSLog("\(clLocation)")
        
        controller.loadVenuesNear(location: clLocation) { (venues) in
            if let venues = venues {
                self.venues = venues
                self.addAnnotations()
            }
        }
        
        //Span
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    //MARK:- Outlets
    
    @IBOutlet weak var mapView: MKMapView!

}
