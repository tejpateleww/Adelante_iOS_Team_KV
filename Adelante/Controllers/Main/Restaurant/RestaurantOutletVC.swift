//
//  RestaurantOutletVC.swift
//  Adelante
//
//  Created by baps on 08/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class RestaurantOutletVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var btnFilter: collectionVwFilterBtns!
    @IBOutlet weak var tblRestaurantList: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - Other Methods
    func setup(){
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.RestaurantOutletVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        tblRestaurantList.delegate = self
        tblRestaurantList.dataSource = self
        tblRestaurantList.reloadData()
    }
    // MARK: - IBActions
    
    @IBAction func btnFilterClick(_ sender: Any) {
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRestaurantList.dequeueReusableCell(withIdentifier: RestaurantOutletListCell.reuseIdentifier,for: indexPath) as! RestaurantOutletListCell
//        cell.
        return cell
    }
    
    // MARK: - Api Calls
}
