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
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLocalizedStrings()
    }
    var customize : (() -> ())?

    @IBAction func btnCustomize(_ sender: Any) {
        if let click = self.customize {
            click()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpLocalizedStrings(){
        btnCustomize.setTitle("RestaurantDetailsVC_RestaurantDetailsCell_btnCustomize".Localized(), for: .normal)
    }

}
