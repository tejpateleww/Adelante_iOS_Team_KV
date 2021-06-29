//
//  SearchCell.swift
//  Adelante
//
//  Created by baps on 08/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var imgFoodandres: customImageView!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var lblItemType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
