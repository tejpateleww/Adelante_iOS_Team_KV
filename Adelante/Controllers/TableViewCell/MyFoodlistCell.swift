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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
