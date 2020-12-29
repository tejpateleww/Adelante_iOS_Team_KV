//
//  RateReviewVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RateReviewVC: BaseViewController {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblRateRestaurant: UILabel!
    @IBOutlet weak var tvRateReview: themeTextView!
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
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.ratingAndReviews.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
                 self.customTabBarController?.hideTabBar()
             }
    func setUpLocalizedStrings(){
        lblRateRestaurant.text = "RateReviewVC_lblRateRestaurant".Localized()
        tvRateReview.placeholder = "RateReviewVC_tvRateReview".Localized()
        btnSubmit.setTitle("RateReviewVC_btnSubmit".Localized(), for: .normal)
    }
    // MARK: - IBActions
    
    // MARK: - Api Calls
}
