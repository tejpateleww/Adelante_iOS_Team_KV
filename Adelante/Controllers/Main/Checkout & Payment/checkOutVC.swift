//
//  checkOutVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import GooglePlaces
import GoogleMaps

class checkOutVC: BaseViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var TotalTaxAmount = ""
    var AppliedPromocode : ApplyPromoDatum?
    var customTabBarController: CustomTabBarVC?
    //    var objCurrentorder : currentOrder?
    var strOrderId = ""
    var arrayForTitle : [String] = ["checkOutVC_arrayForTitle_title".Localized(),"checkOutVC_arrayForTitle_title1".Localized(),"checkOutVC_arrayForTitle_title2".Localized(),"".Localized()]
    let MapViewForShowRastaurantLocation = MKMapView()
    lazy var skeletonData : skeletonCheckout = skeletonCheckout.fromNib()
    
    var cartDetails : CartDatum?
    var arritem = [String]()
    var arrCartItem = [CartItem]()
    var addRemoveItem : ((Int,Int)->())?
    let activityView = UIActivityIndicatorView(style: .gray)
    var strCartId = ""
    var SettingsData : SettingsResModel!
    var locationManager = CLLocationManager()
    var IsClosed:Bool = false
//    var locationManager : LocationService?
    // MARK: - IBOutlets
    @IBOutlet weak var tblAddedProduct: UITableView!
    @IBOutlet weak var tblOrderDetails: UITableView!
    @IBOutlet weak var restaurantLocationView: GMSMapView!
    @IBOutlet weak var tblOrderDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCanclePromoCOde: myOrdersBtn!
    @IBOutlet weak var lblPromoCode: CheckOutLabel!
    @IBOutlet weak var tblAddProductHeight: NSLayoutConstraint!
    @IBOutlet weak var vwChangeLocOptions: UIView!
    @IBOutlet weak var lblItemName: CheckOutLabel!
    @IBOutlet weak var lblAddress: CheckOutLabel!
    @IBOutlet weak var btnChangeLocation: checkoutButton!
    @IBOutlet weak var btnChangeRestaurant: checkoutButton!
    @IBOutlet weak var btnAppyPromoCode: checkoutButton!
    @IBOutlet weak var lblYourOrder: CheckOutLabel!
    @IBOutlet weak var btnSeeMenu: checkoutButton!
    @IBOutlet weak var lblTotal: CheckOutLabel!
    @IBOutlet weak var LblTotlaPrice: CheckOutLabel!
    @IBOutlet weak var lblCancellation: CheckOutLabel!
    @IBOutlet weak var btnReadPOlicy: checkoutButton!
    @IBOutlet weak var btnAddFoodlist: checkoutButton!
    @IBOutlet weak var btnChange: checkoutButton!
    @IBOutlet weak var btnPlaceOrder: submitButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var viewCurbSide: UIView!
    
    // MARK: - ViewController Lifecycle
    
    @objc func ApplyPromocode() {
        
        if AppliedPromocode != nil {
            btnAppyPromoCode.isHidden = true
            
            lblPromoCode.isHidden = false
            lblPromoCode.text = AppliedPromocode?.name
            btnChange.isHidden = false
            btnCanclePromoCOde.isHidden = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantLocationView.layer.cornerRadius = 7
        restaurantLocationView.clipsToBounds = true
        skeletonData.showAnimatedSkeleton()
        skeletonData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonData)
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.checkOutVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ApplyPromocode), name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil)
//        location()
        webserviceGetCartDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.skeletonData.removeFromSuperview()
        self.skeletonData.stopShimmering()
        self.skeletonData.stopSkeletonAnimation()
    }
    // MARK: - Other Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblOrderDetails.layer.removeAllAnimations()
        tblOrderDetailsHeight.constant = tblOrderDetails.contentSize.height
        
        tblAddedProduct.layer.removeAllAnimations()
        tblAddProductHeight.constant = tblAddedProduct.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    func centerMapOnLocation(location: CLLocation, mapView: MKMapView) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        DispatchQueue.main.async {
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    func addMapView()
    {
        MapViewForShowRastaurantLocation.frame = CGRect(x: 0, y: 0, width: restaurantLocationView.frame.size.width, height: restaurantLocationView.frame.size.height)
        restaurantLocationView.addSubview(MapViewForShowRastaurantLocation)
    }
    func setData(){
        lblItemName.text = cartDetails?.name//objCurrentorder?.currentRestaurantDetail.name
        centerMapOnLocation(location: CLLocation(latitude: Double(cartDetails?.lat ?? "") ?? 0.0, longitude: Double(cartDetails?.lng ?? "") ?? 0.0), mapView: MapViewForShowRastaurantLocation)
        lblAddress.text = cartDetails?.address
        LblTotlaPrice.text = "\(CurrencySymbol)\(cartDetails?.grandTotal ?? "")"
        self.IsClosed = cartDetails?.is_close == "1"
        tblAddedProduct.delegate = self
        tblOrderDetails.delegate = self
        tblAddedProduct.dataSource = self
        tblOrderDetails.dataSource = self
        tblOrderDetails.reloadData()
        self.strCartId = cartDetails?.cartId ?? ""
        reloadAddproductTableAndResize()
        tblAddProductHeight.constant = 0
        tblOrderDetailsHeight.constant = 0
        if cartDetails?.promocode != ""{
            btnAppyPromoCode.isHidden = true
            lblPromoCode.isHidden = false
            lblPromoCode.text = cartDetails?.promocode
            btnCanclePromoCOde.isHidden = false
            btnChange.isHidden = false
        }
        else{
            btnAppyPromoCode.isHidden = false
            lblPromoCode.isHidden = true
            lblPromoCode.text = ""
            btnChange.isHidden = true
            btnCanclePromoCOde.isHidden = true
        }
    }
    
    func reloadAddproductTableAndResize(){
        tblAddedProduct.reloadData()
    }
    
    func setUpLocalizedStrings()
    {
        lblAddress.text = "43369 Ellgworthg St, remont,CA 43369 Ellgworthg St, remont,CA 43369 Ellgworthg St, remont,CA"
        btnChangeLocation.setTitle("checkOutVC_btnChangeLocation".Localized(), for: .normal)
        btnChangeRestaurant.setTitle("checkOutVC_btnChangeRestaurant".Localized(), for: .normal)
        btnAppyPromoCode.setTitle("checkOutVC_btnAppyPromoCode".Localized(), for: .normal)
        lblYourOrder.text = "checkOutVC_lblYourOrder".Localized()
        btnSeeMenu.setTitle("checkOutVC_btnSeeMenu".Localized(), for: .normal)
        
        lblCancellation.text = "checkOutVC_lblCancellation".Localized()
        btnReadPOlicy.setTitle("checkOutVC_btnReadPOlicy".Localized(), for: .normal)
        btnAddFoodlist.setTitle("checkOutVC_btnAddFoodlist".Localized(), for: .normal)
        btnPlaceOrder.setTitle("checkOutVC_btnPlaceOrder".Localized(), for: .normal)
        btnCanclePromoCOde.setTitle("checkOutVC_btnCanclePromoCOde".Localized(), for: .normal)
        btnChange.setTitle("checkOutVC_btnChangePromoCOde".Localized(), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case tblAddedProduct:
            return self.arrCartItem.count
        case tblOrderDetails:
            arrayForTitle.removeAll()
            arrayForTitle.append("checkOutVC_arrayForTitle_title".Localized())
            var cnt = 1
            if cartDetails?.promocodeType == "discount" || cartDetails?.promocodeType == "flat" {
                arrayForTitle.append("checkOutVC_arrayForTitle_title3".Localized())//+ "( \(cartDetails?.discount ?? ""))")
                cnt = cnt + 1
            }
            if (cartDetails?.serviceFee ?? "0") != "0"{
                arrayForTitle.append("checkOutVC_arrayForTitle_title1".Localized())
                cnt = cnt + 1
            }
            if (cartDetails?.tax ?? "0") != "0"{
                arrayForTitle.append("checkOutVC_arrayForTitle_title2".Localized())
                cnt = cnt + 1
            }
            return cnt
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tblAddedProduct:
            
            let cell = tblAddedProduct.dequeueReusableCell(withIdentifier: addedProductCell.reuseIdentifier, for: indexPath) as! addedProductCell
            let objitem = arrCartItem[indexPath.row]
            cell.lblItem.text = objitem.itemName
            cell.lblDisc.text = objitem.descriptionField
            cell.lblPrice.text = "\(CurrencySymbol)\(objitem.subTotal ?? 0)"
            cell.lbltotalCount.text = objitem.cartQty
            cell.stackHide.isHidden = false
            
            cell.decreaseClick = {
                self.webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "0")
                cell.stackHide.isHidden = true
                cell.vwStapper.isHidden = false
                self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2, y: cell.vwStapper.frame.height/2)
                cell.vwStapper.addSubview(self.activityView)
                self.activityView.startAnimating()
            }
            
            cell.increaseClick = { [self] in
                let value : Int = (cell.lbltotalCount.text! as NSString).integerValue
//                if objitem.quantity.toInt() > value {
                    webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "1")
                    cell.stackHide.isHidden = true
                    cell.vwStapper.isHidden = false
                    self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2, y: cell.vwStapper.frame.height/2)
                    cell.vwStapper.addSubview(self.activityView)
                    self.activityView.startAnimating()
//                }else{
//                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(objitem.itemName ?? "")",objitem.quantity]), vc: self)
//                }
            }
            
            cell.selectionStyle = .none
            return cell
            
        case tblOrderDetails:
            
            let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: orderDetailsCell.reuseIdentifier, for: indexPath) as! orderDetailsCell
            cell.lblTitle.text = arrayForTitle[indexPath.row]
            if cell.lblTitle.text == "checkOutVC_arrayForTitle_title2".Localized() {
                cell.lblTitle.text = "checkOutVC_arrayForTitle_title2".Localized() + " (\(cartDetails?.tax! ?? "0")%)"
            }
            switch arrayForTitle[indexPath.row] {
            case "checkOutVC_arrayForTitle_title".Localized():
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.oldTotal ?? "")"
            case "checkOutVC_arrayForTitle_title1".Localized():
                cell.lblTitle.text = "checkOutVC_arrayForTitle_title1".Localized() + " (\(cartDetails?.restaurant_service_fee ?? "0")%)"
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.serviceFee ?? "")"
            case "checkOutVC_arrayForTitle_title2".Localized():
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.totalRound ?? "")"
            case "checkOutVC_arrayForTitle_title3".Localized():
                if cartDetails?.promocodeType == "discount" || cartDetails?.promocodeType == "flat" {
//                    cell.lblTitle.text = "checkOutVC_arrayForTitle_title3".Localized() + " (\(cartDetails?.discount ?? "0")%)"
                    cell.lblTitle.text = "Promocode (\(cartDetails?.promocode ?? ""))"
                    cell.lblPrice.text = "- \(CurrencySymbol)\(cartDetails?.discountAmount ?? "")"
                }
            default:
                break
            }
            
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblAddedProduct:
            return UITableView.automaticDimension
        case tblOrderDetails:
            return 43
        default:
            return 43
        }
    }
    
    //MARK: - IBActions
    @objc func btnSubmitCommonPopupClicked() {
        print("hello")
    }
    @IBAction func btnRadioClick(_ sender: UIButton) {
        if sender.tag == 0{
            btnYes.isSelected = true
            btnNo.isSelected = false
        }else{
            btnNo.isSelected = true
            btnYes.isSelected = false
        }
    }
    @IBAction func BtnCancelPromocodeClick(_ sender: Any) {
        webserviceRemovePromocode()
        webserviceGetCartDetails()
    }
    @IBAction func btnReadPolicyTap(_ sender: Any) {
        webserviceGetSettings()
    }
    @IBAction func btnChangeClick(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: PromocodeVC.storyboardID) as! PromocodeVC
        vc.RestuarantID = cartDetails?.id ?? ""
        vc.cartID = cartDetails?.cartId ?? ""
        vc.ApplyPromoAmount = { promocodeApplyData in
            self.AppliedPromocode = promocodeApplyData
            self.cartDetails?.discountAmount = self.AppliedPromocode?.discountAmount
            self.cartDetails?.promocodeType = self.AppliedPromocode?.promocodeType
            self.cartDetails?.totalRound = self.AppliedPromocode?.totalRound
            self.cartDetails?.promocode = self.AppliedPromocode?.name
            self.LblTotlaPrice.text = "\(CurrencySymbol)\(self.AppliedPromocode?.grandTotal ?? "")"
            self.cartDetails?.discount = self.AppliedPromocode?.discount
            self.cartDetails?.total = self.AppliedPromocode?.oldTotal
            self.cartDetails?.tax = self.AppliedPromocode?.tax
            self.cartDetails?.serviceFee = self.AppliedPromocode?.serviceFee
            self.ApplyPromocode()
            self.tblOrderDetails.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ApplyPromoCode(_ sender: submitButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: PromocodeVC.storyboardID) as! PromocodeVC
        vc.RestuarantID = cartDetails?.id ?? ""
        vc.cartID = cartDetails?.cartId ?? ""
        
        vc.ApplyPromoAmount = { promocodeApplyData in
            
            self.AppliedPromocode = promocodeApplyData
            self.cartDetails?.discountAmount = self.AppliedPromocode?.discountAmount
            self.cartDetails?.promocodeType = self.AppliedPromocode?.promocodeType
            self.cartDetails?.totalRound = self.AppliedPromocode?.totalRound
            self.cartDetails?.discount = self.AppliedPromocode?.discount
            self.cartDetails?.promocode = self.AppliedPromocode?.name
            self.LblTotlaPrice.text = "\(CurrencySymbol)\(self.AppliedPromocode?.grandTotal ?? "")"
            self.cartDetails?.total = self.AppliedPromocode?.oldTotal
            self.cartDetails?.tax = self.AppliedPromocode?.tax
            self.cartDetails?.serviceFee = self.AppliedPromocode?.serviceFee
            self.ApplyPromocode()
            self.tblOrderDetails.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        Utilities.showHud()
            checkLocation()
    }
    func checkLocation(){
        let LocationStatus = CLLocationManager.authorizationStatus()
        if LocationStatus == .notDetermined {
            AppDelegate.shared.locationService.locationManager?.requestWhenInUseAuthorization()
        }else if LocationStatus == .restricted || LocationStatus == .denied {
            Utilities.hideHud()
            Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: "Please turn on permission from settings, to track location in app.", buttons: ["Cancel","Settings"]) { (index) in
                if index == 1 {
                    if let settingsAppURL = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                    }
                }
            }
        }else{
            if self.IsClosed{
                Utilities.hideHud()
                Utilities.showAlert(AppInfo.appName, message: "Restaurant is closed , try after some time", vc: self)
            }else{
                self.webserviceCheckOrder()
            }
        }
    }
    @IBAction func seeMenu(_ sender: submitButton) {
        
    }
    
    @IBAction func canclePromoCode(_ sender: myOrdersBtn) {
        webserviceRemovePromocode()
        self.webserviceGetCartDetails()
    }
    
    @IBAction func btnChangeLocationClicked(_ sender: Any) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
        controller.isHideCancelButton = false
        controller.isHideSubmitButton = false
        controller.submitBtnTitle = "checkOutVC_strSubmit_title".Localized()
        controller.cancelBtnTitle = "checkOutVC_strCancel_title".Localized()
        controller.strDescription = "checkOutVC_strDescription_title1".Localized()
        controller.strPopupTitle = ""
        controller.submitBtnColor = colors.appGreenColor
        controller.cancelBtnColor = colors.appRedColor
        controller.strPopupImage = "ic_popupCancleOrder"
        controller.isCancleOrder = true
        controller.btnSubmit = {
            self.webserviceRemoveCart()
            appDel.navigateToHome()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnAddFoodlistClicked(_ sender: Any) {
        webserviceAddToFoodlist()
    }
    
    @IBAction func btnChangeRestaurantClicked(_ sender: Any) {
        commonPopup.customAlert(isHideCancelButton: false, isHideSubmitButton: false, strSubmitTitle: "checkOutVC_strSubmit_title".Localized(), strCancelButtonTitle: "checkOutVC_strCancel_title".Localized(), strDescription: "checkOutVC_strDescription_title2".Localized(), strTitle: "", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
    }
    
    // MARK: - Api Calls
    
    func webserviceAddToFoodlist(){
        let foodList = AddToFoodlistReqModel()
        foodList.user_id = SingletonClass.sharedInstance.UserId
        foodList.restaurant_id = (cartDetails?.id)!
        foodList.cart_id = (self.cartDetails?.cartId)!
        WebServiceSubClass.AddToFoodList(FoodListModel: foodList, showHud: true) { (json, status, response) in
            if(status)
            {
                print(json)
                SingletonClass.sharedInstance.IsCartHide = true
                let alert = UIAlertController(title: AppName, message: json["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                    let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyFoodlistVC") as! MyFoodlistVC
                    vc.isfromcheckout = true
                    vc.restaurantid = self.cartDetails?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alert.addAction(OkAction)
                appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        }
    }
    
    func webserviceGetCartDetails(){
        let cartDetails = GetCartReqModel()
        cartDetails.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.GetCartDetails(getCartModel: cartDetails, showHud: false) { [self] (json, status, response) in
            if(status)
            {
                print(json)
                let cartData = CartListResModel.init(fromJson: json)
                
                    viewCurbSide.isHidden = (cartData.data.delivery_type == "1") ? false : true
                
                self.cartDetails = cartData.data
                self.arrCartItem = cartData.data.item
//                Utilities.displayAlert(json["messSage"].string ?? "")
                self.tblAddedProduct.reloadData()
                self.tblOrderDetails.reloadData()
                setData()
                location()
//                addMapView()
                self.tblOrderDetails.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                self.tblAddedProduct.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            }
            else
            {
                Utilities.displayAlert(title: AppInfo.appName, message: json["message"].string ?? "Something went wrong" , completion: { index in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    //Api for update Qty of item
    func webserviceUpdateQty(itemID:String,strtype:String,promocodeRemove:String = ""){
        let updateCart = UpdateCardQtyReqModel()
        updateCart.cart_item_id = itemID
        updateCart.qty = "1"
        updateCart.type = strtype
        updateCart.status = "0"
        updateCart.promocode_remove = promocodeRemove
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: false) { (json, status, response) in
            if(status)
            {
                print(json)
                let cartData = CartListResModel.init(fromJson: json)
                if cartData.is_added == "0"{
                    Utilities.displayAlert(cartData.message)
                }
                self.cartDetails = cartData.data
                if self.cartDetails == nil{
                    SingletonClass.sharedInstance.IsCartHide = true
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let tempArr = cartData.data.item.filter { (item) -> Bool in
                        return item.cartQty.toInt() != 0
                    }
                    SingletonClass.sharedInstance.IsCartHide = false
                    self.arrCartItem = tempArr
                }
                self.setData()
                self.location()
            }
            else
            {
                if json["promocode_popup"].stringValue == "1"{
                    Utilities.showAlertWithTitleFromWindow(title: AppInfo.appName, andMessage: json["message"].stringValue, buttons: ["Ok","Cancel"]) { index in
                        if index == 0{
                            self.webserviceUpdateQty(itemID: itemID, strtype: strtype,promocodeRemove: "1")
                        }else{
                            self.webserviceGetCartDetails()
                        }
                    }
                }
                else{
                    if let strMessage = json["message"].string {
                        Utilities.displayAlert(strMessage)
                    }else {
                        Utilities.displayAlert("Something went wrong")
                    }
                }
            }
        }
    }
    
    func webserviceRemovePromocode(){
        let removePromo = removePromocodeReqModel()
        removePromo.user_id = SingletonClass.sharedInstance.UserId
        removePromo.cart_id = cartDetails?.cartId ?? ""
        if AppliedPromocode == nil{
            removePromo.promocode_id = cartDetails?.promocodeId ?? ""
        }else{
            removePromo.promocode_id = AppliedPromocode?.id ?? ""
        }
        
        WebServiceSubClass.removepromocode(removepromocode: removePromo, showHud: false, completion: { (json, status, error) in
            // self.hideHUD()
            if(status) {
                Utilities.showAlertOfAPIResponse(param: json["message"].string ?? "", vc: self)
                self.webserviceCheckOrder()
                self.LblTotlaPrice.text = "\(CurrencySymbol)\(self.cartDetails?.grandTotal ?? "")"
                self.AppliedPromocode = nil
                self.lblPromoCode.isHidden = true
                self.btnCanclePromoCOde.isHidden = true
                self.btnChange.isHidden = true
                self.btnAppyPromoCode.isHidden = false
                self.btnAppyPromoCode.titleLabel?.textAlignment = .left
                self.lblPromoCode.text = ""
                self.tblOrderDetails.reloadData()
                self.webserviceGetCartDetails()
            } else {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func webserviceGetSettings(){
        WebServiceSubClass.Settings(showHud: true, completion: { (json, status, response) in
            if(status)
            {
                self.SettingsData = SettingsResModel.init(fromJson: json)
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
                controller.strUrl = self.SettingsData.privacyPolicy
                controller.strNavTitle = "NavigationTitles_Privacypolicy".Localized()
                self.navigationController?.pushViewController(controller, animated: true)
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
    func webserviceRemoveCart(){
        let clearFoodlist = RemoveCartReqModel()
        clearFoodlist.user_id = SingletonClass.sharedInstance.UserId
        clearFoodlist.type = "0"
        WebServiceSubClass.removeFoodList(removeFoodList: clearFoodlist, showHud: false,completion: { (json, status, error) in
            // self.hideHUD()
            if(status) {
                self.arrCartItem.removeAll()
            } else {
            }
        })
    }
    //check order api calling
    func webserviceCheckOrder(){
        let checkOrder = checkOrderReqModel()
        checkOrder.user_id = SingletonClass.sharedInstance.UserId
        checkOrder.cart_id = strCartId
        WebServiceSubClass.checkOrder(checkOrderModel: checkOrder, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID) as! addPaymentVC
                controller.CartTotal = (self.LblTotlaPrice.text?.replacingOccurrences(of: "\(CurrencySymbol)", with: "") ?? "").ConvertToCGFloat()
                controller.strCartID = self.strCartId
                controller.isdelivery = self.btnYes.isSelected ? "1" : "0"
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else
            {
                Utilities.displayAlert(AppInfo.appName, message: json["message"].string ?? "Something went wrong", completion: { index in
                    self.webserviceGetCartDetails()
                })
            }
        })
    }
    func location(){
        let camera = GMSCameraPosition.camera(withLatitude: cartDetails?.lat.toDouble() ?? 0.0, longitude: cartDetails?.lng.toDouble() ?? 0.0, zoom: 18.0)
        restaurantLocationView.camera = camera
                let marker = GMSMarker()
        let markerImage = UIImage(named: "imgMarker")
        let markerView = UIImageView(image: markerImage)
                        marker.position = CLLocationCoordinate2D(latitude: cartDetails?.lat.toDouble() ?? 0.0, longitude: cartDetails?.lng.toDouble() ?? 0.0)
                marker.iconView = markerView
        marker.title = cartDetails?.name
                        marker.map = restaurantLocationView
    }
}
