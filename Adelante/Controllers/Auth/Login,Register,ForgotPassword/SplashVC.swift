//
//  SplashVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SwiftyJSON

class SplashVC: UIViewController {

    //MARK: - Properties
    
    //MARK: - IBOutlets
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
        setupNavigationToLogin()
    }
    
    // MARK: - Other Methods
    func setupNavigationToLogin() {
        Timer.scheduledTimer(withTimeInterval: 4.5, repeats: false) { (timer) in
            if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == true{
            let dic = userDefault.value(forKey: UserDefaultsKey.userProfile.rawValue) as? [String:Any]
                let userData = Profile.init(fromDictionary: dic!)
                SingletonClass.sharedInstance.UserId = userData.id
                SingletonClass.sharedInstance.Api_Key = userData.apiKey
            SingletonClass.sharedInstance.LoginRegisterUpdateData = userData
                appDel.navigateToHome()
            } else {
                appDel.navigateToMainLogin()
            }
        }
    }
    
    //MARK:- IBActions
    
    // MARK: - Api Calls
}
extension SplashVC{
    func webservice_Init(){
        let strURL = APIEnvironment.baseURL + ApiKey.Init.rawValue + "/" + kAPPVesion + "/" + "ios_customer"
        WebServiceSubClass.initApi(strURL: strURL) { (response, status, error) in
            
            let initData = InitObject.init(fromJson: response)
//            self.showAlertWithTwoButtonCompletion(title: AppName, Message: initData.message, defaultButtonTitle: "OK", cancelButtonTitle: "") { (index) in
//                if index == 0{
                    
//                }
            }
        }
    }
//}
struct InitObject {
    
    var serviceCharge : Double!
    var message : String!
    var status : Bool!
    var support : String!
    var update: String!
    var isMaintenance : String!
   
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        serviceCharge = json["service_charge"].doubleValue
        message = json["message"].stringValue
        status = json["status"].boolValue
        support = json["support"].stringValue
        update = json["update"].stringValue
        isMaintenance = json["maintenance"].stringValue
    }
}
