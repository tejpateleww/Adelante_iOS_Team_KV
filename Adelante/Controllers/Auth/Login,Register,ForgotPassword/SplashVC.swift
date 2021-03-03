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
        webservice_Init()
        webserviceSorting()
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
                if userDefault.getUserData() != nil{
                    let userdata = userDefault.getUserData()
                    SingletonClass.sharedInstance.UserId = userdata?.id ?? ""
                    SingletonClass.sharedInstance.Api_Key = "\(userDefault.value(forKey: UserDefaultsKey.X_API_KEY.rawValue) ?? "")"
                    SingletonClass.sharedInstance.LoginRegisterUpdateData = userdata
                    userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                    appDel.navigateToHome()
                }
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
        }
    }
    func webserviceSorting(){
        WebServiceSubClass.sorting(showHud: true, completion: { (json, status, response) in
            if(status)
            {
                let sortingModel = sortingResModel.init(fromJson: json)
                SingletonClass.sharedInstance.arrSorting = sortingModel.data
                SingletonClass.sharedInstance.topSellingId = sortingModel.top_selling_id
                //self.setupUserDetails()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
}

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
