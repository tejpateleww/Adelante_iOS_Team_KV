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
    // MARK: - IBActions
    
    // MARK: - Api Calls
}
