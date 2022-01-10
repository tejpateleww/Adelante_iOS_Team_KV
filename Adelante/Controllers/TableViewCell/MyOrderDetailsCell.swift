//
//  MyOrderDetailsCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyOrderDetailsCell: UITableViewCell {

    // MARK: - IBOutlets of MyOrderDetailsCell
     
     @IBOutlet weak var lblItemName: orderDetailsLabel!
     @IBOutlet weak var lblDateTime: orderDetailsLabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: orderDetailsLabel!
    
     // MARK: - Properties
     
     override func awakeFromNib() {
         super.awakeFromNib()
     }
    
     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }

}
