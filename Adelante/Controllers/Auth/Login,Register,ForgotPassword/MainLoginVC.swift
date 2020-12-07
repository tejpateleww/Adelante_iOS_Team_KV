//
//  MainLoginVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MainLoginVC: UIViewController {

    // MARK: - Properties
    
    //MARK: - IBOutlets
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Other Methods

    
    //MARK:- IBActions
    @IBAction func btnSkipClicked(_ sender: Any) {
        appDel.navigateToHome()
    }
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        let loginVc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID)
        self.navigationController?.pushViewController(loginVc, animated: true)
    }
    
    @IBAction func btnCreateAccountClicked(_ sender: Any) {
        let registerVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterViewController.storyboardID)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
     // MARK: - Api Calls
    
}
