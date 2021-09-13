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
    var strOrderId = ""
    var arrShareList = [ShareOrderListDatum]()
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
        if let _ = SingletonClass.sharedInstance.selectInProcessInMyOrder{
            self.segment.setIndex(1)
            self.selectedSegmentTag = 1
            self.segmentControlChanged(self.segment)
        }
        self.webserviceGetOrderDetail(selectedOrder: self.selectedSegmentTag == 0 ? "past" : self.selectedSegmentTag == 1 ? "In-Process" : "share")
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
    }
    @objc func refreshData(){
        responseStatus = .initial
        tblOrders.reloadData()
        self.webserviceGetOrderDetail(selectedOrder: self.selectedSegmentTag == 0 ? "past" : self.selectedSegmentTag == 1 ? "In-Process" : "share")
    }
    // MARK: - IBActions
    
    @IBAction func segmentControlChanged(_ sender: BetterSegmentedControl) {
        SingletonClass.sharedInstance.selectInProcessInMyOrder = nil
        selectedSegmentTag = sender.index
        if selectedSegmentTag == 0{
            if self.arrPastList.count == 0{
                webserviceGetOrderDetail(selectedOrder:  "past" )
            }
        }else if selectedSegmentTag == 1{
            if self.arrInProcessList.count == 0 {
                webserviceGetOrderDetail(selectedOrder:  "In-Process")
            }
        }else{
            webserviceShareList()
        }
        self.tblOrders.reloadData()
    }
    // MARK: - SkeletonTableview Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if selectedSegmentTag == 0  {
            return self.responseStatus == .gotData ? (self.arrPastList.count > 0 ? MyOrdersCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
        }else if selectedSegmentTag == 1{
            return self.responseStatus == .gotData ? (self.arrInProcessList.count > 0 ? MyOrdersCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
        }else{
            return self.responseStatus == .gotData ? (self.arrShareList.count > 0 ? MyOrdersCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
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
                    return self.arrPastList.count
                }else{
                    return 1
                }
            }else{
                return 5
            }
        } else if selectedSegmentTag == 1{
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
                    return self.arrInProcessList.count
                }else{
                    return 1
                }
            }else{
                return 5
            }
        }else{
            if responseStatus == .gotData{
                if arrShareList.count != 0 {
                    return self.arrShareList.count
                }else{
                    return 1
                }
            }else{
                return 5
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedSegmentTag == 0  {
            if responseStatus == .gotData{
                if arrPastList.count != 0 {
                    let cell = tblOrders.dequeueReusableCell(withIdentifier: MyOrdersCell.reuseIdentifier, for: indexPath) as! MyOrdersCell
                    if selectedSegmentTag == 0 {
                        if arrPastList[indexPath.row].trash == "1"{
                            cell.vwShare.isHidden = true
                            cell.vwCancelOrder.isHidden = false
                            cell.vwRepeatOrder.isHidden = true
                            cell.vwAccept.isHidden = true
                            cell.btnCancelOrder.setTitle("MyOrderVC_MyOrdersCess_lblCancelOrder".Localized(), for: .normal)
                            cell.btnCancelOrder.isUserInteractionEnabled = false
                            cell.btnCancelOrder.setTitleColor(UIColor.red, for: .normal)
                        }else{
                            cell.vwShare.isHidden = true
                            cell.vwCancelOrder.isHidden = true
                            cell.vwRepeatOrder.isHidden = false
                            cell.vwAccept.isHidden = true
                        }
                    } else if selectedSegmentTag == 1{
                        cell.btnCancelOrder.setTitle("MyOrderVC_MyOrdersCess_btnCancelOrder".Localized(), for: .normal)
                        cell.btnCancelOrder.isUserInteractionEnabled = false
                        cell.btnCancelOrder.setTitleColor(UIColor.red, for: .normal)
                        cell.vwShare.isHidden = false
                        cell.vwCancelOrder.isHidden = false
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = true
                    }else{
                        cell.vwShare.isHidden = true
                        cell.vwCancelOrder.isHidden = true
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = false
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
                    cell.share = {
                        if let name = URL(string:"https://www.adelantemovil.com/admin/item/view?itemid=\(obj.id ?? "")"){
                            //URL(string: "https://www.adelantemovil.com/home?user_id=\(SingletonClass.sharedInstance.UserId)&order_id=\(obj.id ?? "")"), !name.absoluteString.isEmpty {
                          let objectsToShare = [name]
                          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                          self.present(activityVC, animated: true, completion: nil)
                        } else {
                          // show alert for not available
                        }
                    }
                    cell.Repeat = {
                        
                        self.webserviceRepeatOrder(strMainOrderId: obj.id, row: indexPath.row)
                    }
                    strOrderId = obj.id
                    
                    cell.cancel = {
                        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                        //controller.modalPresentationStyle = .fullScreen
                        controller.isHideCancelButton = true
                        controller.isHideSubmitButton = false
                        controller.submitBtnTitle = "Cancel Order       "
                        controller.cancelBtnTitle = ""
                        controller.strDescription = "Do you really want  to cancel the order."
                        controller.strPopupTitle = "Are you Sure?"
                        controller.submitBtnColor = colors.appRedColor
                        controller.cancelBtnColor = colors.appGreenColor
                        controller.strPopupImage = "ic_popupCancleOrder"
                        controller.isCancleOrder = true
                        controller.btnSubmit = {
                            controller.dismiss(animated: true, completion: nil)
                            self.webserviceCancelOrder {
                            }
                        }
                        self.present(controller, animated: true, completion: nil)
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
        } else if selectedSegmentTag == 1 {
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
                    let cell = tblOrders.dequeueReusableCell(withIdentifier: MyOrdersCell.reuseIdentifier, for: indexPath) as! MyOrdersCell
                    if selectedSegmentTag == 0 {
                        cell.vwShare.isHidden = true
                        cell.vwCancelOrder.isHidden = true
                        cell.vwRepeatOrder.isHidden = false
                        cell.vwAccept.isHidden = true
                    } else if selectedSegmentTag == 1{
                        cell.btnCancelOrder.setTitle("MyOrderVC_MyOrdersCess_btnCancelOrder".Localized(), for: .normal)
                        cell.btnCancelOrder.isUserInteractionEnabled = false
                        cell.btnCancelOrder.setTitleColor(UIColor.red, for: .normal)
                        cell.vwShare.isHidden = false
                        cell.vwCancelOrder.isHidden = false
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = true
                    }else{
                        cell.vwShare.isHidden = true
                        cell.vwCancelOrder.isHidden = true
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = false
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
                    cell.share = {
//                        if let https://www.adelantemovil.com
                        if let name = URL(string:"https://www.adelantemovil.com/admin/item/view?itemid=\(obj.id ?? "")"), !name.absoluteString.isEmpty {
                          let objectsToShare = [name]
                          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                          self.present(activityVC, animated: true, completion: nil)
                        } else {
                          // show alert for not available
                        }
                    }
                    cell.Repeat = {
                        self.webserviceRepeatOrder(strMainOrderId: obj.id, row: indexPath.row)
                    }
                    strOrderId = obj.id
                    
                    cell.cancel = {
                        
                        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                        //controller.modalPresentationStyle = .fullScreen
                        controller.isHideCancelButton = true
                        controller.isHideSubmitButton = false
                        controller.submitBtnTitle = "Cancel Order       "
                        controller.cancelBtnTitle = ""
                        controller.strDescription = "Do you really want  to cancel the order."
                        controller.strPopupTitle = "Are you Sure?"
                        controller.submitBtnColor = colors.appRedColor
                        controller.cancelBtnColor = colors.appGreenColor
                        controller.strPopupImage = "ic_popupCancleOrder"
                        controller.isCancleOrder = true
                        controller.btnSubmit = {
                            controller.dismiss(animated: true, completion: nil)
                            self.webserviceCancelOrder {
                            }
                        }
                        self.present(controller, animated: true, completion: nil)
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
        }else{
            if responseStatus == .gotData{
                if arrShareList.count != 0 {
                    let cell = tblOrders.dequeueReusableCell(withIdentifier: MyOrdersCell.reuseIdentifier, for: indexPath) as! MyOrdersCell
                    if selectedSegmentTag == 0 {
                        cell.vwShare.isHidden = true
                        cell.vwCancelOrder.isHidden = true
                        cell.vwRepeatOrder.isHidden = false
                        cell.vwAccept.isHidden = true
                    } else if selectedSegmentTag == 1{
                        cell.btnCancelOrder.setTitle("MyOrderVC_MyOrdersCess_btnCancelOrder".Localized(), for: .normal)
                        cell.btnCancelOrder.isUserInteractionEnabled = false
                        cell.btnCancelOrder.setTitleColor(UIColor.red, for: .normal)
                        cell.vwShare.isHidden = false
                        cell.vwCancelOrder.isHidden = false
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = true
                    }else{
                        cell.vwShare.isHidden = true
                        cell.vwCancelOrder.isHidden = true
                        cell.vwRepeatOrder.isHidden = true
                        cell.vwAccept.isHidden = false
                    }
                    
                    let obj = arrShareList[indexPath.row]
                    cell.lblRestName.text = obj.restaurantName
                    cell.lblRestLocation.text = obj.street
                    cell.lblPrice.text = "\(CurrencySymbol)" + obj.total.ConvertToTwoDecimal()
                    cell.lblItem.text = obj.restaurantItemName
                    cell.lblDtTime.text = obj.date
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(obj.image ?? "")"
                    cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.share = {
                        if let name = URL(string:"https://www.adelantemovil.com/admin/item/view?itemid=\(obj.id ?? "")"), !name.absoluteString.isEmpty {
                          let objectsToShare = [name]
                          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                          self.present(activityVC, animated: true, completion: nil)
                        } else {
                          // show alert for not available
                        }
                    }
                    cell.Repeat = {
                        self.webserviceRepeatOrder(strMainOrderId: obj.id, row: indexPath.row)
                    }
                    cell.accept = {
                        self.webserviceAcceptOrder(strMainOrderId: obj.id)
                    }
                    strOrderId = obj.id
                    
                    cell.cancel = {
                        
                        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                        //controller.modalPresentationStyle = .fullScreen
                        controller.isHideCancelButton = true
                        controller.isHideSubmitButton = false
                        controller.submitBtnTitle = "Cancel Order       "
                        controller.cancelBtnTitle = ""
                        controller.strDescription = "Do you really want  to cancel the order."
                        controller.strPopupTitle = "Are you Sure?"
                        controller.submitBtnColor = colors.appRedColor
                        controller.cancelBtnColor = colors.appGreenColor
                        controller.strPopupImage = "ic_popupCancleOrder"
                        controller.isCancleOrder = true
                        controller.btnSubmit = {
                            controller.dismiss(animated: true, completion: nil)
                            self.webserviceCancelOrder {
                            }
                        }
                        self.present(controller, animated: true, completion: nil)
                    }
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let NoDatacell = tblOrders.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    
                    NoDatacell.imgNoData.image = UIImage(named: "Orders")
                    NoDatacell.lblNoDataTitle.isHidden = true
                    NoDatacell.selectionStyle = .none
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
        } else if selectedSegmentTag == 1 {
            if responseStatus == .gotData{
                if arrInProcessList.count != 0 {
                    return UITableView.automaticDimension
                }else{
                    return tableView.frame.height
                }
            }else {
                return self.responseStatus == .gotData ?  230 : 131
            }
        }else{
            if responseStatus == .gotData{
                if arrShareList.count != 0 {
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
                orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : selectedSegmentTag == 1 ? "In-Process" : "Share"
                orderDetailsVC.strRestaurantId = obj.restaurantId
                orderDetailsVC.delegateCancelOrder = self
                self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                
            }
        } else if selectedSegmentTag == 1{
            if self.arrInProcessList.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                let obj = self.arrInProcessList[indexPath.row]
                orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                orderDetailsVC.orderId = obj.id
                orderDetailsVC.orderType = selectedSegmentTag == 0 ? "past" : selectedSegmentTag == 1 ? "In-Process" : "Share"
                orderDetailsVC.strRestaurantId = obj.restaurantId
                orderDetailsVC.delegateCancelOrder = self
                self.navigationController?.pushViewController(orderDetailsVC, animated: true)
                
            }
        }else{
            if self.arrShareList.count != 0 {
                let orderDetailsVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrderDetailsVC.storyboardID) as! MyOrderDetailsVC
                let obj = self.arrShareList[indexPath.row]
                orderDetailsVC.selectedSegmentTag = self.selectedSegmentTag
                orderDetailsVC.orderId = obj.id
                orderDetailsVC.isfromShare = true
                orderDetailsVC.strRestaurantId = obj.restaurantId
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
                    
                } else if self.selectedSegmentTag == 1{
                    self.arrInProcessList = OrderList
                    
                }else{
                    self.webserviceShareList()
                }
                self.tblOrders.dataSource = self
                self.tblOrders.isScrollEnabled = true
                self.tblOrders.isUserInteractionEnabled = true
                self.tblOrders.reloadData()
                
            }else{
                
                if(response["data"] != nil)
                {
                    if self.selectedSegmentTag == 0 {
                        self.arrPastList.removeAll()
                        self.tblOrders.reloadData()
                    } else if self.selectedSegmentTag == 1{
                        self.arrInProcessList.removeAll()
                        self.tblOrders.reloadData()
                    } else{
                        self.webserviceShareList()
                    }
                    
                }
                else
                {
                    if let strMessage = response["message"].string {
                        Utilities.displayAlert(strMessage)
                    }else {
                        Utilities.displayAlert("Something went wrong")
                    }
                }
            }
            
        })
    }
    func webserviceShareList(){
        let shareList = shareOrderlistReqModel()
        shareList.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.shareOrderList(shareOrderListModel: shareList, showHud: false, completion: { (response, status, error) in
            self.responseStatus = .gotData
            if status{
                let ResModel = shareOrderListResModel.init(fromJson: response)
                let cell = self.tblOrders.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
                cell.stopShimmering()
                self.tblOrders.stopSkeletonAnimation()
                self.arrShareList = ResModel.data
                self.tblOrders.dataSource = self
                self.tblOrders.isScrollEnabled = true
                self.tblOrders.isUserInteractionEnabled = true
                self.tblOrders.reloadData()
            }else{
                if(response["data"] != nil){
                    self.arrShareList.removeAll()
                    self.tblOrders.reloadData()
                }else{
                    if let strMessage = response["message"].string {
                        Utilities.displayAlert(strMessage)
                    }else {
                        Utilities.displayAlert("Something went wrong")
                    }
                }
            }
        })
    }
    func refreshOrderDetailsScreen() {
        self.webserviceGetOrderDetail(selectedOrder: self.selectedSegmentTag == 0 ? "past" : self.selectedSegmentTag == 1 ? "In-Process" : "share")
    }
    func webserviceCancelOrder(completion: @escaping () -> ()){
        
        let cancelOrder = CancelOrderReqModel()
        cancelOrder.user_id = SingletonClass.sharedInstance.UserId
        cancelOrder.main_order_id = strOrderId
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                self.webserviceGetOrderDetail(selectedOrder: self.selectedSegmentTag == 0 ? "past" : self.selectedSegmentTag == 1 ? "In-Process" : "share")
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
            completion()
        })
    }
    func webserviceShareOrder(strMainOrderId:String){
        let shareOrder = shareOrderReqModel()
        shareOrder.user_type = SingletonClass.sharedInstance.LoginRegisterUpdateData?.email ?? ""
        shareOrder.main_order_id = strMainOrderId
        WebServiceSubClass.ShareOrder(shareOrder: shareOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func webserviceAcceptOrder(strMainOrderId:String){
        let acceptOrder = AcceptOrderReqModel()
        acceptOrder.user_id = SingletonClass.sharedInstance.UserId
        acceptOrder.main_order_id = strMainOrderId
        WebServiceSubClass.AcceptOrder(AcceptOrder: acceptOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                Utilities.displayAlert(json["message"].stringValue)
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func webserviceRepeatOrder(strMainOrderId:String,row:Int){
        let repeatOrder = RepeatOrderReqModel()
        repeatOrder.user_id = SingletonClass.sharedInstance.UserId
        repeatOrder.main_order_id = strMainOrderId
        WebServiceSubClass.RepeatOrder(repeatOrder: repeatOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                let repeatOrderData = repeatOrderResModel.init(fromJson: json)
                let index = IndexPath(row: row, section: 0)
                let alert = UIAlertController(title: AppName, message: json["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                if repeatOrderData.cartId > 0{
                    let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "checkOutVC") as! checkOutVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    alert.addAction(OkAction)
                    appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }else{
                    let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "RestaurantDetailsVC") as! RestaurantDetailsVC
                        vc.selectedRestaurantId = self.arrPastList[index.row].restaurantId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    alert.addAction(OkAction)
                    appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
}
