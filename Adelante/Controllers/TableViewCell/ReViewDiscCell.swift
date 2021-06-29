//
//  ReViewDiscCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import Cosmos

class ReViewDiscCell: UITableViewCell {
    @IBOutlet weak var lblDescription: CustomLabel!
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var vwRating: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
