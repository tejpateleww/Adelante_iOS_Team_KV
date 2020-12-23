//
//  paymentMethodCell2.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class paymentMethodCell2: UITableViewCell {
    @IBOutlet weak var vWMain: PaymentView!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var lblExpiresDate: addPaymentlable!
    @IBOutlet weak var lblcardDetails: addPaymentlable!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
