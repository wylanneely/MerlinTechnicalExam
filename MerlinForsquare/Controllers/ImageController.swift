//
//  ImageController.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/9/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageController {
    
    //MARK:- Client Authentication
    let clientID: String = "FI2I5WD4WSOTRVNPAXDHCRGNGH0LDPDR4QOMNUGQRPWEA1MO"
    let clientSecret: String = "FKHFYXIXAK5ESGOMDR4JXFPVCC0QAYXKWLPVQJPX1AMKRC21"
    let kClientID: String = "client_id"
    let kClientSecret: String = "client_secret"
    
    let baseUrl:URL = URL(fileURLWithPath: "https://api.foursquare.com/v2/venues/")

    //MARK:- Image size
    
    let imageSize = "300x300/"

    //MARK:- JSON Keys
    let kPhotos = "photos"
    let kItems = "items"
    let kPrefix = "prefix"
    let kSuffix = "suffix"
    
    //MARK:- Gets
    func getImagefor(venue:Venue) -> UIImage? {
        
        let venueImageDetailsURL = baseUrl.appendingPathComponent("\(venue.venueID)/photos")
        let authImageDetailsURL =  NetworkController.shared.url(byAdding: [kClientID:clientID,kClientSecret:clientSecret,"v":"20180323"], to: venueImageDetailsURL)

        var photo: UIImage? = nil
        
        Alamofire.request(authImageDetailsURL, headers: nil).responseJSON { (response) in
            
            //JSON parsing with small error handling
            guard let httpResponse = response.result.value as? [String:Any] else { NSLog("error loading images json"); return }
            print(httpResponse)
            guard let photosResponse = httpResponse[self.kPhotos] as? [String:Any] else { NSLog("error loading photos json"); return }
            guard let itemsResponse = photosResponse[self.kItems] as? [[String:Any]] else { NSLog("error loading venue items"); return }
            guard let urlPrefix = itemsResponse[0][self.kPrefix] as? String else { NSLog("error loading url prefix"); return }
            guard let urlSuffix = itemsResponse[0][self.kSuffix] as? String else { NSLog("error loading url suffix"); return}
            //create image url
            
            let combinedUrlString = urlPrefix + self.imageSize + urlSuffix
            let combinedUrl = URL(fileURLWithPath: combinedUrlString)
            let authPhotoUrl = NetworkController.shared.url(byAdding: [self.kClientID:self.clientID,self.kClientSecret:self.clientSecret,"v":"20180323"], to: combinedUrl)
            NetworkController.shared.performRequest(for: authPhotoUrl , httpMethod: .get, headers: nil, body: nil, completion: { (data, error) in
                
                if let data = data {
                let image = UIImage(data: data)
                photo = image
                } else { if let error = error { NSLog("Error:\(error)") } }})
        }
        if photo == nil {
            return #imageLiteral(resourceName: "Logo")
        } else {
            return photo
        }
        
    }

    
}
    
    
    
    
    
    

