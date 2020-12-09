//
//  MyOrdersVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class MyOrdersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblOrders: UITableView!
    
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
        
        cell.Repeat = {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
            self.navigationController?.pushViewController(controller, animated: true)
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
    
}

// MARK: - UITableViewCell --> MyOrdersCell
class MyOrdersCell: UITableViewCell {
    
    // MARK: - IBOutlets of MyOrdersCell

    @IBOutlet weak var vwShare: UIView!
    @IBOutlet weak var vwRepeatOrder: UIView!
    @IBOutlet weak var vwCancelOrder: UIView!
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var lblRestName: tblMyOrdersLabel!
    @IBOutlet weak var lblRestLocation: tblMyOrdersLabel!
    @IBOutlet weak var lblPrice: tblMyOrdersLabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblItem: tblMyOrdersLabel!
    @IBOutlet weak var lblDtTime: tblMyOrdersLabel!
    @IBOutlet weak var btnRepeatOrder: myOrdersBtn!
    @IBOutlet weak var btnCancelOrder: myOrdersBtn!
    
    // MARK: - Properties
    var cancel : (() -> ())?
    var Repeat : (() -> ())?
    @IBAction func btnCancel(_ sender: myOrdersBtn) {
        if let click = self.cancel {
            click()
        }
    }
    @IBAction func btnRepeat(_ sender: myOrdersBtn) {
        if let click = self.Repeat {
            click()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
