//
//  ChangePasswordVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    //MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var txtOldPassword: floatTextField!
    @IBOutlet weak var txtNewPassword: floatTextField!
    @IBOutlet weak var txtConfirmPassword: floatTextField!
    @IBOutlet weak var btnSave: submitButton!
    @IBOutlet weak var btnVisibleOldPassword: UIButton!
    @IBOutlet weak var btnVisiblePassword: UIButton!
    @IBOutlet weak var btnVisibleNewPassword: UIButton!
    
    var isShowValidateAlert = true
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setup()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.changePassword.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    func setUpLocalizedStrings(){
        lblTitle.text = "ChangePasswordVC_lblTitle".Localized()
        txtOldPassword.placeholder = "ChangePasswordVC_txtOldPassword".Localized()
        txtNewPassword.placeholder = "ChangePasswordVC_txtNewPassword".Localized()
        txtConfirmPassword.placeholder = "ChangePasswordVC_txtConfirmPassword".Localized()
        btnSave.setTitle("ChangePasswordVC_btnSave".Localized(), for: .normal)
    }
    // MARK: - IBActions
    @IBAction func btnSaveTap(_ sender: UIButton) {
        if validations(){
            let trimmed = txtNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed!.isEmpty == true{
                print(txtNewPassword.text)
                Utilities.ShowAlert(OfMessage: "Your password can’t start or end with a blank space")
            }
            webservice_ChangePW()
        }
    }
    @IBAction func btnShowPasswordTap(_ sender: UIButton) {
        if sender.tag == 1{
            let isvisible = txtOldPassword.isSecureTextEntry
            txtOldPassword.isSecureTextEntry = !isvisible
            btnVisibleOldPassword.isSelected = !btnVisibleOldPassword.isSelected
        }else if sender.tag == 2{
            let isvisible = txtNewPassword.isSecureTextEntry
            txtNewPassword.isSecureTextEntry = !isvisible
            btnVisiblePassword.isSelected = !btnVisiblePassword.isSelected
        }else if sender.tag == 3{
            let isvisible = txtConfirmPassword.isSecureTextEntry
            txtConfirmPassword.isSecureTextEntry = !isvisible
            btnVisibleNewPassword.isSelected = !btnVisibleNewPassword.isSelected
        }
    }
    
    
    // MARK: - Api Calls
    func webservice_ChangePW(){
        let changePWReqModel = ChangePasswordReqModel()
        changePWReqModel.old_password = txtOldPassword.text ?? ""
        changePWReqModel.new_password = txtNewPassword.text ?? ""
        changePWReqModel.user_id = SingletonClass.sharedInstance.UserId
        //self.showHUD()
        WebServiceSubClass.ChangePassword(changepassModel: changePWReqModel,showHud: false) { (response, status, error) in
            //self.hideHUD()
            if status{
                self.showAlertWithTwoButtonCompletion(title: AppName, Message: response["message"].stringValue, defaultButtonTitle: "OK", cancelButtonTitle: "") { (index) in
                    if index == 0{
                        //                        self.navigationController?.popViewController(animated: true)
                        appDel.navigateToLogin()
                    }
                }
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        }
    }
    func validations()->Bool{
        let currentPW = txtOldPassword.validatedText(validationType: ValidatorType.password(field: txtOldPassword.placeholder ?? ""))
        let newPW =  txtNewPassword.validatedText(validationType: ValidatorType.password(field: txtNewPassword.placeholder ?? ""))
        let confirmPW = txtConfirmPassword.validatedText(validationType: ValidatorType.password(field: txtConfirmPassword.placeholder ?? ""))
        if !currentPW.0{
            Utilities.displayAlert(currentPW.1)
            return false
        }
        else if !newPW.0{
            Utilities.displayAlert(newPW.1)
            return false
        }else if !confirmPW.0{
            Utilities.displayAlert(confirmPW.1)
            return false
        }else if txtNewPassword.text?.lowercased() != txtConfirmPassword.text?.lowercased(){
            Utilities.ShowAlert(OfMessage: "New password and confirm password must be same")
            return false
        }
        return true
        
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
}

