//
//  PromocodeCell.swift
//  Adelante
//
//  Created by Admin on 06/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class PromocodeCell: UITableViewCell {
    var ApplyClickClosour : (() -> ())?
    @IBOutlet weak var lblOfferDescription: promocodeLabel!
    @IBOutlet weak var btnApply: btnApply!
    @IBOutlet weak var lblValidOn: promocodeLabel!
    @IBAction func btnApplyClick(_ sender: UIButton) {
        if let click = self.ApplyClickClosour {
            click()
        }
    }
    @IBOutlet weak var lblPromoCode: promocodeLabel!
    @IBOutlet weak var lblAdelante: promocodeLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
