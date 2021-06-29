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
    
    var arrPastList :  [orderListingData]?
    var arrInProcessList :  [orderListingData]?
    
    var isRepeatFrom = false
    var strOrderId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var tblOrders: UITableView!
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrders.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "past" : "In-Process")
        tblOrders.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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
    
    @IBAction func segmentControlChanged(_ sender: BetterSegmentedControl) {
        selectedSegmentTag = sender.index
        if selectedSegmentTag == 0{
            if self.arrPastList?.count == 0{
                webserviceGetOrderDetail(selectedOrder:  "past" )
            }
        }else{
            if self.arrInProcessList == nil || self.arrInProcessList?.count == 0 {
                webserviceGetOrderDetail(selectedOrder:  "In-Process")
            }
            
        }
        self.tblOrders.reloadData()
    }
    
    @objc func btnShareClick()
    {
        let text = ""
        
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentTag == 0  {
            
            if self.arrPastList?.count == 0 {
                return 1
            } else {
                return self.arrPastList?.count ?? 0
            }
        } else {
            
            if self.arrInProcessList?.count == 0 {
                return 1
            } else {
                return self.arrInProcessList?.count ?? 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedSegmentTag == 0  {
            if self.arrPastList?.count == 0 {
                let NoDatacell = tblOrders.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: NoData.pastorder.ImageName)
                NoDatacell.lblNoDataTitle.text = "No past order found".Localized()
                
                return NoDatacell
            } else {
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
                
                if let obj = self.arrPastList?[indexPath.row]  {
                    cell.lblRestName.text = obj.restaurantName
                    cell.lblRestLocation.text = obj.street
                    cell.lblPrice.text = "\(CurrencySymbol)" + obj.total.ConvertToTwoDecimal()
                    cell.lblItem.text = obj.restaurantItemName
                    cell.lblDtTime.text = obj.date
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(obj.image ?? "")"
                    cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.btnShare.addTarget(self, action: #selector(btnShareClick), for: .touchUpInside)
                    
                    strOrderId = obj.id
                }
                
                
                cell.cancel = {
                    
                    let alertController = UIAlertController(title: AppName,
                                                            message: "Are you sure you want to cancel order ?".Localized(),
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
                        self.webserviceCancelOrder()
                        
                    })
                    self.present(alertController, animated: true)
                }
                cell.selectionStyle = .none
                return cell
                
            }
        } else {
            if self.arrInProcessList?.count == 0 {
                
                let NoDatacell = tblOrders.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: NoData.inorder.ImageName)
                NoDatacell.lblNoDataTitle.text = "No in-progress order found".Localized()
                
                return NoDatacell
            } else {
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
                
                if let obj = self.arrInProcessList?[indexPath.row] {
                    cell.lblRestName.text = obj.restaurantName
                    cell.lblRestLocation.text = obj.street
                    cell.lblPrice.text = "\(CurrencySymbol)" + obj.total.ConvertToTwoDecimal()
                    cell.lblItem.text = obj.restaurantItemName
                    cell.lblDtTime.text = obj.date
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(obj.image ?? "")"
                    cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.btnShare.addTarget(self, action: #selector(btnShareClick), for: .touchUpInside)
                    
                    strOrderId = obj.id
                }
                
                
                cell.cancel = {
                    
                    let alertController = UIAlertController(title: AppName,
                                                            message: "Are you sure you want to cancel order ?".Localized(),
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
                        self.webserviceCancelOrder()
                        
                    })
                    self.present(alertController, animated: true)
                }
                cell.selectionStyle = .none
                return cell
                
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSegmentTag == 0  {
            
            if self.arrPastList?.count == 0 {
                return tableView.frame.size.height
            } else {
                return UITableView.automaticDimension
            }
        } else {
            
            if self.arrInProcessList?.count == 0 {
                return tableView.frame.size.height
            } else {
                return UITableView.automaticDimension
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentTag == 0  {
            
            if self.arrPastList?.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                if let obj = self.arrPastList?[indexPath.row] {
                    orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                    orderDetailsVC.orderId = obj.id
                    orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : "In-Process"
                    orderDetailsVC.strRestaurantId = obj.restaurant_id
                    orderDetailsVC.delegateCancelOrder = self
                    self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                }
                
                
            }
        } else {
            
            if self.arrInProcessList?.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                if let obj = self.arrInProcessList?[indexPath.row] {
                    orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                    orderDetailsVC.orderId = obj.id
                    orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : "In-Process"
                    orderDetailsVC.strRestaurantId = obj.restaurant_id
                    orderDetailsVC.delegateCancelOrder = self
                    self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                }
                
                
            }
        }
        
    }
    
    
    // MARK: - Api Calls
    func webserviceGetOrderDetail(selectedOrder:String){
        
        let orderList = OrderListReqModel()
        orderList.user_id = SingletonClass.sharedInstance.UserId
        orderList.type = selectedOrder
        WebServiceSubClass.orderList(orderListModel: orderList, showHud: true, completion: { (response, status, error) in
            self.refreshList.endRefreshing()
            if status{
                let orderListData = orderListingResModel.init(fromJson: response)
                
                let OrderList:[orderListingData] = orderListData.data
                if self.selectedSegmentTag == 0 {
                    self.arrPastList = OrderList
                    
                } else {
                    self.arrInProcessList = OrderList
                    
                }
                DispatchQueue.main.async {
                    self.tblOrders.reloadData()
                }
                
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
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
