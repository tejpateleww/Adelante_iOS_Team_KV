//
//  RateReviewVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import Cosmos
import SkeletonView

class RateReviewVC: BaseViewController {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var strRestaurantId = ""
    var strOrderId = ""
    var GiveRateReviewdone:((Bool)->())?
    // MARK: - IBOutlets
    @IBOutlet weak var lblRateRestaurant: themeLabel!
    @IBOutlet weak var tvRateReview: themeTextView!
    @IBOutlet weak var btnSubmit: submitButton!
    @IBOutlet weak var vwRating: CosmosView!
    
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
    @IBAction func btnSubmitClick(_ sender: Any) {
        webserviceReviewRating()
    }
    
    // MARK: - Api Calls
    func webserviceReviewRating(){
        let Rating = RateOrderReqModel()
        Rating.user_id = SingletonClass.sharedInstance.UserId
        Rating.order_id = strOrderId
        Rating.restaurant_id = strRestaurantId
        Rating.review_count = "\(vwRating.rating)"
        Rating.feedback = tvRateReview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        WebServiceSubClass.RateOrder(rateOrder: Rating, showHud: true, completion: { (json, status, response) in
            //            self.hideHUD()
            if(status)
            {
                Utilities.displayAlert(title: AppInfo.appName, message: json["message"].string ?? "", completion: { index in
                    self.tvRateReview.text = ""
                    self.vwRating.rating = 1
                    if let donereview = self.GiveRateReviewdone{
                        donereview(true)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
}
