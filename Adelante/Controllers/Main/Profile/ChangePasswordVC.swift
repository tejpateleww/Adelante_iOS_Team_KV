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
    
   
    // MARK: - Api Calls
}
