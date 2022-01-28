//
//  RestaurantOutletListCell.swift
//  Adelante
//
//  Created by baps on 08/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class RestaurantOutletListCell : UITableViewCell{
    @IBOutlet weak var lblAreaName: tblHomeLabels!
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var lblMiles: tblHomeLabels!
    @IBOutlet weak var lblRating: tblHomeLabels!
    @IBOutlet weak var lblAddress: tblHomeLabels!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var vwIndicator: UIView!
    
    @IBOutlet weak var LblClosed: themeLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var btnFavouriteClick : (()->())?
    @IBAction func btnFavouriteTap(_ sender: Any) {
        if let btnFav = self.btnFavouriteClick{
            btnFav()
        }
    }
    @IBAction func BtnLikeDislike(_ sender: UIButton) {
           if sender.isSelected {
               sender.isSelected = false
           } else {
               sender.isSelected = true
           }
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
