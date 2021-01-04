//
//  LoginViewController.swift
//  ApiStructureModule
//
//  Created by EWW071 on 14/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var lblTitle: themeTitleLabel!
    @IBOutlet weak var txtEmail : floatTextField!
    @IBOutlet weak var txtPassword : floatTextField!
    @IBOutlet weak var btnForgotPassword: submitButton!
    @IBOutlet weak var lblSignin: themeLabel!
    @IBOutlet weak var lblDontHave: themeLabel!
    @IBOutlet weak var btnCreateAccount: submitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let forgotPassVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ForgotPasswordVC.storyboardID)
               self.navigationController?.pushViewController(forgotPassVc, animated: true)
        
       
    }
    
    @IBAction func btnCreateAccountClicked(_ sender: Any) {
        let registerVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterViewController.storyboardID)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func btnlogin(_ sender: Any) {
        webserviceForlogin()
        
       }
    //MARK:- Other Method
    func setUpLocalizedStrings() {
        lblTitle.text = "LoginViewController_lblTitle".Localized()
        txtEmail.placeholder = "LoginViewController_txtEmail".Localized()
        txtPassword.placeholder = "LoginViewController_txtPassword".Localized()
        btnForgotPassword.setTitle("LoginViewController_btnForgotPassword".Localized(), for: .normal)
        lblSignin.text = "LoginViewController_lblSignin".Localized()
        lblDontHave.text = "LoginViewController_lblDontHave".Localized()
        btnCreateAccount.setTitle("LoginViewController_btnCreateAccount".Localized(), for: .normal)
    }
   //MARK:- Webservice
    func webserviceForlogin()
    {
        let login = LoginReqModel()
        login.user_name = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        login.password = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        login.phone = ""
        login.device_token = "123456"
        login.device_type = ReqDeviceType
        login.lat = "23.076448"
        login.lng = "72.508116 "
        
        WebServiceSubClass.login(loginModel: login, completion: { (json, status, response) in
            if(status)
            {
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                let loginModelDetails = Profile.init(fromJson: json)
                UserDefaults.standard.set(loginModelDetails.apiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                
                SingletonClass.sharedInstance.UserId = loginModelDetails.id
                SingletonClass.sharedInstance.Api_Key = loginModelDetails.apiKey
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginModelDetails)
                userDefault.set(encodedData, forKey:  UserDefaultsKey.userProfile.rawValue)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = loginModelDetails
                userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                appDel.navigateToHome()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
            }
        })
    }
    
    func webserviceForForgotPassword(strEmail : String)
    {
        
        WebServiceSubClass.ForgotPassword(email: strEmail, showHud: true) { (json, status, response) in
            if(status)
            {
                let msg = json["message"].stringValue
                // create the alert
                let alert = UIAlertController(title: AppInfo.appName, message: msg, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (Action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
            }
        }
    }
    
    //MARK:- Validation
    func validation() -> Bool
    {
        let checkEmail = txtEmail.validatedText(validationType: ValidatorType.email)
        let checkPassword = txtPassword.validatedText(validationType: ValidatorType.password)
        
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
        
        return true
    }
}
