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
    @IBOutlet weak var btnSkip: submitButton!
    @IBOutlet weak var btnSignin: submitButton!
    @IBOutlet weak var btnCreateAccount: submitButton!
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    // MARK: - Other Methods
    func setUpLocalizedStrings() {
        btnSkip.setTitle("MainLoginVC_btnSkip".Localized(), for: .normal)
        btnSignin.setTitle("MainLoginVC_btnSignin".Localized(), for: .normal)
        btnCreateAccount.setTitle("MainLoginVC_btnCreateAccount".Localized(), for: .normal)
    }
    
    //MARK:- IBActions
    @IBAction func btnSkipClicked(_ sender: Any) {
        
//        userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
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
