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
import DropDown

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
    var arrVehicle = [Parkinglist]()
    var orderType = ""
    var strRestaurantId = ""
    var arrShareDetail = [ShareDetailsItem]()
    var objShareOrderDetails : ShareDetailsMainOrder!
    lazy var skeletonViewData : SkeletonOrderDetails = SkeletonOrderDetails.fromNib()
    var arrayForTitle : [String] = ["checkOutVC_arrayForTitle_title".Localized(),"checkOutVC_arrayForTitle_title1".Localized(),"checkOutVC_arrayForTitle_title2".Localized()]//"checkOutVC_arrayForTitle_title3".Localized()
    var isfromShare : Bool = false
    var AcceptOrder : (()->())?
    var QRCodeimage = UIImageView()
    let vehicleDropdown = DropDown()
    var parkingID = ""
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblId: orderDetailsLabel!
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var vwBarCode: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblRestName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnShareOrder: submitButton!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var vwRateOrder: UIView!
    @IBOutlet weak var vwShareOrder: UIView!
    @IBOutlet weak var heightTblItems: NSLayoutConstraint!
    @IBOutlet weak var vwAccept: UIView!
    @IBOutlet weak var btnAccept: submitButton!
    @IBOutlet weak var tblOrderDetails: UITableView!
    @IBOutlet weak var tblOrderDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSharedDetail: orderDetailsLabel!
    @IBOutlet weak var btnQRCOde: UIButton!
    @IBOutlet weak var CurbSideYesBtn: UIButton!
    @IBOutlet weak var CurbSideNoBtn: UIButton!
    @IBOutlet weak var TxtParkingNo: UITextField!
    @IBOutlet weak var LblcurbsideParkingPickup: UILabel!
    @IBOutlet weak var stackParkingList: UIStackView!
    
    
    //    @IBOutlet weak var viewSkeleton: skeletonView!
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TxtParkingNo.delegate = self
        tblOrderDetails.delegate = self
        tblOrderDetails.dataSource = self
        tblOrderDetails.reloadData()
        tblOrderDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        skeletonViewData.showAnimatedSkeleton()
        skeletonViewData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonViewData)
        vehicleDropdown.anchorView = TxtParkingNo
        
        setUpLocalizedStrings()
        if isfromShare{
            webserviceShareOrderDetails()
        }else{
            webserviceOrderDetails()
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil)
        }
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.estimatedRowHeight = 66.5
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        tblItems.reloadData()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            
            if collObj == self.tblOrderDetails{
                self.tblOrderDetailsHeight.constant = tblOrderDetails.contentSize.height
            }
        }
    }
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        if selectedSegmentTag == 0 {
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.pastOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        } else if selectedSegmentTag == 1{
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.upcomingOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        }else{
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.shareOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        }
        setUpOrderDetails()
    }
    func Dropdown(Dropdown : DropDown?, StringArray : [String], control : UIView, displayView : UIView){
        Dropdown?.anchorView = displayView
        Dropdown?.dataSource = StringArray
        Dropdown?.selectionAction = { [unowned self] (index, item) in
            print("Selected Item: \(item) at index: \(index)")
//            let index1 = Int(vehicleDropdown.selectedItem ?? "")
            self.parkingID = self.arrVehicle[index].id
            self.TxtParkingNo.text = self.vehicleDropdown.selectedItem
            self.TxtParkingNo.textColor = .black
        }
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
                lblTotal.text = CurrencySymbol + objShareOrderDetails.total
                lblRestName.text = objShareOrderDetails.restaurantName
                lblLocation.text = objShareOrderDetails.street
                lblAddress.text = objShareOrderDetails.address
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objShareOrderDetails.qrcode ?? "")"
                imgBarCode.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgBarCode.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                self.QRCodeimage.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            }
        }else{
            let arrayVehicleData:[String] = self.arrVehicle.compactMap({$0.parking_no})
//            self.vehicleDropdown.dataSource = arrayVehicleData
            Dropdown(Dropdown: vehicleDropdown, StringArray: arrayVehicleData, control: TxtParkingNo, displayView: TxtParkingNo)
            if(self.orderType == "In-Process"){
                self.vwShareOrder.isHidden = (self.objOrderDetailsData.isShare.toInt() == 0) ? true : false
                self.btnShareOrder.isHidden = (self.objOrderDetailsData.isShare.toInt() == 0) ? true : false
                //self.TxtParkingNo.inputView = vehicleDropdown
                
                if self.objOrderDetailsData.deliveryType == "1"{
                    if self.objOrderDetailsData.parking_type == "1"{
                        if self.objOrderDetailsData.parking_id == "0"{
                            stackParkingList.subviews[0].isHidden = true
                            stackParkingList.subviews[1].isHidden = false
                            stackParkingList.subviews[2].isHidden = false
//                            LblcurbsideParkingPickup.superview?.isHidden = true
                            self.CurbSideYesBtn.isSelected = true
                            self.CurbSideNoBtn.isSelected = false
                            
//                            TxtParkingNo.superview?.isHidden = !CurbSideYesBtn.isSelected
                            
                        }
                        else{
                            stackParkingList.subviews[0].isHidden = false
                            stackParkingList.subviews[1].isHidden = true
                            stackParkingList.subviews[2].isHidden = true
                            LblcurbsideParkingPickup.text = "Order Pickup from " + objOrderDetailsData.parking_no + "\nCurbside Parking"
                        }
                    }
                    else{
                        stackParkingList.subviews[0].isHidden = true
                        stackParkingList.subviews[1].isHidden = false
                        stackParkingList.subviews[2].isHidden = true
//                        LblcurbsideParkingPickup.superview?.isHidden = true
                        self.CurbSideNoBtn.isSelected = true
                        self.CurbSideYesBtn.isSelected = false
//                        TxtParkingNo.superview?.isHidden = true
                    }
                }else{
                    LblcurbsideParkingPickup.superview?.superview?.superview?.isHidden = true
                }
             
            }
            
            if(self.orderType == "past"){
                if(self.objOrderDetailsData.status == "3"){
                    self.vwShareOrder.isHidden = (self.objOrderDetailsData.isShare.toInt() == 0) ? true : false
                    self.btnShareOrder.isHidden = (self.objOrderDetailsData.isShare.toInt() == 0) ? true : false
                    self.vwCancel.isHidden = (self.objOrderDetailsData.isCancel.toInt() == 0) ? true : false
                    self.btnCancel.isHidden = (self.objOrderDetailsData.isCancel.toInt() == 0) ? true : false
                    self.vwRateOrder.isHidden = (self.objOrderDetailsData.isRate.toInt() == 0) ? true : false
                    self.btnRateOrder.isHidden = (self.objOrderDetailsData.isRate.toInt() == 0) ? true : false
                    if objOrderDetailsData.parking_no != ""{
                        self.LblcurbsideParkingPickup.text = objOrderDetailsData.parking_no
                        stackParkingList.subviews[0].isHidden = false
                        stackParkingList.subviews[1].isHidden = true
                        stackParkingList.subviews[2].isHidden = true
                    }else{
                        stackParkingList.subviews[0].isHidden = true
                        stackParkingList.subviews[1].isHidden = true
                        stackParkingList.subviews[2].isHidden = true
                    }
                }else{
                    LblcurbsideParkingPickup.superview?.superview?.superview?.isHidden = true
                }
            }
            
            if objOrderDetailsData != nil{
                lblId.text = objOrderDetailsData.orderId
                if objOrderDetailsData.itemQuantity.toInt() > 1 {
                    lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
                } else {
                    lblNoOfItems.text = objOrderDetailsData.itemQuantity + " item"
                }
                //            lblNoOfItems.text = objOrderDetailsData.itemQuantity + " items"
                lblRestName.text = objOrderDetailsData.restaurantName
                lblLocation.text = objOrderDetailsData.street
                lblAddress.text = objOrderDetailsData.address
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objOrderDetailsData.qrcode ?? "")"
                imgBarCode.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgBarCode.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                self.QRCodeimage.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                lblTotal.text = CurrencySymbol + objOrderDetailsData.total
                if objOrderDetailsData.shareFrom == ""{
                }else{
                    lblSharedDetail.isHidden = false
                    lblSharedDetail.text = "Shared from " + objOrderDetailsData.shareFrom
                }
                if objOrderDetailsData.shareTo == ""{
                }else{
                    lblSharedDetail.isHidden = false
                    lblSharedDetail.text = "Shared to " + objOrderDetailsData.shareTo
                }
                if objOrderDetailsData.trash.toInt() == 0{
                    if objOrderDetailsData.shareOrderId.toInt() != 0{
                        vwShareOrder.isHidden = true
                    }else {
                        vwShareOrder.isHidden = false
                    }
                    vwCancel.isHidden = false
                }else{
                    vwShareOrder.isHidden = true
                    vwCancel.isHidden = true
                }
            }
        }
        tblItems.reloadData()
        tblOrderDetails.reloadData()
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
        if objOrderDetailsData.trash.toInt() == 0{
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
            }
            self.present(controller, animated: true, completion: nil)
        }else{
            btnCancel.isUserInteractionEnabled = false
        }
    }
    @IBAction func btnSaveParkingClick(_ sender: UIButton) {
        if TxtParkingNo.text != ""{
            webserviceUpdateParkingDetails(parking_id: parkingID, type: "update")
        }
    }
    @IBAction func btnCancelParkingClick(_ sender: UIButton) {
        webserviceUpdateParkingDetails(parking_id: objOrderDetailsData.parking_id, type: "Cancel")
    }
    
    @IBAction func btnRateOrderClicked(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID) as! RateReviewVC
        controller.strRestaurantId = strRestaurantId
        controller.strOrderId = orderId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnQrCodeClick(_ sender: Any) {
        let controller:QRCodeVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: QRCodeVC.storyboardID) as! QRCodeVC
        controller.qrImage = self.QRCodeimage.image
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func btnShareOrderClicked(_ sender: Any) {
        if objOrderDetailsData.trash.toInt() == 0{
            if let name = URL(string: "https://www.adelantemovil.com/ShareOrder?orderid=\(orderId)"), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                appDel.shareUrl = "\(name)"
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            } else {
            }
        }else {
            btnShareOrder.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Curbside parking selected
    
    @IBAction func CurbsideParkingBtnclick(_ sender: UIButton) {
        if sender == CurbSideYesBtn{
            CurbSideYesBtn.isSelected = true
            CurbSideNoBtn.isSelected = false
            TxtParkingNo.superview?.isHidden = false
        }else{
            CurbSideYesBtn.isSelected = false
            CurbSideNoBtn.isSelected = true
            TxtParkingNo.superview?.isHidden = true
        }
        
    }
    
    
    @IBAction func btnAcceptClick(_ sender: Any) {
        
        webserviceAcceptOrder()
    }
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case tblItems:
            if isfromShare{
                return arrShareDetail.count
            }
            return arrItem.count
        case tblOrderDetails:
            if isfromShare{
                arrayForTitle.removeAll()
                arrayForTitle.append("checkOutVC_arrayForTitle_title".Localized())
                var cnt = 1
                if objShareOrderDetails?.promocodeType == "discount" || objShareOrderDetails?.promocode != ""{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title3".Localized())
                    cnt = cnt + 1
                }
                if (objShareOrderDetails?.serviceFee ?? "0") != "0"{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title1".Localized())
                    cnt = cnt + 1
                }
                if (objShareOrderDetails?.tax ?? "0") != "0"{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title2".Localized())
                    cnt = cnt + 1
                }
                return cnt
            }else{
                arrayForTitle.removeAll()
                arrayForTitle.append("checkOutVC_arrayForTitle_title".Localized())
                var cnt = 1
                if objOrderDetailsData?.promocodeType == "discount" || objOrderDetailsData?.promocode != ""{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title3".Localized())
                    cnt = cnt + 1
                }
                if (objOrderDetailsData?.serviceFee ?? "0") != "0"{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title1".Localized())
                    cnt = cnt + 1
                }
                if (objOrderDetailsData?.tax ?? "0") != "0"{
                    arrayForTitle.append("checkOutVC_arrayForTitle_title2".Localized())
                    cnt = cnt + 1
                }
                return cnt
            }
        default:
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case tblItems:
            if isfromShare{
                let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
                cell.lblItemName.text = arrShareDetail[indexPath.row].restaurantItemName
                cell.lblDateTime.text = arrShareDetail[indexPath.row].date
                cell.lblQty.text = arrShareDetail[indexPath.row].quantity
                cell.lblPrice.text = (CurrencySymbol) + arrShareDetail[indexPath.row].subTotal
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
                cell.lblItemName.text = arrItem[indexPath.row].restaurantItemName
                cell.lblDateTime.text = arrItem[indexPath.row].date
                cell.lblQty.text = arrItem[indexPath.row].quantity
                cell.lblPrice.text = (CurrencySymbol) + arrItem[indexPath.row].subTotal
                cell.selectionStyle = .none
                return cell
            }
        case tblOrderDetails:
            if isfromShare{
                let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: MyOrderTotalCell.reuseIdentifier, for: indexPath) as! MyOrderTotalCell
                switch arrayForTitle[indexPath.row] {
                case "checkOutVC_arrayForTitle_title".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objShareOrderDetails?.subTotal ?? "")"
                case "checkOutVC_arrayForTitle_title1".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objShareOrderDetails?.serviceFee ?? "")"
                case "checkOutVC_arrayForTitle_title2".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objShareOrderDetails?.totalRound ?? "")"
                case "checkOutVC_arrayForTitle_title3".Localized():
                    if objShareOrderDetails?.promocodeType == "discount"{
                        cell.lblPrice.text = "\(CurrencySymbol)\(objShareOrderDetails?.discountAmount ?? "")"
                    }else if objShareOrderDetails?.promocode != ""{
                        cell.lblPrice.text = "\(CurrencySymbol)\(objShareOrderDetails?.discountAmount ?? "")"
                    }
                default:
                    break
                }
                cell.lblTitle.text = arrayForTitle[indexPath.row]
                if cell.lblTitle.text == "checkOutVC_arrayForTitle_title2".Localized() {
                    cell.lblTitle.text = "checkOutVC_arrayForTitle_title2".Localized() + " (\(objShareOrderDetails?.tax! ?? "0")%)"
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: MyOrderTotalCell.reuseIdentifier, for: indexPath) as! MyOrderTotalCell
                switch arrayForTitle[indexPath.row] {
                case "checkOutVC_arrayForTitle_title".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objOrderDetailsData?.subTotal ?? "")"
                case "checkOutVC_arrayForTitle_title1".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objOrderDetailsData?.serviceFee ?? "")"
                case "checkOutVC_arrayForTitle_title2".Localized():
                    cell.lblPrice.text = "\(CurrencySymbol)\(objOrderDetailsData?.totalRound ?? "")"
                case "checkOutVC_arrayForTitle_title3".Localized():
                    if objOrderDetailsData?.promocodeType == "discount"{
                        cell.lblPrice.text = "\(CurrencySymbol)\(objOrderDetailsData?.discountAmount ?? "")"
                    }else if objOrderDetailsData?.promocode != ""{
                        cell.lblPrice.text = "\(CurrencySymbol)\(objOrderDetailsData?.discountAmount ?? "")"
                    }
                default:
                    break
                }
                cell.lblTitle.text = arrayForTitle[indexPath.row]
                if cell.lblTitle.text == "checkOutVC_arrayForTitle_title2".Localized() {
                    cell.lblTitle.text = "checkOutVC_arrayForTitle_title2".Localized() + " (\(objOrderDetailsData?.tax! ?? "0")%)"
                }
                cell.selectionStyle = .none
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblItems:
            return UITableView.automaticDimension
        case tblOrderDetails:
            return 43
        default:
            return 43
        }
    }
    func setUpLocalizedStrings()
    {
        lblOrderId.text = "MyOrderDetailsVC_lblOrderId".Localized()
        lblNoOfItems.text = String(format: "MyOrderDetailsVC_lblNoOfItems".Localized(), "1")
        lblRestName.text = "MyOrderDetailsVC_lblRestName".Localized()
        lblLocation.text = "MyOrderDetailsVC_lblLocation".Localized()
        lblAddress.text = "43369 Ellsworth St, remont,CA".Localized()
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
                if orderData.parkinglist.count != 0{
                    self.arrVehicle = orderData.parkinglist
                }
                self.skeletonViewData.removeFromSuperview()
                self.skeletonViewData.stopShimmering()
                self.skeletonViewData.stopSkeletonAnimation()
                self.objOrderDetailsData = orderData.data.mainOrder
                self.arrItem = self.objOrderDetailsData.item
                if self.objOrderDetailsData.trash.toInt() != 0{
                    self.vwCancel.isHidden = true
                    self.vwShareOrder.isHidden = true
                }
                self.setData()
                self.tblOrderDetails.reloadData()
                self.tblOrderDetails.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
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
    func webserviceUpdateParkingDetails(parking_id:String,type:String){
        let ParkingDetails = updateParkingDetailsReqModel()
        ParkingDetails.order_id = orderId
        ParkingDetails.parking_id = parking_id
        ParkingDetails.type = type
        WebServiceSubClass.updateParkingList(updateParkingListModel: ParkingDetails, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                self.webserviceOrderDetails()
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
                let alertController = UIAlertController(title: AppName, message: json["message"].string, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    if let click = self.AcceptOrder{
                        click()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
extension MyOrderDetailsVC : UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        TxtParkingNo.resignFirstResponder()
        vehicleDropdown.show()
        return false
    }
}
