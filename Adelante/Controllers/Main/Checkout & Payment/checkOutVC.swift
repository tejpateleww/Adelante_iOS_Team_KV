//
//  checkOutVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import MapKit
class checkOutVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var objCurrentorder : currentOrder?
    var arrayForTitle : [String] = ["checkOutVC_arrayForTitle_title".Localized(),"checkOutVC_arrayForTitle_title1".Localized(),"checkOutVC_arrayForTitle_title2".Localized()]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
//        tblOrderDetailsHeight.constant = CGFloat(arrayForTitle.count * 43)
//        tblAddProductHeight.constant = CGFloat(arrayForTitle.count * 60)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.checkOutVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        setData()
        addMapView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - Other Methods
    func addMapView()
    {
        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: restaurantLocationView.frame.size.width, height: restaurantLocationView.frame.size.height)
        restaurantLocationView.addSubview(mapView)
    }
    func setData(){
        if SingletonClass.sharedInstance.restCurrentOrder != nil{
        self.objCurrentorder = SingletonClass.sharedInstance.restCurrentOrder
            lblItemName.text = objCurrentorder?.currentRestaurantDetail.name
        lblAddress.text = objCurrentorder?.currentRestaurantDetail.address
        LblTotlaPrice.text = self.objCurrentorder?.total
            tblAddedProduct.delegate = self
            tblOrderDetails.delegate = self
            tblAddedProduct.dataSource = self
            tblOrderDetails.dataSource = self
            tblOrderDetails.reloadData()
             tblOrderDetailsHeight.constant = tblOrderDetails.contentSize.height
            reloadAddproductTableAndResize()
        }else{
            tblAddProductHeight.constant = 0
            tblOrderDetailsHeight.constant = 0
        }
    }
    func calculateTotalAndSubtotal(){
        var total = 0
        let arrSelectedOrder = self.objCurrentorder?.order
        if arrSelectedOrder!.count > 0{
            var subTotal = 0
            for i in 0..<arrSelectedOrder!.count{
                let price : Int = Int(arrSelectedOrder![i].price) ?? 0
                    subTotal = subTotal + price
                }

            total = Int(subTotal) + (self.objCurrentorder?.currentRestaurantDetail.serviceFee.toInt())! + (self.objCurrentorder?.currentRestaurantDetail.tax.toInt())!
            self.objCurrentorder?.total = "\(total)"
            self.objCurrentorder?.sub_total = "\(subTotal)"
            LblTotlaPrice.text = self.objCurrentorder?.total
            self.tblOrderDetails.reloadData()
            SingletonClass.sharedInstance.restCurrentOrder = self.objCurrentorder
////            userDefault.setUserData(objProfile)
        }else{
            SingletonClass.sharedInstance.restCurrentOrder = nil
            self.navigationController?.popViewController(animated: true)
        }
        NotificationCenter.default.post(name: notifRefreshRestaurantDetails, object: nil)
    }
    func reloadAddproductTableAndResize(){
        tblAddedProduct.reloadData()
        tblAddProductHeight.constant = CGFloat((objCurrentorder?.order.count)! * 60) //tblAddedProduct.contentSize.height
    }
    func setUpLocalizedStrings()
    {
//        lblItemName.text = "checkOutVC_lblItemName".Localized()
        lblAddress.text = "43369 Ellgworthg St, remont,CA 43369 Ellgworthg St, remont,CA 43369 Ellgworthg St, remont,CA"
        btnChangeLocation.setTitle("checkOutVC_btnChangeLocation".Localized(), for: .normal)
        btnChangeRestaurant.setTitle("checkOutVC_btnChangeRestaurant".Localized(), for: .normal)
        btnAppyPromoCode.setTitle("checkOutVC_btnAppyPromoCode".Localized(), for: .normal)
        lblYourOrder.text = "checkOutVC_lblYourOrder".Localized()
        btnSeeMenu.setTitle("checkOutVC_btnSeeMenu".Localized(), for: .normal)
//        lblTotal.text = "checkOutVC_lblTotal".Localized()
//        LblTotlaPrice.text = "$39"
        lblCancellation.text = "checkOutVC_lblCancellation".Localized()
        btnReadPOlicy.setTitle("checkOutVC_btnReadPOlicy".Localized(), for: .normal)
        btnAddFoodlist.setTitle("checkOutVC_btnAddFoodlist".Localized(), for: .normal)
        btnPlaceOrder.setTitle("checkOutVC_btnPlaceOrder".Localized(), for: .normal)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblAddedProduct:
            return self.objCurrentorder?.order.count ?? 0
        case tblOrderDetails:
            var cnt = 1
            if (self.objCurrentorder?.service_fee.toInt())! > 0{
                cnt = cnt + 1
            }
            if (self.objCurrentorder?.tax.toInt())! > 0{
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
            if self.objCurrentorder?.order[indexPath.row].size != ""{
                cell.lblItem.text = (self.objCurrentorder?.order[indexPath.row].name)! + " - " + (self.objCurrentorder?.order[indexPath.row].size)!
            }else{
                cell.lblItem.text = self.objCurrentorder?.order[indexPath.row].name
            }
            cell.lblPrice.text = self.objCurrentorder?.order[indexPath.row].price
            cell.lbltotalCount.text = self.objCurrentorder?.order[indexPath.row].quantity
            let value : Int = (cell.lbltotalCount.text! as NSString).integerValue
            cell.decreaseClick = {
                if value >= 1{
                    var quantity = cell.lbltotalCount.text?.toInt() ?? 0
                    let Price = self.objCurrentorder?.order[indexPath.row].originalPrice.toInt() ?? 0
                    quantity = quantity - 1
                    let T = quantity * Price
                    cell.lblPrice.text = "\(T)"
                    cell.lbltotalCount.text = "\(quantity)"
                    if quantity == 0{
                        self.objCurrentorder?.order.remove(at: indexPath.row)
                        self.reloadAddproductTableAndResize()
                    }else{
                        self.objCurrentorder?.order[indexPath.row].price = "\(T)"
                        self.objCurrentorder?.order[indexPath.row].quantity = "\(quantity)"
                    }
                }else{
                    
                }
                self.calculateTotalAndSubtotal()
                
            }
            cell.increaseClick = {
                var quantity = cell.lbltotalCount.text?.toInt() ?? 0
                let Price = self.objCurrentorder?.order[indexPath.row].originalPrice.toInt() ?? 0
                quantity = quantity + 1
                let T = quantity * Price
                cell.lblPrice.text = "\(T)"
                cell.lbltotalCount.text = "\(quantity)"
                self.objCurrentorder?.order[indexPath.row].price = "\(T)"
                self.objCurrentorder?.order[indexPath.row].quantity = "\(quantity)"
                
                self.calculateTotalAndSubtotal()
            }
            
            
            cell.selectionStyle = .none
            return cell
        case tblOrderDetails:
            let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: orderDetailsCell.reuseIdentifier, for: indexPath) as! orderDetailsCell
                if indexPath.row == 0{
                    cell.lblPrice.text = self.objCurrentorder?.sub_total ?? ""
                }else if indexPath.row == 1{
                    cell.lblPrice.text = self.objCurrentorder?.service_fee ?? ""
                }else if indexPath.row == 2{
                    cell.lblPrice.text = self.objCurrentorder?.tax ?? ""
                }
            cell.lblTitle.text = arrayForTitle[indexPath.row]
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
    
    //MARK: -IBActions
    @objc func btnSubmitCommonPopupClicked() {
        
    }
    
    @IBAction func btnReadPolicyTap(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
        controller.strNavTitle = "NavigationTitles_Privacypolicy".Localized()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func ApplyPromoCode(_ sender: submitButton) {
        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: applyPromoCodeVC.storyboardID) as! applyPromoCodeVC
        //controller.modalPresentationStyle = .fullScreen
        controller.btnOk = {
            self.dismiss(animated: true, completion: nil)
            self.btnAppyPromoCode.isHidden = true
            self.lblPromoCode.isHidden = false
            self.btnCanclePromoCOde.isHidden = false
            
            self.lblPromoCode.text = "AD200"
//            self.arrayForTitle.append("Promo Code")
//            self.arrayForPrice.append("2")
//            self.tblOrderDetailsHeight.constant = CGFloat(self.arrayForTitle.count * 43)
//            self.LblTotlaPrice.text = "$37"
            self.tblOrderDetails.reloadData()
        }
//        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func seeMenu(_ sender: submitButton) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func canclePromoCode(_ sender: myOrdersBtn) {
        lblPromoCode.isHidden = true
        btnCanclePromoCOde.isHidden = true
        btnAppyPromoCode.isHidden = false
        btnAppyPromoCode.titleLabel?.textAlignment = .left
        
        lblPromoCode.text = ""
//        self.LblTotlaPrice.text = "$39"
//        self.arrayForPrice.removeLast()
//        self.arrayForTitle.removeLast()
//        tblOrderDetailsHeight.constant = CGFloat(arrayForTitle.count * 43)
        self.tblOrderDetails.reloadData()
    }
    
    @IBAction func btnChangeLocationClicked(_ sender: Any) {
        commonPopup.customAlert(isHideCancelButton: false, isHideSubmitButton: false, strSubmitTitle: "checkOutVC_strSubmit_title".Localized(), strCancelButtonTitle: "checkOutVC_strCancel_title".Localized(), strDescription: "checkOutVC_strDescription_title1".Localized(), strTitle: "", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
    }
    
    @IBAction func btnAddFoodlistClicked(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyFoodlistVC") as! MyFoodlistVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnChangeRestaurantClicked(_ sender: Any) {
        commonPopup.customAlert(isHideCancelButton: false, isHideSubmitButton: false, strSubmitTitle: "checkOutVC_strSubmit_title".Localized(), strCancelButtonTitle: "checkOutVC_strCancel_title".Localized(), strDescription: "checkOutVC_strDescription_title2".Localized(), strTitle: "", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
    }
    // MARK: - Api Calls
}
