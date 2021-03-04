//
//  ForgotPasswordVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    // MARK: - Properties
   // var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblForgotPassword: themeLabel!
    @IBOutlet weak var txtEmailOrPhone: floatTextField!
    @IBOutlet weak var btnSend: submitButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setUp()
    }

    // MARK: - Other Methods
    func setUp() {
       // self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        self.navigationController?.navigationBar.isHidden = false
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    
    func setUpLocalizedStrings(){
        lblForgotPassword.text = "ForgotPasswordVC_lblForgotPassword".Localized()
        txtEmailOrPhone.placeholder = "ForgotPasswordVC_txtEmailOrPhone".Localized()
        btnSend.setTitle("ForgotPasswordVC_btnSend".Localized(), for: .normal)
    }
    // MARK: - IBActions
    @IBAction func btnSend(_ sender: Any) {
//           self.navigationController?.popViewController(animated: true)
      //  webserviceForForgotPassword()
        let checkEmail = txtEmailOrPhone.validatedText(validationType: ValidatorType.requiredField(field: "Email / Phone number"))
        
        if(!checkEmail.0)
        {
            Utilities.ShowAlert(OfMessage: checkEmail.1)
            return
        }else{
            webserviceForForgotPassword()
        }
       }
    // MARK: - Api Calls
    func webserviceForForgotPassword(){
        let forgot = ForgotPasswordReqModel()
        forgot.email = txtEmailOrPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        WebServiceSubClass.ForgotPassword(forgotPassword: forgot, showHud: true, completion: { (response, status, error) in
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
}
