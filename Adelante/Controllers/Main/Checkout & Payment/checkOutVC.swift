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
    var objCurrentorder : currentOrder?
    var strOrderId = ""
    var arrayForTitle : [String] = ["checkOutVC_arrayForTitle_title".Localized(),"checkOutVC_arrayForTitle_title1".Localized(),"checkOutVC_arrayForTitle_title2".Localized()]
    let MapViewForShowRastaurantLocation = MKMapView()
    lazy var skeletonData : skeletonCheckout = skeletonCheckout.fromNib()
    var cartDetails : CartDatum?
    
    
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
    
    var arritem = [String]()
    var arrCartItem = [CartItem]()
    var addRemoveItem : ((Int,Int)->())?
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
           // calculateTotalAndSubtotal()
           
            reloadAddproductTableAndResize()
       // }else{
            tblAddProductHeight.constant = 0
            tblOrderDetailsHeight.constant = 0
       // }
    }
    
    //Not in use
    func calculateTotalAndSubtotal(){
        var total = 0.0
        let arrSelectedOrder = self.objCurrentorder?.order
        if arrSelectedOrder!.count > 0{
            var subTotal = 0.0
            for i in 0..<arrSelectedOrder!.count{
                let price : Double = Double(arrSelectedOrder![i].price) ?? 0.0
                subTotal = subTotal + price
            }
            let CalculateTax = ((Double(subTotal) * (self.objCurrentorder?.currentRestaurantDetail.tax.ToDouble() ?? 0) / 100))
            TotalTaxAmount = "\(CalculateTax)"
            total = Double(subTotal) + (self.objCurrentorder?.currentRestaurantDetail.serviceFee.ToDouble() ?? 0) + (CalculateTax)
            self.objCurrentorder?.total = "\(total)"
            self.objCurrentorder?.sub_total = "\(subTotal)"
            LblTotlaPrice.text = "\(CurrencySymbol)\(String((cartDetails?.total)!).ConvertToTwoDecimal())"
           
            self.tblOrderDetails.reloadData()
            SingletonClass.sharedInstance.restCurrentOrder = self.objCurrentorder
         
            
        }else{
            SingletonClass.sharedInstance.restCurrentOrder = nil
            self.navigationController?.popViewController(animated: true)
        }
        NotificationCenter.default.post(name: notifRefreshRestaurantDetails, object: nil)
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
//            if self.objCurrentorder?.order[indexPath.row].size != ""{
//                cell.lblItem.text = (self.objCurrentorder?.order[indexPath.row].name)! + " - " + (self.objCurrentorder?.order[indexPath.row].size)!
//            }else{
            cell.lblItem.text = objitem.itemName
//            }
            cell.lblPrice.text = "\(CurrencySymbol)\(Double(objitem.subTotal))"
            cell.lbltotalCount.text = objitem.cartQty
            let value : Int = (cell.lbltotalCount.text! as NSString).integerValue
            cell.decreaseClick = {
                if value >= 1{
//                    var quantity = cell.lbltotalCount.text?.toInt() ?? 0
//                    let Price = objitem.price.ToDouble()
//                    quantity = quantity - 1
//                    let T = Double(quantity) * Price
//                    cell.lblPrice.text = "\(CurrencySymbol)\(T)".ConvertToTwoDecimal()
//                    cell.lbltotalCount.text = "\(quantity)"
                    
                    self.webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "0")
//                    if quantity == 0{
//                        self.objCurrentorder?.order.remove(at: indexPath.row)
//                        self.reloadAddproductTableAndResize()
//                    }else{
//                        self.objCurrentorder?.order[indexPath.row].price = "\(T)"
//                        self.objCurrentorder?.order[indexPath.row].selectedQuantity = "\(quantity)"
//                    }
                }else{
                    
                }
                //self.calculateTotalAndSubtotal()
            }
            
            cell.increaseClick = { [self] in
                let quantity = cell.lbltotalCount.text?.toInt() ?? 0
                if objitem.quantity.toInt() > quantity {
                    
//                    let Price = objitem.price.ToDouble()
//                    quantity = quantity + 1
//                    let T = Double(quantity) * Price
//                    cell.lblPrice.text = "\(CurrencySymbol)\(T)".ConvertToTwoDecimal()
//                    cell.lbltotalCount.text = "\(quantity)"
//                    objitem.price = "\(T)"
//                    objitem.cartQty = "\(quantity)"
                    webserviceUpdateQty(itemID: objitem.cartItemId, strtype: "1")
                   // self.calculateTotalAndSubtotal()
                }
                else {
                  
                    Utilities.showAlert(AppName, message: "MessageQtyNotAvailable".Localized(), vc: self)
                }
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
 //               case "flat":
//                    var total = 0.0
//0
//                    total = (Double(self.objCurrentorder?.sub_total ?? "") ?? 0.0) - (Double(self.AppliedPromocode?.percentage ?? "") ?? 0.0) + (self.objCurrentorder?.service_fee.ToDouble() ?? 0.0)
//                    self.objCurrentorder?.total = "\(total)"
//                    cell.lblPrice.text = "-\(CurrencySymbol)\(self.AppliedPromocode?.percentage.ConvertToTwoDecimal() ?? "")"
//
//                    LblTotlaPrice.text = "\(CurrencySymbol)\(self.objCurrentorder?.total.ConvertToTwoDecimal() ?? "")"
//                case "discount":
//                    var total = 0.0
//
//                    let CalculateTax = ((Double(self.objCurrentorder?.sub_total ?? "") ?? 0.0) * (Double(self.AppliedPromocode?.percentage ?? "") ?? 0.0)) / 100
//                    total = (Double(self.objCurrentorder?.sub_total ?? "") ?? 0.0) - CalculateTax + (self.objCurrentorder?.service_fee.ToDouble() ?? 0.0)
//
//                    cell.lblPrice.text = "-\(CurrencySymbol)\(CalculateTax)".ConvertToTwoDecimal()
//
//                    self.objCurrentorder?.total = "\(total)"
//
//                    LblTotlaPrice.text = "\(CurrencySymbol)\(self.objCurrentorder?.total.ConvertToTwoDecimal() ?? "")"
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
            return 60
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
        controller.strStorePolicy = objCurrentorder?.currentRestaurantDetail.storePolicy ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func ApplyPromoCode(_ sender: submitButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: PromocodeVC.storyboardID) as! PromocodeVC
        vc.RestuarantID = objCurrentorder?.restaurant_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID) as! addPaymentVC
        
        
        var ForPassOrderData : [Order] = []
        self.objCurrentorder?.order.forEach({ (element) in
            var ForPassVarientIdData : [Int] = []
            element.variants_id.forEach { (varientElement) in
                ForPassVarientIdData.append(varientElement.variant_id.toInt())
            }
            
            ForPassOrderData.append(Order(OrderPirce: element.price, OrderQuantity: element.selectedQuantity, OrderRestaurantItemID: element.restaurant_item_id, OrderVariantsId: ForPassVarientIdData))
        })
        var PromoCodeID = ""
        if AppliedPromocode != nil {
            PromoCodeID = AppliedPromocode?.id ?? ""
        }
        let ForPassPlaceOrderData = PlacerOrderData.init(PlaceComment: "", PlaceOrder: ForPassOrderData, PlacePromoCodeID: PromoCodeID, PlaceRating: "", PlaceRestaurantID: self.objCurrentorder?.restaurant_id ?? "", PlaceServiceFee: self.objCurrentorder?.service_fee ?? "", PlaceSubTotal: self.objCurrentorder?.sub_total ?? "", PlaceTax: self.TotalTaxAmount, PlaceTotal: LblTotlaPrice.text?.RemoveCurrencySymbol() ?? "", PlaceUserID: self.objCurrentorder?.user_id ?? "")
        
        
        let stringOfJSONData = ForPassPlaceOrderData.toDictionary()
        let jsonData = try! JSONSerialization.data(withJSONObject: stringOfJSONData, options: [])
        let jsonString:String = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
        print(jsonString)
        controller.OrderDetails = jsonString
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @IBAction func seeMenu(_ sender: submitButton) {
        //        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
        //        self.navigationController?.pushViewController(controller, animated: true)
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
        //commonPopup.customAlert(isHideCancelButton: false, isHideSubmitButton: false, strSubmitTitle: "checkOutVC_strSubmit_title".Localized(), strCancelButtonTitle: "checkOutVC_strCancel_title".Localized(), strDescription: "checkOutVC_strDescription_title1".Localized(), strTitle: "", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
        
        
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
       // let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyFoodlistVC") as! MyFoodlistVC
       // self.navigationController?.pushViewController(vc, animated: true)
//        for i in 0...(objCurrentorder?.order.count)! - 1 {
//            arritem.append((objCurrentorder?.order[i].restaurant_item_id)!)
//        }
//        print(arritem.joined(separator: ","))
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
        WebServiceSubClass.GetCartDetails(getCartModel: cartDetails, showHud: true) { [self] (json, status, response) in
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
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: true) { (json, status, response) in
            if(status)
            {
                print(json)
                let cartData = CartListResModel.init(fromJson: json)
                self.cartDetails = cartData.data
                self.arrCartItem = cartData.data.item
                Utilities.displayAlert(json["message"].string ?? "")
                self.tblAddedProduct.reloadData()
                self.tblOrderDetails.reloadData()
                self.setData()
                self.addMapView()
                
                if let obj = self.addRemoveItem{
                     obj(Int(self.cartDetails?.id ?? "") ?? 0,cartData.data.totalQuantity)
                }
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
}

class PlacerOrderData {
    
    var comment : String!
    var order : [Order]!
    var promocodeId : String!
    var rating : String!
    var restaurantId : String!
    var serviceFee : String!
    var subTotal : String!
    var tax : String!
    var total : String!
    var userId : String!
    
    init(PlaceComment:String,PlaceOrder:[Order],PlacePromoCodeID:String,PlaceRating:String,PlaceRestaurantID:String,PlaceServiceFee:String,PlaceSubTotal:String,PlaceTax:String,PlaceTotal:String,PlaceUserID:String) {
        comment = PlaceComment
        order = PlaceOrder
        promocodeId = PlacePromoCodeID
        rating = PlaceRating
        restaurantId = PlaceRestaurantID
        serviceFee = PlaceServiceFee
        subTotal = PlaceSubTotal
        tax = PlaceTax
        total = PlaceTotal
        userId = PlaceUserID
    }

      
        func toDictionary() -> [String:Any]
        {
            var dictionary = [String:Any]()
            if comment != nil{
                dictionary["comment"] = comment
            }
            if order != nil{
            var dictionaryElements = [[String:Any]]()
            for orderElement in order {
                dictionaryElements.append(orderElement.toDictionary())
            }
            dictionary["order"] = dictionaryElements
            }
            if promocodeId != nil{
                dictionary["promocode_id"] = promocodeId
            }
            if rating != nil{
                dictionary["rating"] = rating
            }
            if restaurantId != nil{
                dictionary["restaurant_id"] = restaurantId
            }
            if serviceFee != nil{
                dictionary["service_fee"] = serviceFee
            }
            if subTotal != nil{
                dictionary["sub_total"] = subTotal
            }
            if tax != nil{
                dictionary["tax"] = tax
            }
            if total != nil{
                dictionary["total"] = total
            }
            if userId != nil{
                dictionary["user_id"] = userId
            }
            return dictionary
        }
    
   
    
    class func convertDataCartArrayToProductsDictionary(arrayDataCart : PlacerOrderData) -> [String:Any] {
        return arrayDataCart.toDictionary()
    }
    
}


class Order {

    var price : String!
    var quantity : String!
    var restaurantItemId : String!
    var variantsId : [Int]!

    init(OrderPirce:String,OrderQuantity:String,OrderRestaurantItemID:String,OrderVariantsId:[Int]) {
        price = OrderPirce
        quantity = OrderQuantity
        restaurantItemId = OrderRestaurantItemID
        variantsId = OrderVariantsId
      
    }
   
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if price != nil{
            dictionary["price"] = price
        }
        if quantity != nil{
            dictionary["quantity"] = quantity
        }
        if restaurantItemId != nil{
            dictionary["restaurant_item_id"] = restaurantItemId
        }
        if variantsId != nil{
            dictionary["variants_id"] = variantsId
        }
        return dictionary
    }
}
