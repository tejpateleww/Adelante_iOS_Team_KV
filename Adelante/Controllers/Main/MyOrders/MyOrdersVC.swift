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
import SkeletonView


class MyOrdersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate,orderCancelDelegate,SkeletonTableViewDataSource {
    
    
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var refreshList = UIRefreshControl()
    var responseStatus : webserviceResponse = .initial
    var arrPastList =  [orderListingData]()
    var arrInProcessList =  [orderListingData]()
    var isfrompayment : Bool?
    var isRepeatFrom = false
    var strOrderId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var tblOrders: UITableView!{
        didSet{
            tblOrders.isSkeletonable = true
        }
    }
    @IBOutlet weak var segment: myOrdersSegmentControl!
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrders.showAnimatedSkeleton()
        registerNIB()
        webserviceGetOrderDetail(selectedOrder: selectedSegmentTag == 0 ? "past" : "In-Process")
        tblOrders.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        setup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
        
        if let _ = SingletonClass.sharedInstance.selectInProcessInMyOrder{
            self.segment.setIndex(1)
            self.segmentControlChanged(self.segment)
        }
        
    }
    // MARK: - Other Methods
    func registerNIB(){
        tblOrders.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblOrders.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
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
        SingletonClass.sharedInstance.selectInProcessInMyOrder = nil
        selectedSegmentTag = sender.index
        if selectedSegmentTag == 0{
            if self.arrPastList.count == 0{
                webserviceGetOrderDetail(selectedOrder:  "past" )
            }
        }else{
            if self.arrInProcessList == nil || self.arrInProcessList.count == 0 {
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
    // MARK: - SkeletonTableview Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if selectedSegmentTag == 0  {
            return self.responseStatus == .gotData ? (self.arrPastList.count ?? 0 > 0 ? MyOrdersCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
        }else{
            return self.responseStatus == .gotData ? (self.arrInProcessList.count ?? 0 > 0 ? MyOrdersCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
        }
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 3
    }
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentTag == 0  {
            if responseStatus == .gotData{
                if arrPastList.count != 0 {
                    return self.arrPastList.count ?? 0
                }else{
                    return 1
                }
            }else{
                return 5
            }
//            if self.arrPastList?.count == 0 {
//                return 1
//            } else {
                
//            }
        } else {
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
                    return self.arrInProcessList.count ?? 0
                }else{
                    return 1
                }
            }else{
                return 5
            }
//            if self.arrInProcessList?.count == 0 {
//                return 1
//            } else {
//                return self.arrInProcessList?.count ?? 0 > 0 ? arrInProcessList?.count ?? 0 : 5
//            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedSegmentTag == 0  {
            if responseStatus == .gotData{
                if arrPastList.count != 0 {
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
                    
                     let obj = self.arrPastList[indexPath.row]
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
                    
                    cell.cancel = {
//                        let alertController = UIAlertController(title: AppName,
//                                                                message: "Are you sure you want to cancel order".Localized(),
//                                                                preferredStyle: .alert)
//                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//                        alertController.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
                            self.webserviceCancelOrder()
//                        })
//                        self.present(alertController, animated: true)
                    }
                    cell.selectionStyle = .none
                    return cell
                    
                }else{
                    let NoDatacell = tblOrders.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    
                    NoDatacell.imgNoData.image = UIImage(named: "Orders")
                    NoDatacell.lblNoDataTitle.isHidden = true
                    NoDatacell.selectionStyle = .none
                    return NoDatacell
                }
            }else {
                let cell = tblOrders.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
                return cell
            }
        } else {
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
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
                    
                     let obj = self.arrInProcessList[indexPath.row] 
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
                    
                    cell.cancel = {
                        
//                        let alertController = UIAlertController(title: AppName,
//                                                                message: "Are you sure you want to cancel order".Localized(),
//                                                                preferredStyle: .alert)
//                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//                        alertController.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
                            self.webserviceCancelOrder()
                            
//                        })
//                        self.present(alertController, animated: true)
                    }
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let NoDatacell = tblOrders.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    
                    NoDatacell.imgNoData.image = UIImage(named: "Orders")
                    NoDatacell.lblNoDataTitle.isHidden = true
                    
                    return NoDatacell
                }} else{
                    let cell = tblOrders.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
                    cell.selectionStyle = .none
                    return cell
                }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSegmentTag == 0  {
            if responseStatus == .gotData{
                if arrPastList.count != 0 {
                    return UITableView.automaticDimension
                }else{
                    return tableView.frame.height
                }
            }else {
                return self.responseStatus == .gotData ?  230 : 131
            }
        } else {
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
                    return UITableView.automaticDimension
                }else{
                    return tableView.frame.height
                }
            }else {
                return self.responseStatus == .gotData ?  230 : 131
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentTag == 0  {
            if self.arrPastList.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                let obj = self.arrPastList[indexPath.row]
                    orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                    orderDetailsVC.orderId = obj.id
                    orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : "In-Process"
                    orderDetailsVC.strRestaurantId = obj.restaurant_id
                    orderDetailsVC.delegateCancelOrder = self
                    self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                
            }
        } else {
            if self.arrInProcessList.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                 let obj = self.arrInProcessList[indexPath.row]
                    orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                    orderDetailsVC.orderId = obj.id
                    orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : "In-Process"
                    orderDetailsVC.strRestaurantId = obj.restaurant_id
                    orderDetailsVC.delegateCancelOrder = self
                    self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                
            }
        }
    }
    
    
    // MARK: - Api Calls
    func webserviceGetOrderDetail(selectedOrder:String){
        
        let orderList = OrderListReqModel()
        orderList.user_id = SingletonClass.sharedInstance.UserId
        orderList.type = selectedOrder
        WebServiceSubClass.orderList(orderListModel: orderList, showHud: false, completion: { (response, status, error) in
            self.refreshList.endRefreshing()
            self.responseStatus = .gotData
            if status{
                let orderListData = orderListingResModel.init(fromJson: response)
                let cell = self.tblOrders.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
                cell.stopShimmering()
                self.tblOrders.stopSkeletonAnimation()
                let OrderList:[orderListingData] = orderListData.data
                if self.selectedSegmentTag == 0 {
                    self.arrPastList = OrderList
                    
                } else {
                    self.arrInProcessList = OrderList
                    
                }
//                DispatchQueue.main.async {
                    self.tblOrders.dataSource = self
                    self.tblOrders.isScrollEnabled = true
                    self.tblOrders.isUserInteractionEnabled = true
                    self.tblOrders.reloadData()
//                }
                
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
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                //controller.modalPresentationStyle = .fullScreen
                controller.isHideCancelButton = false
                controller.isHideSubmitButton = true
                controller.submitBtnTitle = ""
                controller.cancelBtnTitle = "Cancel Order"
                controller.strDescription = "Do you really want  to cancel the order."
                controller.strPopupTitle = "Are you Sure?"
                controller.submitBtnColor = colors.appGreenColor
                controller.cancelBtnColor = colors.appRedColor
                controller.strPopupImage = "ic_popupCancleOrder"
                controller.isCancleOrder = true
                controller.btnSubmit = {
                    self.webserviceGetOrderDetail(selectedOrder: "")
                }
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
            }
        })
    }
}
