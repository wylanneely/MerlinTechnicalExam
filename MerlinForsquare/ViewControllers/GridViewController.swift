//
//  GridViewController.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/7/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GridViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //MARK:- Properties
    
    let controller = NetworkController()
    let imageController = ImageController()
    var venues: [Venue] = []
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        venueTableview.delegate = self
        venueTableview.dataSource = self
        setUpLocationManager()
    }
    
    //MARK:- Location Manager
    
    func setUpLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        controller.loadVenuesNear(location: location) { (venues) in
            if let venues = venues { self.venues = venues }
            self.venueTableview.reloadData()
            self.venueTableview.reloadInputViews()
        }
    }
   
    //MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let venue = venues[indexPath.row]
        let venueCell = Bundle.main.loadNibNamed("VenueTableViewCell", owner: self, options: nil)?.first as! VenueTableViewCell
        venueCell.name.text = venue.venueName
        venueCell.city.text = venue.venueCity
        venueCell.distance.text = "\(venue.venueDistance) meters away"
        let image = imageController.getImagefor(venue: venue)
        venueCell.setImage(venueImage: image)
        
        return venueCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
   
    //MARK:- Outlets
    
    @IBOutlet weak var venueTableview: UITableView!
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mapViewController = segue.destination as? MapViewViewController {
//            mapViewController.venues = self.venues
//        }
//    }


}
