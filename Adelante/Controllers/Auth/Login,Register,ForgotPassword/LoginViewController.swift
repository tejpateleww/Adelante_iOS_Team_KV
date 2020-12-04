//
//  LoginViewController.swift
//  ApiStructureModule
//
//  Created by EWW071 on 14/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let signIn = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID)
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    @IBAction func btnCreateAccountClicked(_ sender: Any) {
        let registerVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterViewController.storyboardID)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
   //MARK:- Webservice
    func webserviceForlogin()
    {
        let login = LoginReqModel(email:  txtEmail.text ?? "", password: txtPassword.text ?? "", deviceToken: SingletonClass.sharedInstance.DeviceToken, deviceType: AppInfo.appUrl )
        WebServiceSubClass.login(loginModel: login, showHud: true) { (json, status, response) in
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
                appDel.navigateToHome()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
            }
        }
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
