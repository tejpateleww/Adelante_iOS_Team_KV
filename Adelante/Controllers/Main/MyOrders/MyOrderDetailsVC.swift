//
//  MyOrderDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

protocol orderCancelDelegate {
    func refreshOrderDetailsScreen()
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
class MyOrderDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var responseStatus : webserviceResponse = .initial
    var delegateCancelOrder : orderCancelDelegate!
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var isSharedOrder = false
    var orderId = ""
    var objOrderDetailsData : MainOrder!
    var arrItem = [Item]()
    var orderType = ""
    var strRestaurantId = ""
    var arrShareDetail = [ShareDetailsItem]()
    var objShareOrderDetails : ShareDetailsMainOrder!
    lazy var skeletonViewData : SkeletonOrderDetails = SkeletonOrderDetails.fromNib()
    var isfromShare : Bool = false
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
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var vwAccept: UIView!
    @IBOutlet weak var btnAccept: submitButton!
    //    @IBOutlet weak var viewSkeleton: skeletonView!
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonViewData.showAnimatedSkeleton()
        skeletonViewData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonViewData)
        setUpLocalizedStrings()
        if isfromShare{
            webserviceShareOrderDetails()
        }else{
            webserviceOrderDetails()
        }
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.estimatedRowHeight = 66.5
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        tblItems.reloadData()
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
        if isfromShare{
            if objShareOrderDetails != nil{
                lblId.text = objShareOrderDetails.orderId
                if objShareOrderDetails.itemQuantity.toInt() > 1 {
                    lblNoOfItems.text = objShareOrderDetails.itemQuantity + " items"
                } else {
                    lblNoOfItems.text = objShareOrderDetails.itemQuantity + " item"
                }
                //            lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
                lblRestName.text = objShareOrderDetails.restaurantName
                lblTotal.text = "\(CurrencySymbol)" + objShareOrderDetails.total.ConvertToTwoDecimal()
                lblTax.text = "(" + objShareOrderDetails.tax + "%" + ")"
                lblAddress.text = objShareOrderDetails.address
                lblTaxes.text = "\(CurrencySymbol)" + objShareOrderDetails.totalRound.ConvertToTwoDecimal()
                lblServiceFee.text = "\(CurrencySymbol)" + objShareOrderDetails.serviceFee.ConvertToTwoDecimal()
                lblSubTotal.text = "\(CurrencySymbol)" + objShareOrderDetails.subTotal.ConvertToTwoDecimal()
                lblLocation.text = objShareOrderDetails.street
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objShareOrderDetails.qrcode ?? "")"
                imgBarCode.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgBarCode.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            }
        }else{
            if objOrderDetailsData != nil{
                lblId.text = objOrderDetailsData.orderId
                if objOrderDetailsData.itemQuantity.toInt() > 1 {
                    lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
                } else {
                    lblNoOfItems.text = objOrderDetailsData.itemQuantity + " item"
                }
                //            lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
                lblRestName.text = objOrderDetailsData.restaurantName
                lblTotal.text = "\(CurrencySymbol)" + objOrderDetailsData.total.ConvertToTwoDecimal()
                lblTax.text = "(" + objOrderDetailsData.tax + "%" + ")"
                lblAddress.text = objOrderDetailsData.address
                lblTaxes.text = "\(CurrencySymbol)" + objOrderDetailsData.totalRound.ConvertToTwoDecimal()
                lblServiceFee.text = "\(CurrencySymbol)" + objOrderDetailsData.serviceFee.ConvertToTwoDecimal()
                lblSubTotal.text = "\(CurrencySymbol)" + objOrderDetailsData.subTotal.ConvertToTwoDecimal()
                lblLocation.text = objOrderDetailsData.street
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objOrderDetailsData.qrcode ?? "")"
                imgBarCode.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgBarCode.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            }
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
            self.vwAccept.isHidden = true
        } else if selectedSegmentTag == 1{
            self.vwCancel.isHidden = false
            self.vwRateOrder.isHidden = true
            if isSharedOrder {
                self.vwShareOrder.isHidden = true
            } else {
                self.vwShareOrder.isHidden = false
            }
            self.vwAccept.isHidden = true
            self.vwBarCode.isHidden = false
        }else{
            self.vwCancel.isHidden = true
            self.vwRateOrder.isHidden = true
            self.vwShareOrder.isHidden = true
            self.vwBarCode.isHidden = false
            self.vwAccept.isHidden = false
        }
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.reloadData()
        self.heightTblItems.constant = tblItems.contentSize.height
    }
    
    // MARK: - IBActions
    @IBAction func btnCancelOrderClicked(_ sender: Any) {
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
            self.webserviceCancelOrder()
            //                            dismiss(animated: , completion: nil)
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnRateOrderClicked(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID) as! RateReviewVC
        controller.strRestaurantId = strRestaurantId
        controller.strOrderId = orderId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnShareOrderClicked(_ sender: Any) {
        webserviceShareOrder()
    }
    
    @IBAction func btnAcceptClick(_ sender: Any) {
        webserviceAcceptOrder()
    }
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isfromShare{
            return arrShareDetail.count
        }
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isfromShare{
            let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
            cell.lblItemName.text = arrShareDetail[indexPath.row].restaurantItemName
            cell.lblDateTime.text = arrShareDetail[indexPath.row].date
            cell.lblQty.text = arrShareDetail[indexPath.row].quantity
            cell.lblPrice.text = (CurrencySymbol) + arrShareDetail[indexPath.row].subTotal
            cell.lblSharedFrom.isHidden = true
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
            cell.lblItemName.text = arrItem[indexPath.row].restaurantItemName
            cell.lblDateTime.text = arrItem[indexPath.row].date
            cell.lblQty.text = arrItem[indexPath.row].quantity
            cell.lblPrice.text = (CurrencySymbol) + arrItem[indexPath.row].subTotal
            cell.lblSharedFrom.isHidden = true
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func setUpLocalizedStrings()
    {
        lblOrderId.text = "MyOrderDetailsVC_lblOrderId".Localized()
        lblNoOfItems.text = String(format: "MyOrderDetailsVC_lblNoOfItems".Localized(), "1")
        lblRestName.text = "MyOrderDetailsVC_lblRestName".Localized()
        lblLocation.text = "MyOrderDetailsVC_lblLocation".Localized()
        lblAddress.text = "43369 Ellsworth St, remont,CA"
        lblYourOrder.text = "MyOrderDetailsVC_lblYourOrder".Localized()
        lblSubTotalTitle.text = "MyOrderDetailsVC_lblSubTotalTitle".Localized()
        lblServiceFeeTitle.text = "MyOrderDetailsVC_lblServiceFeeTitle".Localized()
        lblTaxesTitle.text = "MyOrderDetailsVC_lblTaxesTitle".Localized()
        lblTotalTitle.text = "MyOrderDetailsVC_lblTotalTitle".Localized()
        btnCancel.setTitle("MyOrderDetailsVC_btnCancel".Localized(), for: .normal)
        btnRateOrder.setTitle("MyOrderDetailsVC_btnRateOrder".Localized(), for: .normal)
        btnShareOrder.setTitle("MyOrderDetailsVC_btnShareOrder".Localized(), for: .normal)
        btnAccept.setTitle("MyOrderDetailsVC_btnAcceptOrder".Localized(), for: .normal)
    }
    // MARK: - Api Calls
    func webserviceOrderDetails(){
        let orderDetails = MyorderDetailsReqModel()
        orderDetails.order_id = orderId
        orderDetails.user_id = SingletonClass.sharedInstance.UserId
        orderDetails.type = orderType
        orderDetails.restaurant_id = strRestaurantId
        responseStatus = .gotData
        WebServiceSubClass.orderDetailList(orderDetails: orderDetails, showHud: false, completion: { (response, status, error) in
            if status{
                let orderData = MyorderDetailsResModel.init(fromJson: response)
                self.skeletonViewData.removeFromSuperview()
                self.skeletonViewData.stopShimmering()
                self.skeletonViewData.stopSkeletonAnimation()
                self.objOrderDetailsData = orderData.data.mainOrder
                self.arrItem = self.objOrderDetailsData.item
                self.setData()
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                    self.navigationController?.popViewController(animated: true)
                }, otherTitles: nil)
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func webserviceShareOrderDetails(){
        let orderDetails = shareorderDetailsReqModel()
        orderDetails.order_id = orderId
        orderDetails.user_id = SingletonClass.sharedInstance.UserId
        responseStatus = .gotData
        WebServiceSubClass.shareorderDetailList(orderDetails: orderDetails, showHud: false, completion: { (response, status, error) in
            if status{
                let orderData = shareDetailsResModel.init(fromJson: response)
                self.skeletonViewData.removeFromSuperview()
                self.skeletonViewData.stopShimmering()
                self.skeletonViewData.stopSkeletonAnimation()
                self.objShareOrderDetails = orderData.data.mainOrder
                self.arrShareDetail = self.objShareOrderDetails.item
                self.setData()
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                    self.navigationController?.popViewController(animated: true)
                }, otherTitles: nil)
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func webserviceCancelOrder(){
        let cancelOrder = CancelOrderReqModel()
        cancelOrder.user_id = SingletonClass.sharedInstance.UserId
        cancelOrder.main_order_id = orderId
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                self.delegateCancelOrder.refreshOrderDetailsScreen()
                self.navigationController?.popViewController(animated: true)
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
    func webserviceAcceptOrder(){
        let acceptOrder = AcceptOrderReqModel()
        acceptOrder.user_id = SingletonClass.sharedInstance.UserId
        acceptOrder.main_order_id = orderId
        WebServiceSubClass.AcceptOrder(AcceptOrder: acceptOrder, showHud: false, completion: { (json, status, response) in
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
    func webserviceShareOrder(){
        let shareOrder = shareOrderReqModel()
        shareOrder.user_type = SingletonClass.sharedInstance.LoginRegisterUpdateData?.email ?? ""
        shareOrder.main_order_id = orderId
        WebServiceSubClass.ShareOrder(shareOrder: shareOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                self.isSharedOrder = true
                let textToShare = [ "Order share successfully." ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                }
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.mail ]
                self.present(activityViewController, animated: true, completion: nil)
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
