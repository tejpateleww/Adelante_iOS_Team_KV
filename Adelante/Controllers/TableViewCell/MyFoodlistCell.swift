//
//  MyFoodlistCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyFoodlistCell: UITableViewCell {
    @IBOutlet weak var lblDisc: UILabel!
    @IBOutlet weak var lblPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblComboTitle: tblMyOrdersLabel!
    @IBOutlet weak var imgFoodLIst: UIImageView!
    @IBOutlet weak var lblNoOfItem: tblMyOrdersLabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var vwStapper: UIView!
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
