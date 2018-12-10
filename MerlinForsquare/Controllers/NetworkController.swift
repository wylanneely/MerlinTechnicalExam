//
//  InternetController.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/4/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire


class NetworkController {
    
    //singleton
    static let shared = NetworkController()
    
    //MARK:- Client Authorization
    
    let clientID: String = "FI2I5WD4WSOTRVNPAXDHCRGNGH0LDPDR4QOMNUGQRPWEA1MO"
    let clientSecret: String = "FKHFYXIXAK5ESGOMDR4JXFPVCC0QAYXKWLPVQJPX1AMKRC21"
    
    let baseURl: URL = URL(string: "https://api.foursquare.com/v2/venues/search")!
    
    // keys
    let kClientID: String = "client_id"
    let kClientSecret: String = "client_secret"
    let kLimit: String = "limit"
    let kRadius: String = "radius"

    //MARK:- Venues
    //should have made a seperate venue controller for this, but not much time
    func loadVenuesNear(location: CLLocation , completion: @escaping(_ venues: [Venue]?) -> Void) {
        
        var Venues: [Venue] = []
        
        //try switch here
        let ll: String = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                
        let peramaters: [String:String] = [kClientID:clientID,
                                           kClientSecret: clientSecret,
                                           "v": "20180323",
                                           "ll": ll ,
                                           kLimit : "15", // Limit of venues pulled up, use 1 while testing for photos
                                           kRadius : "100"] 

        let venueUrl = url(byAdding: peramaters, to: baseURl)

        Alamofire.request(venueUrl, headers: nil).responseJSON { (response) in
            
            //MARK:- Main parsing
            if let httpResponse = response.result.value as? [String:Any] {
                if  let response = httpResponse["response"] as? [String:Any] {
                    if let venuesJson = response["venues"] as? [[String:Any]] {
                        for venues in venuesJson {
                            let venue = Venue(jsonData: venues)
                            Venues.append(venue)
                        }
                    }
                }
                print(httpResponse)
              completion(Venues)
            }
        }
    }
    
    func getVenueImage(venue: Venue) -> UIImage {
        return UIImage()
    }
    
    
    //MARK:- Network Requests
    
    func performRequest(for url: URL,
                        httpMethod: HTTPMethod,
                        headers: [String: String]? = nil,
                        body: Data? = nil,
                        completion: ((Data?, Error?) -> Void)? = nil) {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion?(data, error)
        }
        dataTask.resume()
    }
    
     func url(byAdding parameters: [String: String]?, to url: URL) -> URL {
        var componets = URLComponents(url: url, resolvingAgainstBaseURL: true)
        componets?.queryItems = parameters?.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = componets?.url else { fatalError("URL Optional is nil") }
        return url
    }
    
    //MARK:- HTTP Methods
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
}




