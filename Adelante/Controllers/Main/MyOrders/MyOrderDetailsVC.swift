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
    lazy var skeletonViewData : SkeletonOrderDetails = SkeletonOrderDetails.fromNib()
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
//    @IBOutlet weak var viewSkeleton: skeletonView!
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonViewData.showAnimatedSkeleton()
        self.view.addSubview(skeletonViewData)
        setUpLocalizedStrings()
        webserviceOrderDetails()
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.estimatedRowHeight = 66.5
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
            lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
            lblRestName.text = objOrderDetailsData.restaurantName
            lblTotal.text = "\(CurrencySymbol)" + objOrderDetailsData.total.ConvertToTwoDecimal()
            lblAddress.text = objOrderDetailsData.address
            lblTaxes.text = "\(CurrencySymbol)" + objOrderDetailsData.tax.ConvertToTwoDecimal()
            lblServiceFee.text = "\(CurrencySymbol)" + objOrderDetailsData.serviceFee.ConvertToTwoDecimal()
            lblSubTotal.text = "\(CurrencySymbol)" + objOrderDetailsData.sub_total.ConvertToTwoDecimal()
            lblLocation.text = objOrderDetailsData.street
            let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objOrderDetailsData.qrcode ?? "")"
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
        webserviceCancelOrder()
    }
    
    @IBAction func btnRateOrderClicked(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID) as! RateReviewVC
        controller.strRestaurantId = strRestaurantId
        controller.strOrderId = orderId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnShareOrderClicked(_ sender: Any) {
        self.isSharedOrder = true
        let textToShare = [ "Order share successfully." ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
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
       
        lblServiceFeeTitle.text = "MyOrderDetailsVC_lblServiceFeeTitle".Localized()
        
        lblTaxesTitle.text = "MyOrderDetailsVC_lblTaxesTitle".Localized()
       
        lblTotalTitle.text = "MyOrderDetailsVC_lblTotalTitle".Localized()
       
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
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func webserviceCancelOrder(){
        let cancelOrder = CancelOrderReqModel()
        cancelOrder.user_id = SingletonClass.sharedInstance.UserId
        cancelOrder.main_order_id = objOrderDetailsData.item[0].mainOrderId
        WebServiceSubClass.CancelOrder(cancelOrder: cancelOrder, showHud: false, completion: { (json, status, response) in
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
        WebServiceSubClass.ShareOrder(shareOrder: shareOrder, showHud: false, completion: { (json, status, response) in
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
