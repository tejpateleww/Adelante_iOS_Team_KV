//
//  RegisterViewController.swift
//  ApiStructureModule
//
//  Created by EWW071 on 14/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK:- Properties
    var isSocialLogin : Bool = false
    var isShowValidateAlert = Bool()
    //MARK:- Outlet
    @IBOutlet weak var lblTitle: themeTitleLabel!
    @IBOutlet weak var txtFirstName:floatTextField!
    @IBOutlet weak var txtLastName:floatTextField!
    @IBOutlet weak var txtEmail:floatTextField!
    @IBOutlet weak var txtPhoneNumber: floatTextField!
    @IBOutlet weak var txtPassword:floatTextField!
    @IBOutlet weak var txtConPassword:floatTextField!
    @IBOutlet weak var lblCreateAccount: themeLabel!
    @IBOutlet weak var lblAlreadyHave: themeLabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnSignin: submitButton!
    @IBOutlet weak var btnPasswordVisible: UIButton!
    @IBOutlet weak var btnPasswordShow: UIButton!
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtConPassword.delegate = self
        setUpLocalizedStrings()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK:- Other Methods
    func setUp(){
        self.navigationController?.navigationBar.isHidden = true
        txtLastName.delegate = self
        txtFirstName.delegate = self
        txtPhoneNumber.delegate = self
    }
    func setUpLocalizedStrings() {
        lblTitle.text = "RegisterViewController_lblTitle".Localized()
        txtFirstName.placeholder = "RegisterViewController_txtFirstName".Localized()
        txtLastName.placeholder = "RegisterViewController_txtLastName".Localized()
        txtEmail.placeholder = "RegisterViewController_txtEmail".Localized()
        txtPhoneNumber.placeholder = "RegisterViewController_txtPhoneNumber".Localized()
        txtPassword.placeholder = "RegisterViewController_txtPassword".Localized()
        txtConPassword.placeholder = "RegisterViewController_txtConPassword".Localized()
        lblCreateAccount.text = "RegisterViewController_lblCreateAccount".Localized()
        lblAlreadyHave.text = "RegisterViewController_lblAlreadyHave".Localized()
        btnSignin.setTitle("RegisterViewController_btnSignin".Localized(), for: .normal)
    }
    //MARK:- Button action
    @IBAction func btnSignUp(sender:Any){
        
//        let OTPVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: VerifyVC.storyboardID)
//        self.navigationController?.pushViewController(OTPVC, animated: true)
        if(validation())
        {
            webserviceForSendOTP()
        }
        //        userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
        //        appDel.navigateToHome()
    }
    
    @IBAction func btnShowPasswordTap(_ sender: UIButton) {
        
        if sender.tag == 1{
            let isvisible = txtPassword.isSecureTextEntry
            txtPassword.isSecureTextEntry = !isvisible
            btnPasswordVisible.isSelected = !btnPasswordVisible.isSelected
        }else if sender.tag == 2{
            let isvisible = txtConPassword.isSecureTextEntry
            txtConPassword.isSecureTextEntry = !isvisible
            btnPasswordShow.isSelected = !btnPasswordShow.isSelected
        }
        
        //        let img = isvisible ? "privatePassword" : "viewPassword"
        //        btnPasswordVisible.setImage(UIImage(named: img), for: .normal)
        
        
    }
    @IBAction func btnBackLogin(sender:UIButton){
        self.navigationController?.popViewController(animated: true)//dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFacebookSignUp(sender:UIButton){
        
    }
    @IBAction func btnGoogleSignUp(sender:UIButton){
        
    }
    
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :- Validation
    func validation()->Bool{
        let txtTemp = UITextField()
        txtTemp.text = txtFirstName.text?.replacingOccurrences(of: " ", with: "")
        let firstName = txtTemp.validatedText(validationType: ValidatorType.username(field: "first name"))
        txtTemp.text = txtLastName.text?.replacingOccurrences(of: " ", with: "")
        let lastname =  txtTemp.validatedText(validationType: ValidatorType.username(field: "last name"))
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtEmail.placeholder?.lowercased() ?? ""))
        let checkEmailValid = txtTemp.validatedText(validationType: ValidatorType.email)
        let newPW =  txtPassword.validatedText(validationType: ValidatorType.password(field: txtPassword.placeholder ?? ""))
        let confirmPW = txtConPassword.validatedText(validationType: ValidatorType.password(field: txtConPassword.placeholder ?? ""))
        let invalidPhone =  txtPhoneNumber.validatedText(validationType: ValidatorType.phoneNo)
        if (!firstName.0){
//            Utilities.ShowAlert(OfMessage: firstName.1)
            Utilities.showAlert(AppInfo.appName, message: firstName.1, vc: self)
            return firstName.0
        }else if (!lastname.0){
//            Utilities.ShowAlert(OfMessage: lastname.1)
            Utilities.showAlert(AppInfo.appName, message: lastname.1, vc: self)
            return lastname.0
        }else if(!checkEmailRequired.0)
        {
//            Utilities.ShowAlert(OfMessage:checkEmailRequired.1)
            Utilities.showAlert(AppInfo.appName, message: checkEmailRequired.1, vc: self)
            return checkEmailRequired.0
        }
        else if(!checkEmailValid.0)
        {
//            Utilities.ShowAlert(OfMessage:"Please enter a valid email")
            Utilities.showAlert(AppInfo.appName, message: "Please enter a valid email", vc: self)
            return checkEmailValid.0
        }
        else if (!invalidPhone.0) {
//            Utilities.ShowAlert(OfMessage: invalidPhone.1)
            Utilities.showAlert(AppInfo.appName, message: invalidPhone.1, vc: self)
            return invalidPhone.0
        }
        else if (txtPhoneNumber.text?.count ?? 0) < 9 {
//            Utilities.ShowAlert(OfMessage: "Please enter valid phone number")
            Utilities.showAlert(AppInfo.appName, message: "Please enter valid phone number", vc: self)
            return false
        }
        else if !newPW.0{
            Utilities.displayAlert(newPW.1)
            return false
        }else if !confirmPW.0{
            Utilities.displayAlert(confirmPW.1)
            return false
        }
        else if txtPassword.text?.lowercased() != txtConPassword.text?.lowercased(){
//            Utilities .ShowAlert(OfMessage: "Password and confirm password must be same")
            Utilities.showAlert(AppInfo.appName, message: "Password and confirm password must be same", vc: self)
            return false
        }
        return true
    }
    
    //MARK:- Webservice
    
    
    func webserviceForSendOTP()
    {
        let otp = sendOtpReqModel()
        otp.user_name = txtEmail.text ?? ""
        
       // self.showHUD()
        WebServiceSubClass.sendOTP(optModel: otp, showHud: false) { [self] (json, status, response) in
            self.hideHUD()
            if(status){
                print(json)
                let otpModel = otpReceive.init(fromJson: json)
                let OTPVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: VerifyVC.storyboardID) as! VerifyVC
                OTPVC.isFromRegister = true
                OTPVC.strfirst = self.txtFirstName.text!
                OTPVC.strLast = self.txtLastName.text!
                OTPVC.strEmail = self.txtEmail.text!
                OTPVC.strphoneNo = self.txtPhoneNumber.text!
                OTPVC.strPassword = self.txtPassword.text!
                OTPVC.strOTP = otpModel.code
                self.navigationController?.pushViewController(OTPVC, animated: true)
            }else {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
    
//    func webserviceForRegister()
//    {
//        let register = RegisterReqModel()
//        register.first_name = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        register.last_name = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        register.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        register.phone = txtPhoneNumber.text ?? ""
//        register.password = txtPassword.text ?? ""
//        register.device_token = SingletonClass.sharedInstance.DeviceToken
//        register.device_type = ReqDeviceType
//        register.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
//        register.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
//        WebServiceSubClass.register(registerModel: register,showHud: true, completion: { (json, status, response) in
//            if(status)
//            {
//                print(json)
//                let loginModel = Userinfo.init(fromJson: json)
//                let registerRespoDetails = loginModel.profile
//               // Utilities.displayAlert("", message: "Registered successfully! Email verification link has been sent to your registered email",vc: self, completion: {_ in
////                    appDel.navigateToLogin()
////                }, otherTitles: nil)
//                let OTPVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: VerifyVC.storyboardID)
//                self.navigationController?.pushViewController(OTPVC, animated: true)
//            }
//            else
//            {
//                Utilities.displayErrorAlert(json["message"].string ?? "MessageNoIntenet".Localized())
//            }
//        })
//    }
    
}


extension RegisterViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.hasPrefix(" "){
            textField.text = ""
            return false
        }else if textField == txtFirstName || textField == txtLastName {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtPhoneNumber{
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

