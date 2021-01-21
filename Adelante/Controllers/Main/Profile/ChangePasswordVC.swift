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
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.aboutUs.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
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
            webservice_ChangePW()
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
        let currentPW = txtOldPassword.validatedText(validationType: ValidatorType.requiredField(field: "current password"))
        let newPW =  txtNewPassword.validatedText(validationType: ValidatorType.requiredField(field: "new password"))
         let confirmPW = txtConfirmPassword.validatedText(validationType: ValidatorType.requiredField(field: "confirm password"))
        if (!currentPW.0){
            Utilities.ShowAlert(OfMessage: currentPW.1)
            return currentPW.0
        }else if (!newPW.0){
            Utilities.ShowAlert(OfMessage: newPW.1)
            return newPW.0
        }else if (txtNewPassword.text?.count ?? 0) <= 7{
            Utilities.ShowAlert(OfMessage: "New Password must contain at least 8 characters")
            return false
        }else if (!confirmPW.0){
            Utilities.ShowAlert(OfMessage: "Please confirm the password")
            return confirmPW.0
        } else if txtNewPassword.text?.lowercased() != txtConfirmPassword.text?.lowercased(){
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
