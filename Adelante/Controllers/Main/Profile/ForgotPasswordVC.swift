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
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - Other Methods
    func setUp() {
       // self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        self.navigationController?.navigationBar.isHidden = false
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    @IBAction func btnSend(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
    // MARK: - IBActions
    
    // MARK: - Api Calls
}
