//
//  MyProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyProfileVC: BaseViewController {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var btnEditAccount: submitButton!
    @IBOutlet weak var txtEmail: floatTextField!
    @IBOutlet weak var txtPhoneNumber: floatTextField!
    
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
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    func setUpLocalizedStrings() {
        lblName.text = "MyProfileVC_lblName".Localized()
        btnEditAccount.setTitle("MyProfileVC_btnEditAccount".Localized(), for: .normal)
        txtEmail.placeholder = "MyProfileVC_txtEmail".Localized()
        txtPhoneNumber.placeholder = "MyProfileVC_txtPhoneNumber".Localized()
    }
    // MARK: - IBActions
    
    @IBAction func BtnEditAccount(_ sender: Any) {
       let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: EditProfileVC.storyboardID) as! EditProfileVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Api Calls
}
