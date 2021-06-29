//
//  RestaurantReviewVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantReviewVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var strRestaurantId = ""
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var objReviewData : ReviewData!
    var arrDetails : [Detail]?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tbvReview: UITableView!
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblRating: themeLabel!
    @IBOutlet weak var lblReviews: themeLabel!
  
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvReview.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        webservicePostReview()
        tbvReview.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavList), name: notifRefreshRestaurantList, object: nil)
        setUpLocalizedStrings()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.ratingAndReviews.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    @objc func refreshFavList() {
        pageNumber = 1
        self.isNeedToReload = true
        self.webservicePostReview()
    }
    func setData(){
        self.lblRestaurantName.text = objReviewData.name
        self.lblRating.text = objReviewData.rating
        self.lblReviews.text = String(format: "RestaurantReviewVC_lblReviews".Localized(), objReviewData.review)
        self.lblAddress.text = objReviewData.address
    }
    func setUpLocalizedStrings()
    {
        //        lblAreaName.text = "RestaurantReviewVC_lblAreaName".Localized()
        //        lblReviews.text = String(format: "RestaurantReviewVC_lblReviews".Localized(), "35")
    }
    
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if isNeedToReload {
            pageNumber = pageNumber + 1
            webservicePostReview()
        }
        // done, do whatever
    }
    // MARK: - IBActions
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ATDebug :: \(#function)")
        if arrDetails?.count == 0 {
            return 1
           
        } else {
            return arrDetails?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ATDebug :: \(#function)")
        if arrDetails?.count == 0 {
            let NoDatacell = tbvReview.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            
            NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
            NoDatacell.lblNoDataTitle.text = "Be The First to Rate This Store".Localized()
            
            return NoDatacell
        } else {
            let cell:ReViewDiscCell = tbvReview.dequeueReusableCell(withIdentifier: "ReViewDiscCell", for: indexPath)as! ReViewDiscCell
            cell.lblName.text = arrDetails?[indexPath.row].fullName
            cell.lblDescription.text = arrDetails?[indexPath.row].feedback
            cell.vwRating.rating = Double(arrDetails?[indexPath.row].rating ?? "0.0") ?? 0.0
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("ATDebug :: \(#function)")
        if arrDetails?.count == 0 {
            return tableView.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // MARK: - Api Calls
    @objc func webservicePostReview(){
        let reviewList = ReviewListReqModel()
        reviewList.restaurant_id = strRestaurantId
        reviewList.user_id = SingletonClass.sharedInstance.UserId
        reviewList.page = "\(pageNumber)"
        WebServiceSubClass.ReviewList(reviewListModel: reviewList, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            self.refreshList.endRefreshing()
            if status{
                let reviewData = ReviewListResModel.init(fromJson: response)
                if self.pageNumber == 1 {
                    self.objReviewData = reviewData.data
                    if reviewData.data.details.count == 0 {
                        self.arrDetails = []
                    } else {
                        self.arrDetails = reviewData.data.details
                    }
                    print("ATDebug :: \(self.arrDetails?.count)")
                } else {
                    let arrTemp = reviewData.data.details
                    arrTemp?.forEach({ (element) in
                        self.arrDetails?.append(element)
                    })
                    
                    
                    if (arrTemp?.count ?? 0) < self.pageLimit {
                        self.isNeedToReload = false
                    }
                }
                self.setData()
                DispatchQueue.main.async {
                    self.tbvReview.reloadData()
                }
                
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
           
        })
    }
}
