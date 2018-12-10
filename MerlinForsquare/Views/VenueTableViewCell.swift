//
//  VenueTableViewCell.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/8/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    let imageController = ImageController()
    
    func setImage(venueImage:UIImage?){
            self.venueImage.image = venueImage
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    
}
