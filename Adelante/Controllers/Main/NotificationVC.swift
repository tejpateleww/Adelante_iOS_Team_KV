//
//  NotificationVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
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
class NotificationVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Properties
    
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var arrNotification = [NotificationDatum]()
//        [notificationDetail(strTitle: "System", strDetail: "Your Order #1234 has been successfully completed", imgNotif: "Dummy_notif1"),notificationDetail(strTitle: "System", strDetail: "Your Order #1205 has been cancelled successfully", imgNotif: "Dummy_notif2"),notificationDetail(strTitle: "System", strDetail: "Thank you! Your transaction is successfully completed", imgNotif: "Dummy_notif3"),notificationDetail(strTitle: "System", strDetail: "Your Order #1234 has been successfully Completed", imgNotif: "Dummy_notif1"),notificationDetail(strTitle: "System", strDetail: "Your Order #1205 has been cancelled successfully", imgNotif: "Dummy_notif2"),notificationDetail(strTitle: "System", strDetail: "Thank you! Your transaction is successfully completed", imgNotif: "Dummy_notif3"),notificationDetail(strTitle: "System", strDetail: "Your Order #1234 has been successfully completed", imgNotif: "Dummy_notif1"),notificationDetail(strTitle: "System", strDetail: "Your Order #1205 has been cancelled successfully", imgNotif: "Dummy_notif2"),notificationDetail(strTitle: "System", strDetail: "Thank you! Your transaction is successfully completed", imgNotif: "Dummy_notif3")]
    // MARK: - IBOutlets
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var tbvNotification: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webservicePostNotification()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.notifications.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - IBActions
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = tbvNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)as! NotificationCell
        cell.lblNotificationName.text = arrNotification[indexPath.row].notificationTitle
        cell.lblNotificationDetail.text = arrNotification[indexPath.row].descriptionField
//        cell.imgNotificationIcon.image = UIImage(named: arrNotification[indexPath.row].imgNotif)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Api Calls
    func webservicePostNotification(){
        let notification = NotificationReqModel()
        notification.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.NotificationModel(notificationModel: notification, showHud: false, completion: { (response, status, error) in
            //            self.hideHUD()
            if(status)
            {
                let notificatiData = notificaationResModel.init(fromJson: response)
                self.arrNotification = notificatiData.data
                self.tbvNotification.reloadData()
            }
            else
            {
                Utilities.displayErrorAlert(response["message"].string ?? "No internet connection")
            }
        })
    }
}
