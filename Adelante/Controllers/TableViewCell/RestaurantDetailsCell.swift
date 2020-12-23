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
    override func awakeFromNib() {
        super.awakeFromNib()
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

}
