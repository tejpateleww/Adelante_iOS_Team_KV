//
//  RestaurantDetailsPopupCell.swift
//  Adelante
//
//  Created by Harsh Dave on 09/07/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class RestaurantDetailsPopupCell: UITableViewCell {

    @IBOutlet weak var imgRestDetails: customImagewithShadow!
    @IBOutlet weak var vwStapper: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblNoOfItem: UILabel!
    @IBOutlet weak var lblItemName: tblMyOrdersLabel!
    @IBOutlet weak var lblPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblDesc: tblMyOrdersLabel!
    @IBOutlet weak var stackHide: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    
    @IBAction func btnDecrease(_ sender: Any) {
        if let Decrease = self.decreaseData{
            Decrease()
        }
    }
    @IBAction func btnIncrease(_ sender: Any) {
        if let Increase = self.IncreseData{
            Increase()
        }
    }
    @IBAction func btnAdd(_ sender: Any) {
        if let btnAdd = self.btnAddAction{
            btnAdd()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
