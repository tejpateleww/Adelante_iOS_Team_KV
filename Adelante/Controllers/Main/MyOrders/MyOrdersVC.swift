//
//  MyOrdersVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class MyOrdersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var refreshList = UIRefreshControl()
    // MARK: - IBOutlets
    @IBOutlet weak var tblOrders: UITableView!
    
    // MARK: - ViewController Lifecycle
     override func viewDidLoad() {
          super.viewDidLoad()
        tblOrders.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webserviceGetOrderDetail), for: .valueChanged)
          setup()
      
      self.navigationController?.interactivePopGestureRecognizer?.delegate = self

      }
    
      override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          self.customTabBarController?.showTabBar()
        
      }
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myOrders.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        tblOrders.delegate = self
        tblOrders.dataSource = self
        tblOrders.reloadData()
    }
    
    // MARK: - IBActions

    @IBAction func segmentControlChanged(_ sender: BetterSegmentedControl) {
        selectedSegmentTag = sender.index
        self.tblOrders.reloadData()
    }
    
    @objc func btnShareClick()
    {
        let text = ""

               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

               // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
    }
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrders.dequeueReusableCell(withIdentifier: MyOrdersCell.reuseIdentifier, for: indexPath) as! MyOrdersCell
        if selectedSegmentTag == 0 {
            cell.vwShare.isHidden = true
            cell.vwCancelOrder.isHidden = true
            cell.vwRepeatOrder.isHidden = false
        } else {
            cell.vwShare.isHidden = false
            cell.vwCancelOrder.isHidden = false
            cell.vwRepeatOrder.isHidden = true
        }
        cell.btnShare.addTarget(self, action: #selector(btnShareClick), for: .touchUpInside)
       // cell.btnRepeatOrder.addTarget(self, action: #selector(btnRepeatNew), for: .touchUpInside)
        cell.Repeat = {
//            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:checkOutVC.storyboardID) as! checkOutVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        cell.cancel = {
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
        orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
    
    // MARK: - Api Calls
    @objc func webserviceGetOrderDetail(){
        DispatchQueue.main.async {
            self.refreshList.endRefreshing()
        }
    }
}
