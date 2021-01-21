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
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if(validation())
        {
            webserviceForRegister()
        }
        //        userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
        //        appDel.navigateToHome()
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
        let firstName = txtFirstName.validatedText(validationType: ValidatorType.username(field: "first name"))
        let lastname =  txtLastName.validatedText(validationType: ValidatorType.username(field: "last name"))
        let checkEmail = txtEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = txtPassword.validatedText(validationType: ValidatorType.requiredField(field: "Password"))
        let confirmPassword = txtConPassword.validatedText(validationType: ValidatorType.requiredField(field: "confirm Password"))
        let phone = txtPhoneNumber.validatedText(validationType: ValidatorType.requiredField(field: "contact number"))
        
        if (!firstName.0){
            Utilities.ShowAlert(OfMessage: firstName.1)
            return firstName.0
        }else if (!lastname.0){
            Utilities.ShowAlert(OfMessage: lastname.1)
            return lastname.0
        }else if(!checkEmail.0)
        {
            Utilities.ShowAlert(OfMessage: checkEmail.1)
            return checkEmail.0
        }
        else if (txtPhoneNumber.text?.count ?? 0) < 9 {
            Utilities.ShowAlert(OfMessage: "Please enter valid contact number")
            return false
        }
        else  if(!checkPassword.0) && !isSocialLogin
        {
            Utilities.ShowAlert(OfMessage: checkPassword.1)
            return checkPassword.0
        }else if(!confirmPassword.0){
            Utilities.ShowAlert(OfMessage: confirmPassword.1)
            return confirmPassword.0
        }else if txtPassword.text?.lowercased() != txtConPassword.text?.lowercased(){
            Utilities .ShowAlert(OfMessage: "New password and confirm password must be same")
            return false
        }
        return true
    }
    
    //MARK:- Webservice
    func webserviceForRegister()
    {
        let register = RegisterReqModel()
        register.first_name = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        register.last_name = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        register.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        register.phone = txtPhoneNumber.text ?? ""
        register.password = txtPassword.text ?? ""
        register.device_token = "123456"
        register.device_type = ReqDeviceType
        register.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        register.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.register(registerModel: register,showHud: true, completion: { (json, status, response) in
            if(status)
            {
                let loginModel = Userinfo.init(fromJson: json)
                let registerRespoDetails = loginModel.profile
                SingletonClass.sharedInstance.UserId = registerRespoDetails?.id ?? ""
                SingletonClass.sharedInstance.Api_Key = registerRespoDetails?.apiKey ?? ""
                SingletonClass.sharedInstance.LoginRegisterUpdateData = registerRespoDetails
                userDefault.setValue(registerRespoDetails?.apiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                userDefault.setUserData(objProfile: registerRespoDetails!)
                appDel.navigateToHome()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "MessageTitle".Localized())
            }
        })
    }
    
}
extension RegisterViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        if textField.tag == 3 || textField.tag == 4{
            return numberOfChars < 15
        }else{
            return numberOfChars < 50
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
