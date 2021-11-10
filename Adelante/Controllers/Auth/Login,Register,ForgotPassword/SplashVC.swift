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
            
            if status {
                if let isUpdateAvailble = json["update"].bool {
                    if !isUpdateAvailble {
                        
                        // Show an alert, Optional update is available :
                        if let msg = json["message"].string {
                            let alert = UIAlertController(title: AppName,
                                                          message: msg,
                                                          preferredStyle: UIAlertController.Style.alert)
                            
                            // let okAction = UIAlertAction(title: "OK",style: .cancel, handle)
                            
                            let okAction = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                                
                                if let url = URL(string: AppURL) {
                                    UIApplication.shared.open(url)
                                    Utilities.topMostController()?.present(alert, animated: true, completion: nil)
                                }
                            })
                            
                            let LaterAction = UIAlertAction(title: "Later", style: .default, handler: { (action) in
                                self.setupNavigationToLogin()
                            })
                            
                            alert.addAction(okAction)
                            alert.addAction(LaterAction)
                            
                            Utilities.topMostController()?.present(alert, animated: true, completion: nil) // Display a two Action alert.  if yes then redirect to APP store :
                        }
                    }
                }
                else {
                    self.setupNavigationToLogin()
                }
                
                
            } else {
                
                
                // Maintainance Flow :
                
                //                let update = json["update"].string
                
                if let update = json["update"].bool, update == false {
                    
                    if let maintenance = json["maintenance"].bool, maintenance == true {
                        
                        let msg = json["message"].stringValue
                        
                        // stop user here :
                        let alert = UIAlertController(title: AppName,
                                                      message: msg,
                                                      preferredStyle: UIAlertController.Style.alert)
                        
                        Utilities.topMostController()?.present(alert, animated: true, completion: nil)
                      //  Utilities.displayAlertForMainantance(msg)
                    }
                } else if let update = json["update"].bool, update == true {
                    // Force update :
                    
                    if let msg = json["message"].string {
                        let alert = UIAlertController(title: AppName,
                                                      message: msg,
                                                      preferredStyle: UIAlertController.Style.alert)
                        
                        let okAction = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                            
                            if let url = URL(string: AppURL) {
                                UIApplication.shared.open(url)
                                Utilities.topMostController()?.present(alert, animated: true, completion: nil)
                            }
                        })
                        
                        alert.addAction(okAction)
                        Utilities.topMostController()?.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                if let strMessage = json["message"].string {
                    Utilities.ShowAlert(OfMessage: strMessage)
                } else {
                    Utilities.ShowAlert(OfMessage: "No internet connection")
                    
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
