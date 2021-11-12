//
//  LoginViewController.swift
//  ApiStructureModule
//
//  Created by EWW071 on 14/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: BaseViewController {
    var locationManager : LocationService?
    
    @IBOutlet weak var lblTitle: themeTitleLabel!
    @IBOutlet weak var txtEmail : floatTextField!
    @IBOutlet weak var txtPassword : floatTextField!
    @IBOutlet weak var btnForgotPassword: submitButton!
    @IBOutlet weak var lblSignin: themeLabel!
    @IBOutlet weak var lblDontHave: themeLabel!
    @IBOutlet weak var btnCreateAccount: submitButton!
    @IBOutlet weak var btnPasswordVisible: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.autocorrectionType = .no
        setup()
        setUpLocalizedStrings()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    // MARK: - IBActions
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let forgotPassVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ForgotPasswordVC.storyboardID)
               self.navigationController?.pushViewController(forgotPassVc, animated: true)
    }
    
    @IBAction func btnShowPasswordTap(_ sender: UIButton) {
        let isvisible = txtPassword.isSecureTextEntry
        txtPassword.isSecureTextEntry = !isvisible
        btnPasswordVisible.isSelected =  !btnPasswordVisible.isSelected
    }
    @IBAction func btnCreateAccountClicked(_ sender: Any) {
        let registerVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterViewController.storyboardID)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func btnlogin(_ sender: Any) {
        if validation(){
            webserviceForlogin()
        }
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
        login.device_token = SingletonClass.sharedInstance.DeviceToken
        login.device_type = ReqDeviceType
        login.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        login.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
//        self.showHUD()
        WebServiceSubClass.login(loginModel: login,showHud: true, completion: { (json, status, response) in
//            self.hideHUD()
            if(status)
            {
                let loginModel = Userinfo.init(fromJson: json)
                let loginModelDetails = loginModel.profile
                SingletonClass.sharedInstance.UserId = loginModelDetails?.id ?? ""
                SingletonClass.sharedInstance.Api_Key = loginModelDetails?.apiKey ?? ""
                SingletonClass.sharedInstance.LoginRegisterUpdateData = loginModelDetails
                userDefault.setValue(loginModelDetails?.apiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                userDefault.setUserData(objProfile: loginModelDetails!)
                if self.navigationController?.children.count == 1 {
                    if SingletonClass.sharedInstance.isPresented  {
                        SingletonClass.sharedInstance.isPresented = false
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        appDel.navigateToHome()
                    }
                }else{
                    appDel.navigateToHome()
                }
                
            }
            else
            {
                if json["message"].string == "Your account is not activated yet!" {
                    self.showAlertWithTwoButtonCompletion(title: AppName, Message: "To activate your account, please click on the activation link which we have sent to your email, then click OK.", defaultButtonTitle: "OK", cancelButtonTitle: "Resend Email") { [self] (index) in
                        if index == 1{
                            self.webserviceForSendEmailVerify()
                        }
                    }
                }else{
                    if let strMessage = json["message"].string {
                        Utilities.showAlert(AppInfo.appName, message: strMessage, vc: self)//displayAlert(strMessage)
                    }else {
                        Utilities.showAlert(AppInfo.appName, message: "Something went wrong", vc: self)//displayAlert("Something went wrong")
                    }
                }
            }
        })
    }
    func webserviceForSendEmailVerify()
    {
        let email = sendEmailVerifyReqModel()
        email.user_name = txtEmail.text ?? ""
        
        // self.showHUD()
        WebServiceSubClass.sendEmail(optModel: email, showHud: true) { [self] (json, status, response) in
            self.hideHUD()
            if(status){
                print(json)
                Utilities.displayAlert(json["message"].string!)
            }else {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        }
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
        let txtTemp = UITextField()
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmail = txtTemp.validatedText(validationType:  ValidatorType.requiredField(field: txtEmail.placeholder?.lowercased() ?? ""))
        let StrPassWord = txtPassword.validatedText(validationType: .password(field: "password"))
//        let checkPassword = txtPassword.validatedText(validationType:  .password(field: txtPassword.placeholder ?? ""))
         if(!checkEmail.0)
        {
            Utilities.showAlert(AppInfo.appName, message: checkEmail.1, vc: self)//(OfMessage: checkEmail.1)
            return checkEmail.0
        }
         else if !StrPassWord.0{
             Utilities.showAlert(AppInfo.appName, message: StrPassWord.1, vc: self)
             return StrPassWord.0
         }
        return true
    }
}
extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
