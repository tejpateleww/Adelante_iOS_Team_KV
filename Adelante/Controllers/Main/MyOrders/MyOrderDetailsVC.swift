//
//  MyOrderDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

protocol orderCancelDelegate {
    func refreshOrderDetailsScreen()
}
class MyOrderDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var delegateCancelOrder : orderCancelDelegate!
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var isSharedOrder = false
    var orderId = ""
    var objOrderDetailsData : MainOrder!
    var arrItem = [Item]()
    var orderType = ""
    var strRestaurantId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblId: orderDetailsLabel!
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var vwBarCode: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblRestName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblYourOrder: orderDetailsLabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblServiceFeeTitle: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblTaxesTitle: UILabel!
    @IBOutlet weak var lblTaxes: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnShareOrder: submitButton!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var vwRateOrder: UIView!
    @IBOutlet weak var vwShareOrder: UIView!
    @IBOutlet weak var heightTblItems: NSLayoutConstraint!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        webserviceOrderDetails()
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.estimatedRowHeight = 66.5
        //        self.heightTblItems.constant = tblItems.contentSize.height
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        if selectedSegmentTag == 0 {
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.pastOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        } else {
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.upcomingOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        }
        setUpOrderDetails()
    }
    func setData(){
        if objOrderDetailsData != nil{
            lblId.text = objOrderDetailsData.orderId
            lblNoOfItems.text = objOrderDetailsData.itemQuantity + "items"
            lblRestName.text = objOrderDetailsData.restaurantName
            lblTotal.text = "$" + objOrderDetailsData.total
            lblAddress.text = objOrderDetailsData.address
            lblTaxes.text = "$" + objOrderDetailsData.tax
            lblServiceFee.text = "$" + objOrderDetailsData.serviceFee
            lblSubTotal.text = "$" + objOrderDetailsData.sub_total
            lblLocation.text = objOrderDetailsData.street
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(objOrderDetailsData.qrcode ?? "")"
            imgBarCode.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgBarCode.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        }
        tblItems.reloadData()
        self.heightTblItems.constant = tblItems.contentSize.height
    }
    func setUpOrderDetails() {
        if selectedSegmentTag == 0 {
            self.vwCancel.isHidden = true
            self.vwRateOrder.isHidden = false
            self.vwShareOrder.isHidden = true
            self.vwBarCode.isHidden = true
        } else {
            self.vwCancel.isHidden = false
            self.vwRateOrder.isHidden = true
            if isSharedOrder {
                self.vwShareOrder.isHidden = true
            } else {
                self.vwShareOrder.isHidden = false
            }
            self.vwBarCode.isHidden = false
        }
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.reloadData()
        self.heightTblItems.constant = tblItems.contentSize.height
    }
    
    // MARK: - IBActions
    @IBAction func btnCancelOrderClicked(_ sender: Any) {
        
        //        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "Cancel Order", strCancelButtonTitle: "", strDescription: "Do you really want to cancel the order?", strTitle: "Are you Sure?", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appRedColor, cancelBtnColor: colors.appRedColor, viewController: self)
        webserviceCancelOrder()
        //        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "Cancel Order", strCancelButtonTitle: "", strDescription: "Do you really want to cancel the order?", strTitle: "Are you Sure?", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor.value, cancelBtnColor: colors.appOrangeColor.value ,viewController: self)
    }
    
    @IBAction func btnRateOrderClicked(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID) as! RateReviewVC
        controller.strRestaurantId = strRestaurantId
        controller.strOrderId = orderId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnShareOrderClicked(_ sender: Any) {
        self.isSharedOrder = true
        let text = ""
        let textToShare = [ "Order share successfully." ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
//            switch activityType {
//            case .message:
//                self.webserviceShareOrder(strUsertype: SingletonClass.sharedInstance.LoginRegisterUpdateData?.phone)
//            case .mail :
//
//            case .
//            default:
//                break
//            }
//
//
//            if !completed {
//                // User canceled
//                return
//            }
            // User completed activity
        }
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.mail ]
        self.present(activityViewController, animated: true, completion: nil)
        
      
    }
    
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
        cell.lblItemName.text = arrItem[indexPath.row].restaurantItemName
        cell.lblDateTime.text = arrItem[indexPath.row].date
        cell.lblSharedFrom.isHidden = true
        //        if selectedSegmentTag == 1 && isSharedOrder{
        //            cell.lblSharedFrom.isHidden = false
        //            cell.lblItemName.text = arrItem[indexPath.row].restaurantItemName
        //            cell.lblDateTime.text = arrItem[indexPath.row].date
        //        } else {
        //            if indexPath.row == 1{
        //
        //                cell.lblItemName.text = arrItem[indexPath.row].restaurantItemName
        //                cell.lblDateTime.text = arrItem[indexPath.row].date
        //            }
        //        }
        cell.selectionStyle = .none
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    func setUpLocalizedStrings()
    {
        lblOrderId.text = "MyOrderDetailsVC_lblOrderId".Localized()
        lblNoOfItems.text = String(format: "MyOrderDetailsVC_lblNoOfItems".Localized(), "1")
        lblRestName.text = "MyOrderDetailsVC_lblRestName".Localized()
        lblLocation.text = "MyOrderDetailsVC_lblLocation".Localized()
        lblAddress.text = "43369 Ellsworth St, remont,CA"
        lblYourOrder.text = "MyOrderDetailsVC_lblYourOrder".Localized()
        lblSubTotalTitle.text = "MyOrderDetailsVC_lblSubTotalTitle".Localized()
        lblSubTotal.text = "$30"
        lblServiceFeeTitle.text = "MyOrderDetailsVC_lblServiceFeeTitle".Localized()
        lblServiceFee.text = "$2"
        lblTaxesTitle.text = "MyOrderDetailsVC_lblTaxesTitle".Localized()
        lblTaxes.text = "$7"
        lblTotalTitle.text = "MyOrderDetailsVC_lblTotalTitle".Localized()
        lblTotal.text = "$39"
        btnCancel.setTitle("MyOrderDetailsVC_btnCancel".Localized(), for: .normal)
        btnRateOrder.setTitle("MyOrderDetailsVC_btnRateOrder".Localized(), for: .normal)
        btnShareOrder.setTitle("MyOrderDetailsVC_btnShareOrder".Localized(), for: .normal)
    }
    // MARK: - Api Calls
    func webserviceOrderDetails(){
        let orderDetails = MyorderDetailsReqModel()
        orderDetails.order_id = orderId
        orderDetails.user_id = SingletonClass.sharedInstance.UserId
        orderDetails.type = orderType
        orderDetails.restaurant_id = strRestaurantId
        WebServiceSubClass.orderDetailList(orderDetails: orderDetails, showHud: true, completion: { (response, status, error) in
            if status{
                let orderData = MyorderDetailsResModel.init(fromJson: response)
                self.objOrderDetailsData = orderData.data.mainOrder
                self.arrItem = self.objOrderDetailsData.item
                self.setData()
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                    self.navigationController?.popViewController(animated: true)
                }, otherTitles: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func webserviceCancelOrder(){
        let cancelOrder = CancelOrderReqModel()
        cancelOrder.user_id = SingletonClass.sharedInstance.UserId
        cancelOrder.main_order_id = objOrderDetailsData.item[0].mainOrderId
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                Utilities.displayAlert(json["message"].string ?? "")
                self.delegateCancelOrder.refreshOrderDetailsScreen()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
    func webserviceShareOrder(strUsertype:String){
        let shareOrder = shareOrderReqModel()
        shareOrder.user_type = strUsertype
        shareOrder.main_order_id = objOrderDetailsData.item[0].mainOrderId
        WebServiceSubClass.ShareOrder(shareOrder: shareOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                Utilities.displayAlert(json["message"].string ?? "")
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
}
