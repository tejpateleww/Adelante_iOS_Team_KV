//
//  AddCardVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import FormTextField

protocol AddPaymentDelegate {
    func refreshAddPaymentScreen()
}

class AddCardVC: BaseViewController,FormTextFieldDelegate {
    // MARK: - Properties
    var delegatePayment : AddPaymentDelegate!
    var isCreditCardValid = Bool()
//    var strMonth = ""
//    var strYear = ""
    var cardTypeLabel = String()
    var validation = Validation()
    var inputValidator = InputValidator()
    let monthPicker = MonthYearPickerView()
    var creditCardValidator: CreditCardValidator!
    // MARK: - IBOutlets
    @IBOutlet weak var lblName: addCardLabel!
    @IBOutlet weak var txtName: addCarddetailsTextField!
    @IBOutlet weak var lblCardNumber: addCardLabel!
    @IBOutlet weak var txtCardNumber: FormTextField!
    @IBOutlet weak var lblExpires: addCardLabel!
    @IBOutlet weak var txtDate: FormTextField!
    @IBOutlet weak var lblCvv: addCardLabel!
    @IBOutlet weak var txtCvv: FormTextField!
    @IBOutlet weak var lblDebitcardDetail: addCardLabel!
    @IBOutlet weak var btnSave: submitButton!
    @IBOutlet weak var Dtpicker: UIDatePicker!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        addNavBarImage(isLeft: true, isRight: true)
        txtDate.delegate = self
        pickerSetup()
        
        creditCardValidator = CreditCardValidator()
        cardNum()
        SetValidation()
//        txtCardNumber.enabledTextColor = UIColor.red
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.AddCardVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    
    // MARK: - IBActions
    @IBAction func txtCardNumberEditingChange(_ sender: UITextField) {
        if let number = sender.text {
            if number.isEmpty {
                isCreditCardValid = false
                self.txtCardNumber.textColor = UIColor(hexString: "#222B45")
            } else {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
    
    func setUpLocalizedStrings(){
        lblName.text = "AddCardVC_lblName".Localized()
        txtName.placeholder = "AddCardVC_txtName".Localized()
        lblCardNumber.text = "AddCardVC_lblCardNumber".Localized()
        txtCardNumber.placeholder = "AddCardVC_txtCardNumber".Localized()
        lblExpires.text = "AddCardVC_lblExpires".Localized()
        txtDate.placeholder = "AddCardVC_txtDate".Localized()
        lblCvv.text = "AddCardVC_lblCvv".Localized()
        txtCvv.placeholder = "AddCardVC_txtCvv".Localized()
        lblDebitcardDetail.text = "AddCardVC_lblDebitcardDetail".Localized()
        btnSave.setTitle("AddCardVC_btnSave".Localized(), for: .normal)
    }
    func pickerSetup() {
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: Date())

    }
    
    func setUpDatePicker() {
        if "\(userDefault.value(forKey: UserDefaultsKey.selLanguage.rawValue) ?? "")" == "ar" {
            Dtpicker.calendar = Calendar(identifier: .islamicTabular)
        } else {
            Dtpicker.calendar = Calendar(identifier: .gregorian)
        }
        Dtpicker.datePickerMode = .date
        Dtpicker.date = Date()
    }
    func clearAllTextFieldsAndSetDefaults () {
        self.txtName.text = ""
        self.txtCardNumber.text = ""
        self.txtDate.text = ""
        self.txtCvv.text = ""
        isCreditCardValid = false
        //        self.cardTypeLabel = ""
    }
    
    //MARK: - Validation
    func isValidatePaymentDetail() -> (Bool,String) {
        var isValidate:Bool = true
        var ValidatorMessage:String = ""
        let holder = txtName.validatedText(validationType: ValidatorType.username(field: "card holder name") )//ValidatorType.requiredField(field: "first name"))
        
        if (!holder.0) {
            isValidate = false
            ValidatorMessage = holder.1
            
        }else if (txtCardNumber.text!.isEmptyOrWhitespace()) {
            isValidate = false
            ValidatorMessage = "Please enter card number"
            
        }else if !isCreditCardValid {
            isValidate = false
            ValidatorMessage = "Your card number is invalid"
        }
        else if txtDate.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            isValidate = false
            ValidatorMessage = "Please enter expiry date"
            
        } else if txtCvv.text!.isEmptyOrWhitespace() {
            isValidate = false
            ValidatorMessage = "Please enter cvv"
        }else if txtCvv.text!.count < 3 {
            isValidate = false
            ValidatorMessage = "Please enter valid CVV"
        }
        
        return (isValidate,ValidatorMessage)
    }
    
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            isCreditCardValid = true
            self.cardTypeLabel = type.name.lowercased()
            print(type.name.lowercased())
            
            self.txtCardNumber.textColor = UIColor(hexString: "#222B45")
            self.CvvValidation()
        } else {
            isCreditCardValid = false
            self.cardTypeLabel = "Undefined"
        }
    }
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            isCreditCardValid = true
        } else {
            isCreditCardValid = false
        }
    }
    func SetValidation () {
        //card number
        txtCardNumber.inputType = .integer
        txtCardNumber.formatter = CardNumberFormatter()
        validation.maximumLength = 19
        validation.minimumLength = 14
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        inputValidator = InputValidator(validation: validation)
        txtCardNumber.inputValidator = inputValidator
        txtDate.inputView = monthPicker
        validation.minimumLength = 1
        self.CvvValidation()
    }
    
    func CvvValidation() {
        
        txtCvv.inputType = .integer
        
        self.validation.maximumLength = 3
        self.validation.minimumLength = 3
        
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        txtCvv.inputValidator = inputValidator
    }
    func cardNum() {
            txtCardNumber.inputType = .integer
           txtCardNumber.textFieldDelegate = self
            txtCardNumber.formatter = CardNumberFormatter()
//            txtCardNumber.setValue(UIColor.black , forKeyPath: "placeholderLabel.textColor")
            txtCardNumber.placeholder = "Card Number"
    //        txtCardNumber.font = UIFont.regular(ofSize: 13.0)
            txtCardNumber.textColor = UIColor.black
            txtCardNumber.leftMargin = 0
            txtCardNumber.layer.cornerRadius = 5
            validation.maximumLength = 19
            validation.minimumLength = 14
            let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
        }
    @IBAction func btnSaveClick(_ sender: Any) {
        if isValidatePaymentDetail().0 {
                self.webserviceForAddCard()
//            self.navigationController?.popViewController(animated: true)
        } else {
            Utilities.showAlert(AppName, message: isValidatePaymentDetail().1, vc: self)
        }
    }
    // MARK: - Api Calls
    func webserviceForAddCard(){
        let addcard = AddCardReqModel()
        addcard.card_holder_name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        addcard.card_num = txtCardNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        if let txtnum = txtCardNumber.text?.filter({ !" \n\t\r".contains($0) }){
//            addcard.card_num = txtnum
//        }
        addcard.exp_date_month_year = txtDate.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        addcard.cvv = txtCvv.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        addcard.user_id = SingletonClass.sharedInstance.UserId 
        WebServiceSubClass.addCard(addcardsmodel: addcard, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                self.navigationController?.popViewController(animated: true)
                
                self.delegatePayment.refreshAddPaymentScreen()
                self.clearAllTextFieldsAndSetDefaults()
                
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
}
public class CreditCardValidator {
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object))
        }
        return types
    }()
    
    public init() { }
    
    public func type(from string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbers(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    /**
     Validate card number
     
     - parameter string: card number string
     
     - returns: true or false
     */
    public func validate(string: String) -> Bool {
        let numbers = self.onlyNumbers(string: string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString
        
        for (i, s) in reversedArray.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    public func validate(string: String, forType type: CreditCardValidationType) -> Bool {
        return self.type(from: string) == type
    }
    
    public func onlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types = [
        [
            "name": "Amex",
            "regex": "^3[47][0-9]{5,}$"
        ], [
            "name": "Visa",
            "regex": "^4\\d{0,}$"
        ], [
            "name": "MasterCard",
            "regex": "^5[1-5]\\d{0,14}$"
        ], [
            "name": "Maestro",
            "regex": "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        ], [
            "name": "Diners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        ], [
            "name": "JCB",
            "regex": "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        ], [
            "name": "Discover",
            "regex": "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        ], [
            "name": "UnionPay",
            "regex": "^62[0-5]\\d{13,16}$"
        ], [
            "name": "Mir",
            "regex": "^22[0-9]{1,14}$"
        ]
    ]
    
}

public func ==(lhs: CreditCardValidationType, rhs: CreditCardValidationType) -> Bool {
    return lhs.name == rhs.name
}

public struct CreditCardValidationType: Equatable {
    
    public var name: String
    
    public var regex: String
    
    public init(dict: [String: Any]) {
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let regex = dict["regex"] as? String {
            self.regex = regex
        } else {
            self.regex = ""
        }
    }
    
}
extension AddCardVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == txtDate) {
            var strMonth = "\(monthPicker.month)" as String
            if(monthPicker.month <= 9)
            {
                strMonth = "0\(monthPicker.month)"
            }
            
            txtDate.text = "\(strMonth)/\(monthPicker.year)"
        }
    }
}
