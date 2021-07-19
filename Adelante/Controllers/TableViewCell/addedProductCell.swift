//
//  addedProductCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class addedProductCell: UITableViewCell {
    @IBOutlet weak var vwStapper: checkoutView!
    @IBOutlet weak var lbltotalCount: CheckOutLabel!
    @IBOutlet weak var lblItem: CheckOutLabel!
    @IBOutlet weak var lblPrice: CheckOutLabel!
    @IBOutlet weak var stackHide: UIStackView!
    @IBAction func decreaseBtn(_ sender: Any) {
        if let click = self.decreaseClick {
            click()
        }
    }
    var decreaseClick : (() -> ())?
    var increaseClick : (() -> ())?
    @IBAction func increaseBtn(_ sender: Any) {
        if let click = self.increaseClick {
            click()
        }
    }

}
