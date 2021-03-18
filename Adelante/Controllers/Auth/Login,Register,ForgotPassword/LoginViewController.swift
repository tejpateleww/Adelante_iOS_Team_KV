//
//  LoginViewController.swift
//  ApiStructureModule
//
//  Created by EWW071 on 14/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

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
    }
    // MARK: - IBActions
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let forgotPassVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ForgotPasswordVC.storyboardID)
               self.navigationController?.pushViewController(forgotPassVc, animated: true)
        
       
    }
    
    @IBAction func btnShowPasswordTap(_ sender: UIButton) {
        let isvisible = txtPassword.isSecureTextEntry
        txtPassword.isSecureTextEntry = !isvisible
//        let img = isvisible ? "privatePassword" : "viewPassword"
//        btnPasswordVisible.setImage(UIImage(named: img), for: .normal)
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
                appDel.navigateToHome()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
    func webserviceForForgotPassword(){
        let forgot = ForgotPasswordReqModel()
       //forgot.user_name = txtEmailOrPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.showHUD()
        WebServiceSubClass.ForgotPassword(forgotPassword: forgot, showHud: true, completion: { (response, status, error) in
            self.hideHUD()
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
        let txtTemp = UITextField()
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmail = txtTemp.validatedText(validationType:  ValidatorType.requiredField(field: txtEmail.placeholder ?? ""))
        txtTemp.text = txtPassword.text?.replacingOccurrences(of: " ", with: "")
        let checkPassword = txtTemp.validatedText(validationType:  .password(field: txtPassword.placeholder ?? ""))
         if(!checkEmail.0)
        {
            Utilities.showAlert(AppInfo.appName, message: checkEmail.1, vc: self)//(OfMessage: checkEmail.1)
            return checkEmail.0
        }
        else  if(!checkPassword.0)
        {
//            Utilities.ShowAlert(OfMessage: checkPassword.1)
            Utilities.showAlert(AppInfo.appName, message: checkPassword.1, vc: self)
            return checkPassword.0
        }
        return true
    }
}
