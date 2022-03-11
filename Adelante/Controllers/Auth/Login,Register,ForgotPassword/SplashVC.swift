//
//  SplashVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire

class SplashVC: UIViewController {
    
    //MARK: - Properties
    //MARK: - IBOutlets
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webservice_Init()
        webserviceSorting()
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name(rawValue: NotificationKeys.PushShareOrderAccept), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDel.moveToOrderDetailsPage), name: NSNotification.Name(rawValue: NotificationKeys.PushShareOrderAccept), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
      //  setupNavigationToLogin()
    }
    
    // MARK: - Other Methods
    func setupNavigationToLogin() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
        }
    }
    //MARK:- IBActions
    
    // MARK: - Api Calls
    
}
extension SplashVC{
    func webservice_Init(){
        let strURL = APIEnvironment.baseURL + ApiKey.Init.rawValue + "/" + kAPPVesion + "/" + "ios_customer"
        WebServiceSubClass.initApi(strURL: strURL) { (json, status, error) in
            let isUpdateAvailble = json["update"].stringValue
            if status{
                
                self.setupNavigationToLogin()
                
            }else {
                
                if isUpdateAvailble == "0"{
                    
                    //MARK: -  Show an alert, Optional update is available :
                    
                    Utilities.showAlertWithTitleFromWindow(title: AppInfo.appName, andMessage: json["message"].stringValue, buttons: ["Update","Later"]) { index in
                        if index == 0{
                            if let url = URL(string: AppURL) {
                                UIApplication.shared.open(url)
                                self.setupNavigationToLogin()
                            }
                        }else{
                            self.setupNavigationToLogin()
                        }
                    }
                } else if isUpdateAvailble == "1" {
                    //MARK: - Show alert when Force update :
                    Utilities.showAlertWithTitleFromWindow(title:  AppInfo.appName, andMessage: json["message"].stringValue, buttons: ["Update"]) { index in
                        if let url = URL(string: AppURL) {
                            UIApplication.shared.open(url)
                        }
                    }
                }else if isUpdateAvailble == "2" {
                    Utilities.showAlertWithTitleFromWindow(title:  AppInfo.appName, andMessage: json["message"].stringValue, buttons: ["Ok"]) { index in
                        
                    }
                }

                
            }
            
            
        }
        
        
    }
    func webserviceSorting(){
        WebServiceSubClass.sorting(showHud: false, completion: { (json, status, response) in
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

