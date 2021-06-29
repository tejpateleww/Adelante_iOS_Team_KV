//
//  RestaurantCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var lblItemName: tblHomeLabels!
    @IBOutlet weak var lblRating: tblHomeLabels!
    @IBOutlet weak var lblMiles: tblHomeLabels!
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // setUpLocalizedStrings()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpLocalizedStrings(){
        lblItemName.text = "Kangkung siram sambel"
        lblRating.text = "4.2"
        lblMiles.text = String(format: "HomeVC_RestaurantCell_lblMiles".Localized(), "2.5")
    }
}

