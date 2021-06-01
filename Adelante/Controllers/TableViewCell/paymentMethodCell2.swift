//
//  paymentMethodCell2.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import FormTextField

class paymentMethodCell2: UITableViewCell {
    var filterSelect = [0]
    var validation = Validation()
    var inputValidator = InputValidator()
    @IBOutlet weak var vwCvv: UIView!
    @IBOutlet weak var vWMain: PaymentView!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var lblExpiresDate: addPaymentlable!
    @IBOutlet weak var lblcardDetails: addPaymentlable!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var textFieldEnterCVV: EnterCVVTextField!
    
    var PayButton : (() -> ())?
    var selectedBtn : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldEnterCVV.placeholder = "Enter CVV"
        textFieldEnterCVV.text = ""
        CvvValidation()
        // Initialization code
    }
    func CvvValidation() {
        textFieldEnterCVV.isSecureTextEntry = true
        textFieldEnterCVV.inputType = .integer
        
        self.validation.maximumLength = 4
        self.validation.minimumLength = 3
        
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        textFieldEnterCVV.inputValidator = inputValidator
    }
    
    @IBAction func btnSelectCheckClick(_ sender: Any) {
        if let click = self.selectedBtn
        {
            click()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnPayClick(_ sender: UIButton) {
        if let click = self.PayButton
        {
            click()
        }
    }
}
