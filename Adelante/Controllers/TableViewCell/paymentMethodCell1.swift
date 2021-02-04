//
//  paymentMethodCell1.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class paymentMethodCell1: UITableViewCell {
    @IBOutlet weak var vWMain: PaymentView!
    @IBOutlet weak var lblWallet: addPaymentlable!
    @IBOutlet weak var lblwalletBalance: addPaymentlable!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
