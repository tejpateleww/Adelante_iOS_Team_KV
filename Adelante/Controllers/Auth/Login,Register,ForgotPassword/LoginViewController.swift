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
//        UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
//        appDel.navigateToHome()
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
                let loginModel = Userinfo.init(fromJson: json)
                let loginModelDetails = loginModel.profile
                UserDefaults.standard.set(loginModelDetails?.apiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                
                SingletonClass.sharedInstance.UserId = loginModelDetails?.id ?? ""
                SingletonClass.sharedInstance.Api_Key = loginModelDetails?.apiKey ?? ""
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
    func webserviceForForgotPassword(){
        let forgot = ForgotPasswordReqModel()
       //forgot.user_name = txtEmailOrPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        WebServiceSubClass.ForgotPassword(forgotPassword: forgot, showHud: false, completion: { (response, status, error) in
            if (status){
                self.showAlertWithTwoButtonCompletion(title: AppName, Message: response["message"].stringValue, defaultButtonTitle: "OK", cancelButtonTitle: "") { (index) in
                    if index == 0{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
        
    }
    func showAlertWithTwoButtonCompletion(title:String, Message:String, defaultButtonTitle:String, cancelButtonTitle:String ,  Completion:@escaping ((Int) -> ())) {
        
        let alertController = UIAlertController(title: title , message:Message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: defaultButtonTitle, style: .default) { (UIAlertAction) in
            Completion(0)
        }
        if cancelButtonTitle != ""{
            let CancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { (UIAlertAction) in
                Completion(1)
            }
            alertController.addAction(OKAction)
            alertController.addAction(CancelAction)
        }else{
            alertController.addAction(OKAction)
        }
        self.present(alertController, animated: true, completion: nil)
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
