//
//  RestaurantItemCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantItemCell: UITableViewCell {

    @IBOutlet weak var lblItem: tblMyOrdersLabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblItemPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblSizeOfItem: tblMyOrdersLabel!
    @IBOutlet weak var vwSeperator: seperatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
