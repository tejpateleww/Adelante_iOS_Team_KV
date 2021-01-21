//
//  NotificationVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
   
    // MARK: - Properties
    
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    // MARK: - IBOutlets
    @IBOutlet weak var tbvNotification: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvNotification.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webservicePostNotification), for: .valueChanged)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = tbvNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)as! NotificationCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // MARK: - Api Calls
    @objc func webservicePostNotification(){
        DispatchQueue.main.async {
            self.refreshList.endRefreshing()
        }
    }
}
