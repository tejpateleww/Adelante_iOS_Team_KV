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
class checkOutVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    var TotalTaxAmount = ""
    var AppliedPromocode : Promocode?
    
    
    
    var customTabBarController: CustomTabBarVC?
    //    var objCurrentorder : currentOrder?
    var strOrderId = ""
    var arrayForTitle : [String] = ["checkOutVC_arrayForTitle_title".Localized(),"checkOutVC_arrayForTitle_title1".Localized(),"checkOutVC_arrayForTitle_title2".Localized()]
    let MapViewForShowRastaurantLocation = MKMapView()
    lazy var skeletonData : skeletonCheckout = skeletonCheckout.fromNib()
    var cartDetails : CartDatum?
    var arritem = [String]()
    var arrCartItem = [CartItem]()
    var addRemoveItem : ((Int,Int)->())?
    let activityView = UIActivityIndicatorView(style: .gray)
    var strCartId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var tblAddedProduct: UITableView!
    @IBOutlet weak var tblOrderDetails: UITableView!
    @IBOutlet weak var restaurantLocationView: customImagewithShadow!
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
    @IBOutlet weak var btnPlaceOrder: submitButton!
    
    // MARK: - ViewController Lifecycle
    
    // handle notification
    @objc func GetPromocodeData(notification: NSNotification) {
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: notification.userInfo ?? [:], options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                let ResModel = Promocode.init(FromDictonary: dictFromJSON)
                AppliedPromocode = ResModel
                ApplyPromocode()
                self.tblOrderDetails.reloadData()
                // use dictFromJSON
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    func ApplyPromocode() {
        
        if AppliedPromocode != nil {
            btnAppyPromoCode.isHidden = true
            
            lblPromoCode.isHidden = false
            lblPromoCode.text = AppliedPromocode?.promocode
            btnCanclePromoCOde.isHidden = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonData.showAnimatedSkeleton()
        skeletonData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonData)
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.checkOutVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetPromocodeData(notification:)), name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil)
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
        // if SingletonClass.sharedInstance.restCurrentOrder != nil{
        // self.objCurrentorder = SingletonClass.sharedInstance.restCurrentOrder
        lblItemName.text = cartDetails?.name//objCurrentorder?.currentRestaurantDetail.name
        centerMapOnLocation(location: CLLocation(latitude: Double(cartDetails?.lat ?? "") ?? 0.0, longitude: Double(cartDetails?.lng ?? "") ?? 0.0), mapView: MapViewForShowRastaurantLocation)
        lblAddress.text = cartDetails?.address
        LblTotlaPrice.text = "\(CurrencySymbol)\(cartDetails?.grandTotal ?? 0.0)"
        tblAddedProduct.delegate = self
        tblOrderDetails.delegate = self
        tblAddedProduct.dataSource = self
        tblOrderDetails.dataSource = self
        tblOrderDetails.reloadData()
        self.strCartId = cartDetails?.cartId ?? ""
        // calculateTotalAndSubtotal()
        
        reloadAddproductTableAndResize()
        // }else{
        tblAddProductHeight.constant = 0
        tblOrderDetailsHeight.constant = 0
        // }
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case tblAddedProduct:
            return self.arrCartItem.count
        case tblOrderDetails:
            arrayForTitle.removeAll()
            
            arrayForTitle.append("checkOutVC_arrayForTitle_title".Localized())
            var cnt = 1
            if AppliedPromocode != nil {
                arrayForTitle.append("checkOutVC_arrayForTitle_title3".Localized())
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
            cell.lblPrice.text = "\(CurrencySymbol)\(Double(objitem.subTotal))"
            cell.lbltotalCount.text = objitem.cartQty
            cell.stackHide.isHidden = false
            let value : Int = (cell.lbltotalCount.text! as NSString).integerValue
            cell.decreaseClick = {
                self.webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "0")
                cell.stackHide.isHidden = true
                cell.vwStapper.isHidden = false
                self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2, y: cell.vwStapper.frame.height/2)
                cell.vwStapper.addSubview(self.activityView)
                self.activityView.startAnimating()
            }
            
            cell.increaseClick = { [self] in
                webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "1")
                cell.stackHide.isHidden = true
                cell.vwStapper.isHidden = false
                self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2, y: cell.vwStapper.frame.height/2)
                cell.vwStapper.addSubview(self.activityView)
                self.activityView.startAnimating()
            }
            
            cell.selectionStyle = .none
            return cell
            
        case tblOrderDetails:
            
            let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: orderDetailsCell.reuseIdentifier, for: indexPath) as! orderDetailsCell
            switch arrayForTitle[indexPath.row] {
            case "checkOutVC_arrayForTitle_title".Localized():
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.total ?? 0)"
            case "checkOutVC_arrayForTitle_title1".Localized():
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.serviceFee ?? "0")"
            case "checkOutVC_arrayForTitle_title2".Localized():
                cell.lblPrice.text = "\(CurrencySymbol)\(cartDetails?.totalRound ?? 0.0)"
            case "checkOutVC_arrayForTitle_title3".Localized():
                switch AppliedPromocode?.offerType.lowercased() {
                default:
                    break
                }
            default:
                break
            }
            
            cell.lblTitle.text = arrayForTitle[indexPath.row]
            if cell.lblTitle.text == "checkOutVC_arrayForTitle_title2".Localized() {
                cell.lblTitle.text = "checkOutVC_arrayForTitle_title2".Localized() + " (\(cartDetails?.tax! ?? "0")%)"
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
        print("hellloo")
    }
    @IBAction func BtnCancelPromocodeClick(_ sender: Any) {
        btnAppyPromoCode.isHidden = false
        btnCanclePromoCOde.isHidden = true
        lblPromoCode.text = ""
        AppliedPromocode = nil
        self.tblOrderDetails.reloadData()
        
        
    }
    @IBAction func btnReadPolicyTap(_ sender: Any) {
        
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
        controller.strNavTitle = "NavigationTitles_Privacypolicy".Localized()
        //        controller.strStorePolicy = objCurrentorder?.currentRestaurantDetail.storePolicy ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func ApplyPromoCode(_ sender: submitButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: PromocodeVC.storyboardID) as! PromocodeVC
        vc.RestuarantID = cartDetails?.id ?? ""
        vc.cartID = cartDetails?.cartId ?? ""
        //        vc.RestuarantID = objCurrentorder?.restaurant_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        WebServiceCallForOrder()
//        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID) as! addPaymentVC
//        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @IBAction func seeMenu(_ sender: submitButton) {
        
    }
    
    @IBAction func canclePromoCode(_ sender: myOrdersBtn) {
        AppliedPromocode = nil
        lblPromoCode.isHidden = true
        btnCanclePromoCOde.isHidden = true
        btnAppyPromoCode.isHidden = false
        btnAppyPromoCode.titleLabel?.textAlignment = .left
        
        lblPromoCode.text = ""
        
        self.tblOrderDetails.reloadData()
    }
    
    @IBAction func btnChangeLocationClicked(_ sender: Any) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
        //controller.modalPresentationStyle = .fullScreen
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
            appDel.navigateToHome()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnAddFoodlistClicked(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyFoodlistVC") as! MyFoodlistVC
        self.navigationController?.pushViewController(vc, animated: true)
        webserviceAddToFoodlist()
    }
    
    @IBAction func btnChangeRestaurantClicked(_ sender: Any) {
        commonPopup.customAlert(isHideCancelButton: false, isHideSubmitButton: false, strSubmitTitle: "checkOutVC_strSubmit_title".Localized(), strCancelButtonTitle: "checkOutVC_strCancel_title".Localized(), strDescription: "checkOutVC_strDescription_title2".Localized(), strTitle: "", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
    }
    
    // MARK: - Api Calls
    func webserviceRepeatOrder(){
        let repeatOrder = RepeatOrderReqModel()
        repeatOrder.user_id = SingletonClass.sharedInstance.UserId
        repeatOrder.main_order_id = strOrderId
        repeatOrder.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        repeatOrder.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.RepeatOrder(repeatOrder: repeatOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                let repeatOrderData = RepeatOrderResModel.init(fromJson: json)
                print(repeatOrderData)
                //                self.objCurrentorder = repeatOrderData.data.subOrder
                Utilities.displayAlert(json["message"].string ?? "")
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
    
    
    func webserviceAddToFoodlist(){
        let foodList = AddToFoodlistReqModel()
        foodList.user_id = SingletonClass.sharedInstance.UserId
        foodList.restaurant_id = (cartDetails?.id)!
        foodList.cart_id = (self.cartDetails?.cartId)!
        WebServiceSubClass.AddToFoodList(FoodListModel: foodList, showHud: false) { (json, status, response) in
            if(status)
            {
                print(json)
                // let AddtoFoodlistData = AddToFoodlistReqModel.init()
                //                self.objOrderData = repeatOrderData.data
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyFoodlistVC") as! MyFoodlistVC
                self.navigationController?.pushViewController(vc, animated: true)
                Utilities.displayAlert(json["message"].string ?? "")
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
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
                self.cartDetails = cartData.data
                self.arrCartItem = cartData.data.item
                Utilities.displayAlert(json["messSage"].string ?? "")
                self.tblAddedProduct.reloadData()
                self.tblOrderDetails.reloadData()
                setData()
                addMapView()
                self.tblOrderDetails.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                self.tblAddedProduct.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
    
    //Api for update Qty of item
    //NOTE :- type 1- increment, 0 - decrement
    func webserviceUpdateQty(itemID:String,strtype:String){
        let updateCart = UpdateCardQtyReqModel()
        updateCart.cart_item_id = itemID
        updateCart.qty = "1"
        updateCart.type = strtype
        updateCart.status = "0"
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: false) { (json, status, response) in
            if(status)
            {
                print(json)
                let cartData = CartListResModel.init(fromJson: json)
                self.cartDetails = cartData.data
                if self.cartDetails == nil{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.arrCartItem = cartData.data.item
                    if let obj = self.addRemoveItem{
                        obj(Int(self.cartDetails?.id ?? "") ?? 0,cartData.data.totalQuantity)
                    }
                }
                //                self.tblAddedProduct.reloadData()
                //                self.tblOrderDetails.reloadData()
                self.setData()
                self.addMapView()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
    func WebServiceCallForOrder(){
        
        let ReqModel = orderPlaceReqModel()
        ReqModel.user_id = SingletonClass.sharedInstance.UserId
        ReqModel.cart_id = strCartId
        WebServiceSubClass.PlaceOrder(OrderModel: ReqModel, showHud: false, completion: { (json, status, response) in
            if(status)
            {
//                commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "  Payment Successful      ", strCancelButtonTitle: "", strDescription: json["data"].string ?? "", strTitle: "", isShowImage: true, strImage: "ic_popupPaymentSucessful", isCancleOrder: false, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyOrdersVC.storyboardID) as! MyOrdersVC
                    self.navigationController?.pushViewController(controller, animated: true)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
        
    }
}



