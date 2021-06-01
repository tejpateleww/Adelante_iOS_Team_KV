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
    var arrNotification : [NotificationDatum]?

    // MARK: - IBOutlets
   
    @IBOutlet weak var tbvNotification: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvNotification.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
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
        if arrNotification?.count == 0 {
            return 1
        } else {
            return arrNotification?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrNotification?.count == 0 {
            return tableView.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrNotification?.count != 0 {
            let cell:NotificationCell = tbvNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)as! NotificationCell
            cell.lblNotificationName.text = arrNotification?[indexPath.row].notificationTitle
            cell.lblNotificationDetail.text = arrNotification?[indexPath.row].descriptionField
            cell.selectionStyle = .none
            return cell
        } else {
            let NoDatacell = tbvNotification.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            
            NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
            NoDatacell.lblNoDataTitle.text = "No notification found".Localized()
        
            return NoDatacell
        }
       
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
