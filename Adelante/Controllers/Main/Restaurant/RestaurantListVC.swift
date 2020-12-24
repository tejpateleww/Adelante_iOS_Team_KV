//
//  RestaurantListVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var btnFilterOptions: UIButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.restaurantList.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deselectFilterOptionRest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: NSNotification.Name(rawValue: "deselectFilterOptionRest"), object: nil)
        
        btnFilterOptions.isSelected = false
        self.changeLayoutOfFilterButton()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearch.frame.height))
        txtSearch.leftView = padding
        txtSearch.leftViewMode = UITextField.ViewMode.always
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
    }
    
    @objc func deSelectFilterAndRefresh() {
        btnFilterOptions.isSelected = false
        changeLayoutOfFilterButton()
    }
    
    func changeLayoutOfFilterButton() {
        if btnFilterOptions.isSelected {
            btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
            
        } else {
            btnFilterOptions.backgroundColor = colors.segmentDeselectedColor.value
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.changeLayoutOfFilterButton()
        } else {
            sender.isSelected = true
            self.changeLayoutOfFilterButton()
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID)
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier, for: indexPath) as! RestaurantListCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID)
        self.navigationController?.pushViewController(restDetailsVc, animated: true)
    }
    
    // MARK: - Api Calls
}
