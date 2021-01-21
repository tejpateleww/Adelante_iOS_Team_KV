//
//  MyFoodlistVC.swift
//  Adelante
//
//  Created by baps on 04/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyFoodlistVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    // MARK: - IBOutlet
    @IBOutlet weak var tblFoodLIst: UITableView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFoodLIst.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webservicePostMyFoodlist), for: .valueChanged)
        setup()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myFoodlist.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.clearAll.value], isTranslucent: true, isShowHomeTopBar: false)
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
        let cell:MyFoodlistCell = tblFoodLIst.dequeueReusableCell(withIdentifier: "MyFoodlistCell", for: indexPath) as! MyFoodlistCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - Api Calls
    @objc func webservicePostMyFoodlist(){
        DispatchQueue.main.async {
            self.refreshList.endRefreshing()
        }
    }
}
