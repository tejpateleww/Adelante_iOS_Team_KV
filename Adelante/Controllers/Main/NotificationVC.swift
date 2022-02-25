//
//  NotificationVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SkeletonView
import SDWebImage

struct notificationDetail{
    var strTitle : String!
    var strDetail : String!
    var imgNotif : String!
    
    init(strTitle:String,strDetail:String,imgNotif:String) {
        self.strTitle = strTitle
        self.strDetail = strDetail
        self.imgNotif = imgNotif
    }
}
class NotificationVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,SkeletonTableViewDataSource {
    // MARK: - Properties
    
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var responseStatus : webserviceResponse = .initial
    var arrNotification = [NotificationDatum]()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var isRefresh = false
    // MARK: - IBOutlets
   
    @IBOutlet weak var tbvNotification: UITableView!{
        didSet{
            tbvNotification.isSkeletonable = true
        }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        registerNIB()
        tbvNotification.delegate = self
        tbvNotification.dataSource = self
        self.tbvNotification.showAnimatedSkeleton()
        webservicePostNotification()
        tbvNotification.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshNotificationList), for: .valueChanged)
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.notifications.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    @objc func refreshNotificationList(){
        self.pageNumber = 1
        self.isRefresh = true
        self.isNeedToReload = true
        webservicePostNotification()
    }
    func registerNIB(){
        tbvNotification.register(UINib(nibName:NoDataTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: NoDataTableViewCell.reuseIdentifier)
        tbvNotification.register(UINib(nibName: ShimmerCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ShimmerCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - IBActions
    
    //MARKL - Skeletontableview datasource
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrNotification.count > 0 ? NotificationCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 10
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if self.isNeedToReload && self.isRefresh == false{
            self.pageNumber = self.pageNumber + 1
            webservicePostNotification()
        }
        // done, do whatever
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrNotification.count != 0 {
                return self.arrNotification.count
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.responseStatus == .gotData{
            if arrNotification.count != 0 {
                let cell:NotificationCell = tbvNotification.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier , for: indexPath)as! NotificationCell
                cell.lblNotificationName.text = arrNotification[indexPath.row].notificationTitle
                cell.lblNotificationDetail.text = arrNotification[indexPath.row].descriptionField
//                if cell.lblNotificationName.text == "Order Placed" || cell.lblNotificationName.text == "Share Order" || cell.lblNotificationName.text == "Send Qsr Order"{
//                    cell.imgNotificationIcon.image = UIImage(named: "Dummy_notif1")
//                }else if cell.lblNotificationName.text == "Cancel Order"{
//                    cell.imgNotificationIcon.image = UIImage(named: "Dummy_notif2")
//                }else{
//                    cell.imgNotificationIcon.image = UIImage(named: "Dummy_notif1")
//                }
                
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrNotification[indexPath.row].image ?? "")"
                cell.imgNotificationIcon.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgNotificationIcon.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.selectionStyle = .none
                return cell
            } else {
                let NoDatacell = tbvNotification.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: "Notification List")
                NoDatacell.lblNoDataTitle.isHidden = true
                NoDatacell.selectionStyle = .none
                return NoDatacell
            }
        }else{
            let Cell = tbvNotification.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
            Cell.selectionStyle = .none
            return Cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrNotification.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }else {
            return self.responseStatus == .gotData ?  230 : 131
        }
    }
    // MARK: - Api Calls
    func webservicePostNotification(){
        let notification = NotificationReqModel()
        notification.user_id = SingletonClass.sharedInstance.UserId
        notification.page = "\(self.pageNumber)"
        WebServiceSubClass.NotificationModel(notificationModel: notification, showHud: false, completion: { (response, status, error) in
            self.refreshList.endRefreshing()
            self.responseStatus = .gotData
            if status {
                let notificatiData = notificaationResModel.init(fromJson: response)
                let Cell = self.tbvNotification.dequeueReusableCell(withIdentifier: "ShimmerCell") as! ShimmerCell
                Cell.stopShimmering()
                self.tbvNotification.stopSkeletonAnimation()
                self.isRefresh = false
                if self.pageNumber == 1 {
                    self.arrNotification = notificatiData.data
                    let arrTemp = notificatiData.data
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                } else {
                    let arrTemp = notificatiData.data
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrNotification.append(arrTemp![i])
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                }
                
//                self.arrNotification = notificatiData.data
                
                self.tbvNotification.dataSource = self
                self.tbvNotification.isScrollEnabled = true
                self.tbvNotification.isUserInteractionEnabled = true
                self.tbvNotification.reloadData()
            }
            else
            {
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
}
