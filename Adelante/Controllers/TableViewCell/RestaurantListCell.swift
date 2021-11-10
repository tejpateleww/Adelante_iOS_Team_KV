//
//  RestaurantListCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantListCell: UITableViewCell {

    @IBOutlet weak var lblName: tblHomeLabels!
    @IBOutlet weak var imgRestaurant: customImagewithShadow!
    @IBOutlet weak var lblMiles: tblHomeLabels!
    @IBOutlet weak var lblRating: tblHomeLabels!
    @IBOutlet weak var lblPrice: tblHomeLabels!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var vwIndicator: UIView!
    @IBOutlet weak var stackMIles: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var btnFavouriteClick : (()->())?
    @IBAction func btnFavTap(_ sender: Any) {
        if let btnfavAdd = self.btnFavouriteClick{
            btnfavAdd()
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
