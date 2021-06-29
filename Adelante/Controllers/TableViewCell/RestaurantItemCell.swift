//
//  RestaurantItemCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantItemCell: UITableViewCell {

    @IBOutlet weak var vwStapper: UIView!
    @IBOutlet weak var btnCustomize: underLineButton!
    @IBOutlet weak var lblNoOfItem: UILabel!
    @IBOutlet weak var lblItem: tblMyOrdersLabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblItemPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblSizeOfItem: tblMyOrdersLabel!
    @IBOutlet weak var vwSeperator: seperatorView!
    var customize : (() -> ())?
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }

}
