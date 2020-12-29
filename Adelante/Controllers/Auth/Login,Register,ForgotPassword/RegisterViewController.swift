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
//        if(validation())
//        {
//            webserviceForRegister()
//        }
        userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
        appDel.navigateToHome()
        
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
    func validation() -> Bool
    {
        let firstName = txtFirstName.validatedText(validationType: .requiredField(field: txtFirstName.placeholder ?? ""))
        let lastName = txtLastName.validatedText(validationType: .requiredField(field: txtLastName.placeholder ?? ""))
        let checkEmail = txtEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = txtPassword.validatedText(validationType: ValidatorType.password)
        
        if(!firstName.0)
        {
            Utilities.displayAlert(firstName.1)
            return firstName.0
        }
        if(!lastName.0)
        {
            Utilities.displayAlert(lastName.1)
            return lastName.0
        }
        if(!checkEmail.0)
        {
            Utilities.displayAlert(checkEmail.1)
            return checkEmail.0
        }
        else  if(!checkPassword.0)
        {
            Utilities.displayAlert(checkPassword.1)
            return checkPassword.0
        }
        else if (txtPassword.text != txtConPassword.text)
        {
            Utilities.displayAlert("MessagePassword")
            return checkPassword.0
        }
        return true
    }
    
    //MARK:- Webservice
    func webserviceForRegister()
    {
        guard let strFirstName = self.txtFirstName.text else {return}
        guard let strLastName = self.txtLastName.text else {return}
        guard let strEmail = self.txtEmail.text else {return}
        guard let strPassword = self.txtPassword.text else {return}
        let strDeviceToken = SingletonClass.sharedInstance.DeviceToken
        let strDeviceType = AppInfo.deviceType
        
        
        let register = RegisterReqModel(firstName: strFirstName, lastName: strLastName, email: strEmail, mobileNumber: "", deviceToken: strDeviceToken, deviceType: strDeviceType, password: strPassword)
      
        WebServiceSubClass.register(registerModel: register, showHud: true) { (json, status, response) in
            
            if(status)
            {
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                let loginModelDetails = UserInfo.init(fromJson: json)
                UserDefaults.standard.set(loginModelDetails.data.xApiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                SingletonClass.sharedInstance.UserId = loginModelDetails.data.id
                SingletonClass.sharedInstance.Api_Key = loginModelDetails.data.xApiKey
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginModelDetails)
                userDefault.set(encodedData, forKey:  UserDefaultsKey.userProfile.rawValue)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = loginModelDetails
                userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                appDel.navigateToHome()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "MessageTitle".Localized())
            }
        }
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
