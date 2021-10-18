//
//  MyOrderTotalCell.swift
//  Adelante
//
//  Created by Harsh Dave on 13/10/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class MyOrderTotalCell: UITableViewCell {

    @IBOutlet weak var lblTitle: CheckOutLabel!
    @IBOutlet weak var lblPrice: CheckOutLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
