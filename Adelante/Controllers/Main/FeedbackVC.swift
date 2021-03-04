//
//  FeedbackVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class FeedbackVC: BaseViewController {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtTitle: floatTextField!
    @IBOutlet weak var txtEmail: floatTextField!
    @IBOutlet weak var tvFeedback: themeTextView!
    @IBOutlet weak var btnSubmit: submitButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.FeedbackVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    func setUpLocalizedStrings(){
        txtTitle.placeholder = "FeedbackVC_txtTitle".Localized()
        txtEmail.placeholder = "FeedbackVC_txtEmail".Localized()
        tvFeedback.placeholder = "FeedbackVC_tvFeedback".Localized()
        btnSubmit.setTitle("FeedbackVC_btnSubmit".Localized(), for: .normal)
    }
    //Mark : Validation
    func validation() -> Bool
    {
        let txtTemp = UITextField()
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmail = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtEmail.placeholder ?? ""))
        let checkEmailValid = txtTemp.validatedText(validationType: ValidatorType.email)
        if(!checkEmail.0)
        {
            Utilities.ShowAlert(OfMessage: checkEmail.1)
            return checkEmail.0
        }
        else if(!checkEmailValid.0)
        {
            Utilities.ShowAlert(OfMessage:"Please enter valid a email")
            return checkEmailValid.0
        }
        return true
    }
    // MARK: - IBActions
    
    @IBAction func btnSubmitClick(_ sender: submitButton) {
        if validation(){
            webserviceForFeedback()
        }
    }
    // MARK: - Api Calls
    func webserviceForFeedback()
    {
        let feedback = FeedbackReqModel()
        feedback.user_id = SingletonClass.sharedInstance.UserId
        feedback.title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        feedback.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        feedback.message = tvFeedback.text.trimmingCharacters(in: .whitespacesAndNewlines)
        //        self.showHUD()
        WebServiceSubClass.Feedback(Feedbackmodel: feedback, showHud: true, completion: { (json, status, response) in
            //            self.hideHUD()
            if(status)
            {
                Utilities.displayAlert(json["message"].string ?? "")
                self.txtEmail.text = ""
                self.txtTitle.text = ""
                self.tvFeedback.text = ""
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
}
