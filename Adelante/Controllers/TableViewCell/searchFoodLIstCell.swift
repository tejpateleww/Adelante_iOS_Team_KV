//
//  searchFoodLIstCell.swift
//  Adelante
//
//  Created by Harsh Dave on 13/07/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class searchFoodLIstCell: UITableViewCell {

    @IBOutlet weak var lblDisc: UILabel!
    @IBOutlet weak var lblPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblComboTitle: tblMyOrdersLabel!
    @IBOutlet weak var imgFoodLIst: UIImageView!
    @IBOutlet weak var lblNoOfItem: tblMyOrdersLabel!
    @IBOutlet weak var lblRestaurant: tblHomeLabels!
    @IBOutlet weak var lblRating: tblHomeLabels!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblMiles: tblHomeLabels!
    @IBOutlet weak var vwStapper: UIView!
    var customize : (() -> ())?
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    @IBAction func btnCustomize(_ sender: Any) {
        if let click = self.customize {
            click()
        }
    }
    @IBAction func btnAdd(_ sender: Any) {
        if let btnAdd = self.btnAddAction{
            btnAdd()
        }
    }
    @IBAction func btnIncrease(_ sender: Any) {
        if let Increase = self.IncreseData{
            Increase()
        }
    }
    @IBAction func btnDecrease(_ sender: Any) {
        if let Decrease = self.decreaseData{
            Decrease()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
