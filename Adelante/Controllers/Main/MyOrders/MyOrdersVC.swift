//
//  MyOrdersVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SDWebImage

class MyOrdersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate,orderCancelDelegate {
    
    

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var refreshList = UIRefreshControl()
    var arrOrderListing = [orderListingData]()
    var isRepeatFrom = false
    var strOrderId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var imgOrderEmpty: UIImageView!
    
    // MARK: - ViewController Lifecycle
     override func viewDidLoad() {
          super.viewDidLoad()
        tblOrders.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "Past" : "In-Process")
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
    @objc func refreshData(){
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "past" : "In-Process")
    }
    // MARK: - IBActions
//    @IBAction func btnRepeatNew(_ sender: Any){
//        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:checkOutVC.storyboardID) as! checkOutVC
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
    @IBAction func segmentControlChanged(_ sender: BetterSegmentedControl) {
        selectedSegmentTag = sender.index
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "past" : "In-Process")
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
        return arrOrderListing.count
    }
//    func orderListShow(){
//    }
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
        cell.lblRestName.text = arrOrderListing[indexPath.row].restaurantName
        cell.lblRestLocation.text = arrOrderListing[indexPath.row].street
        cell.lblPrice.text = "$" + arrOrderListing[indexPath.row].price
        cell.lblItem.text = arrOrderListing[indexPath.row].restaurantItemName
        cell.lblDtTime.text = arrOrderListing[indexPath.row].date
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrOrderListing[indexPath.row].image ?? "")"
        cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        cell.btnShare.addTarget(self, action: #selector(btnShareClick), for: .touchUpInside)
//        cell.btnRepeatOrder.addTarget(self, action: #selector(btnRepeatNew), for: .touchUpInside)
        strOrderId = arrOrderListing[indexPath.row].id
//        cell.Repeat = {
//            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:checkOutVC.storyboardID) as! checkOutVC
//            controller.strOrderId = self.arrOrderListing[indexPath.row].id
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
        cell.cancel = {
            self.webserviceCancelOrder()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
        orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
        orderDetailsVC.orderId = arrOrderListing[indexPath.row].id
        orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : "In-Process"
        orderDetailsVC.strRestaurantId = arrOrderListing[indexPath.row].restaurant_id
        orderDetailsVC.delegateCancelOrder = self
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
    
    // MARK: - Api Calls
    func webserviceGetOrderDetail(selectedOrder:String){
        let orderList = OrderListReqModel()
        orderList.user_id = SingletonClass.sharedInstance.UserId
        orderList.type = selectedOrder
        WebServiceSubClass.orderList(orderListModel: orderList, showHud: true, completion: { (response, status, error) in
            if status{
                let orderListData = orderListingResModel.init(fromJson: response)
                self.arrOrderListing = orderListData.data
                self.tblOrders.reloadData()
//                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
////                    self.navigationController?.popViewController(animated: true)
//                }, otherTitles: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            if self.arrOrderListing.count > 0{
                self.tblOrders.restore()
                self.imgOrderEmpty.isHidden = true
                self.tblOrders.isHidden = false
               
            }else {
                self.tblOrders.isHidden = true
                self.imgOrderEmpty.isHidden = false
//                self.view.bringSubviewToFront(self.imgFavorite)
//                self.tblMainList.setEmptyMessage("emptyMsg_Restaurant".Localized())
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    func refreshOrderDetailsScreen() {
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "past" : "In-Process")
    }
    func webserviceCancelOrder(){
        let cancelOrder = CancelOrderReqModel()
        cancelOrder.user_id = SingletonClass.sharedInstance.UserId
        cancelOrder.main_order_id = strOrderId
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                Utilities.displayAlert("", message: json["message"].string ?? "", completion: {_ in
                    self.refreshOrderDetailsScreen()
                }, otherTitles: nil)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
}
