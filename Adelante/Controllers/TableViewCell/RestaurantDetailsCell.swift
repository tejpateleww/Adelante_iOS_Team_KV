//
//  RestaurantDetailsCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantDetailsCell: UITableViewCell {

    @IBOutlet weak var vwSeperator: seperatorView!
    @IBOutlet weak var btnCustomize: underLineButton!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var lblAboutItem: tblMyOrdersLabel!
    @IBOutlet weak var lblItemPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblItemName: tblMyOrdersLabel!
    @IBOutlet weak var imgFoodDetails: UIImageView!
    @IBOutlet weak var lblNoOfItem: UILabel!
    @IBOutlet weak var vwStapper: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLocalizedStrings()
    }
    var customize : (() -> ())?
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    @IBAction func btnCustomize(_ sender: Any) {
        if let click = self.customize {
            click()
        }
    }
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
    }
    func setUpLocalizedStrings(){
        btnCustomize.setTitle("RestaurantDetailsVC_RestaurantDetailsCell_btnCustomize".Localized(), for: .normal)
    }

}
