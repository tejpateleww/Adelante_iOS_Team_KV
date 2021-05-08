//
//  RestaurantDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
struct structSections {
    
    
    var strTitle:String
    
    var isExpanded:Bool
    var rowCount:Int
    
    init(strTitle:String, isExpanded:Bool, rowCount:Int) {
        self.strTitle = strTitle
        self.isExpanded = isExpanded
        self.rowCount = rowCount
    }
}


class RestaurantDetailsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrSections = [structSections(strTitle:"RestaurantDetailsVC_arrSection".Localized(),isExpanded:false, rowCount: 3), structSections(strTitle:"RestaurantDetailsVC_arrSection1".Localized(),isExpanded:true, rowCount: 5), structSections(strTitle:"RestaurantDetailsVC_arrSection2".Localized(),isExpanded:false, rowCount: 2)] //["Menu","Sandwiches","Salad"]
    var selectedRestaurantId = ""
    var arrMenuitem = [MenuItem]()
    var arrFoodMenu = [FoodMenu]()
    var arrSelectedOrder = [selectedOrderItems]()
    var objRestaurant : Restaurantinfo!
    var objCurrentOrder : currentOrder!
    var SelectedCatId = ""
    var pageNumber = "1"
    var selectedIndex = ""
    var isFromDeshboard : Bool = false
    var isFromRestaurantList : Bool = false
    var isFromFavoriteList : Bool = false
    var isFromRestaurantOutlets : Bool = false
    // MARK: - IBOutlets
    @IBOutlet weak var tblRestaurantDetails: UITableView!
    @IBOutlet weak var heightTblRestDetails: NSLayoutConstraint!
    @IBOutlet weak var imgFoodDetails: UIImageView!
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var lblRating: themeLabel!
    @IBOutlet weak var lblReviews: themeLabel!
    @IBOutlet weak var lblPromoCode: themeLabel!
    @IBOutlet weak var lblCode: themeLabel!
    @IBOutlet weak var lblDistance: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblOpenTime: themeLabel!
    @IBOutlet weak var lblTime: themeLabel!
    @IBOutlet weak var lblCompleteTime: themeLabel!
    @IBOutlet weak var lblTimeZone: themeLabel!
    @IBOutlet weak var lblEastern: themeLabel!
    @IBOutlet weak var lblAboutRestaurant: themeLabel!
    @IBOutlet weak var btnViewPolicy: submitButton!
    @IBOutlet weak var lblNoOfItem: themeLabel!
    @IBOutlet weak var lblSign: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblViewCards: themeLabel!
    @IBOutlet weak var stackPromocode: UIStackView!
    @IBOutlet weak var viewFooter: UIView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webservicePostRestaurantDetails()
        setUpLocalizedStrings()
        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshRestaurantDetail), name: notifRefreshRestaurantDetails, object: nil)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.restaurantDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.liked.value], isTranslucent: true, isShowHomeTopBar: false)
        
        tblRestaurantDetails.delegate = self
        tblRestaurantDetails.dataSource = self
        tblRestaurantDetails.estimatedRowHeight = 20
        tblRestaurantDetails.reloadData()
        btnNavLike.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
        if arrSelectedOrder.count > 0{
            viewFooter.isHidden = false
            lblSign.isHidden = false
        } else {
            viewFooter.isHidden = true
            lblPrice.text = ""
            lblNoOfItem.text = ""
            lblSign.isHidden = true
        }
    }
    @objc func refreshRestaurantDetail() {
        setData()
        self.objCurrentOrder = SingletonClass.sharedInstance.restCurrentOrder
        if self.objCurrentOrder != nil {
            for i in 0..<arrMenuitem.count {
                for j in 0..<self.objCurrentOrder.order.count {
                    let id = self.objCurrentOrder.order[j].restaurant_item_id
                    if arrMenuitem[i].id == id {
                        arrMenuitem[i].selectedQuantity = self.objCurrentOrder.order[j].selectedQuantity
                    } else {
                        arrMenuitem[i].selectedQuantity = ""
                    }
                }
            }
            
            for i in 0..<arrFoodMenu.count {
                for k in 0..<arrFoodMenu[i].subMenu.count {
                    for j in 0..<self.objCurrentOrder.order.count {
                        let id = self.objCurrentOrder.order[j].restaurant_item_id
                        if arrFoodMenu[i].subMenu[k].id == id {
                            arrFoodMenu[i].subMenu[k].selectedQuantity = self.objCurrentOrder.order[j].selectedQuantity
                        } else {
                            arrFoodMenu[i].subMenu[k].selectedQuantity = ""
                        }
                    }
                }
            }
        } else {
            for i in 0..<arrMenuitem.count {
                arrMenuitem[i].selectedQuantity = ""
            }
            
            for i in 0..<arrFoodMenu.count {
                for k in 0..<arrFoodMenu[i].subMenu.count {
                    arrFoodMenu[i].subMenu[k].selectedQuantity = ""
                }
            }
        }
        self.tblRestaurantDetails.reloadData()
        self.checkItemsAndUpdateFooter()
        self.calculateTableHeight()
    }
    func dateFormat(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let item = "7:00 PM"
        let date = dateFormatter.date(from: item)
        print("Start: \(date)") // Start: Optional(2000-01-01 19:00:00 +0000)
    }
    func setUpLocalizedStrings(){
        lblRestaurantName.text = "RestaurantDetailsVC_lblRestaurantName".Localized()
        lblReviews.text = String(format: "RestaurantDetailsVC_lblReviews".Localized(), "53")
        lblPromoCode.text = "RestaurantDetailsVC_lblPromoCode".Localized()
        lblCode.text = "RestaurantDetailsVC_lblCode".Localized()
//        lblDistance.text = String(format: "RestaurantDetailsVC_lblDistance".Localized(), "1.7")
        lblOpenTime.text = "RestaurantDetailsVC_lblOpenTime".Localized()
        lblTime.text = "RestaurantDetailsVC_lblTime".Localized()
        lblTimeZone.text = "RestaurantDetailsVC_lblTimeZone".Localized()
        lblEastern.text = "RestaurantDetailsVC_lblEastern".Localized()
        lblAboutRestaurant.text = "RestaurantDetailsVC_lblAboutRestaurant".Localized()
        btnViewPolicy.setTitle("RestaurantDetailsVC_btnViewPolicy".Localized(), for: .normal)
        //        lblNoOfItem.text = String(format: "RestaurantDetailsVC_lblNoOfItem".Localized(), "1")
        lblSign.text = "RestaurantDetailsVC_lblSign".Localized()
        //        lblPrice.text = "$30"
        lblViewCards.text = "RestaurantDetailsVC_lblViewCart".Localized()
    }
    func setData(){
        if objRestaurant != nil{
            self.lblRestaurantName.text = objRestaurant.name ?? ""
            //            self.lblPrice.text = objRestaurant. ?? ""
            self.lblRating.text = objRestaurant.rating
            self.lblReviews.text = String(format: "RestaurantReviewVC_lblReviews".Localized(), objRestaurant.review)
            //            self.lblTimeZone.text = objRestaurant.
            self.lblDistance.text =  objRestaurant.distance
            self.lblAddress.text = objRestaurant.address ?? ""
//            if objRestaurant.promocode == ""{
//                stackPromocode.isHidden = true
//            }else{
//                stackPromocode.isHidden = false
//            }
//            self.lblCode.text = objRestaurant.promocode ?? ""
            self.lblTime.text = "\(objRestaurant.fromTime ?? "")"
            self.lblCompleteTime.text = "\(objRestaurant.toTime ?? "")"
            self.lblAboutRestaurant.text = objRestaurant.descriptionField ?? ""
            self.lblEastern.text = objRestaurant.timezone ?? ""
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(objRestaurant.image ?? "")"
            self.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            if objRestaurant.favourite == "1"{
                btnNavLike.isSelected = true
            } else {
                btnNavLike.isSelected = false
            }
        }
    }
    func checkOrderItems(objOrder:selectedOrderItems){
        let CurrentitemId = objOrder.restaurant_item_id
        if arrSelectedOrder.count > 0 {
            var itemFound = false
            for i in 0..<arrSelectedOrder.count{
                let itemId = arrSelectedOrder[i].restaurant_item_id
                if itemId == CurrentitemId{
                    if objOrder.selectedQuantity != ""{
                        arrSelectedOrder[i] = objOrder
                        itemFound = true
                        break
                    }else{
                        arrSelectedOrder.remove(at: i)
                        itemFound = true
                        break
                    }
                }
                
            }
            if itemFound == false{
                arrSelectedOrder.append(objOrder)
            }
        }else{
            arrSelectedOrder.append(objOrder)
        }
        checkItemsAndUpdateFooter()
    }
    func checkItemsAndUpdateFooter(){
        var total = 0
        if arrSelectedOrder.count > 0{
            var subTotal = 0
            for i in 0..<arrSelectedOrder.count{
                let price : Int = Int(arrSelectedOrder[i].price) ?? 0
                subTotal = subTotal + price
            }
            total = Int(subTotal) + objRestaurant.serviceFee.toInt() + objRestaurant.tax.toInt()
            let dicTemp = currentOrder.init(userId: SingletonClass.sharedInstance.UserId, restautaurantId: objRestaurant.id, rating: "", comment: "", subTotal: "\(subTotal)", serviceFee: objRestaurant.serviceFee, tax: objRestaurant.tax, total: "\(total)", order: arrSelectedOrder, currentRestaurantDetail: self.objRestaurant)
            objCurrentOrder = dicTemp
            SingletonClass.sharedInstance.restCurrentOrder = self.objCurrentOrder
            //            userDefault.setUserData(objProfile)
        }
        
        if arrSelectedOrder.count > 1 {
            self.lblNoOfItem.text = "\(arrSelectedOrder.count) items"
        } else {
            self.lblNoOfItem.text = "\(arrSelectedOrder.count) item"
        }
        
        self.lblPrice.text = "$\(total)"
        if arrSelectedOrder.count > 0{
            viewFooter.isHidden = false
            lblSign.isHidden = false
        }else{
            viewFooter.isHidden = true
            lblPrice.text = ""
            lblNoOfItem.text = ""
            lblSign.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.calculateTableHeight()
    }
    
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        if objRestaurant != nil{
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            var Select = objRestaurant.favourite ?? ""
            let restaurantId = objRestaurant.id ?? ""
            if Select == "1"{
                Select = "0"
            }else{
                Select = "1"
            }
            webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
        }
    }
    @IBAction func btnViewPolicy(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
        controller.strNavTitle = "NavigationTitles_Privacypolicy".Localized()
        controller.strStorePolicy = "http://18.208.18.170/assets/images/restaurant/banner/4832a33c4cc865f705753eb6c799f47e.pdf"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BtnRattingsAndReviews(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantReviewVC.storyboardID) as! RestaurantReviewVC
        controller.strRestaurantId = selectedRestaurantId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnViewCart(_ sender: Any) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            //             vc.delegateFilter = self
            //             vc.selectedSortData = self.SelectFilterId
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc  func btnExpand(_ sender : UIButton) {
        for i in 0..<arrFoodMenu.count {
            if sender.tag == i {
                if arrFoodMenu[i].isExpanded == true {
                    arrFoodMenu[i].isExpanded = false
                    break
                } else {
                    arrFoodMenu[i].isExpanded = true
                }
            } else {
                arrFoodMenu[i].isExpanded = false
            }
        }
        
        DispatchQueue.main.async {
            self.tblRestaurantDetails.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegates And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return self.arrSections.count
        return arrMenuitem.count > 0 ? arrFoodMenu.count + 1 : arrFoodMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setRowCount(section: section)
    }
    
    func setRowCount(section : Int) -> Int{
        var rowCount = 0
        if arrMenuitem.count > 0{
            if section == 0 {
                rowCount = arrMenuitem.count
            } else {
                if arrFoodMenu.count > 0 {
                    rowCount = arrFoodMenu[section - 1].isExpanded == true ? arrFoodMenu[section - 1].subMenu.count : 0
                }
            }
        } else {
            if arrFoodMenu.count > 0 {
                rowCount = arrFoodMenu[section].isExpanded == true ? arrFoodMenu[section].subMenu.count : 0
            }
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrMenuitem.count > 0 {
            if indexPath.section == 0 {
                let cell:RestaurantDetailsCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantDetailsCell", for: indexPath)as! RestaurantDetailsCell
                cell.lblItemName.text = arrMenuitem[indexPath.row].name
                cell.lblItemPrice.text = "$" + arrMenuitem[indexPath.row].price
                cell.lblAboutItem.text = arrMenuitem[indexPath.row].descriptionField
                let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrMenuitem[indexPath.row].image ?? "")"
                cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.lblNoOfItem.text = arrMenuitem[indexPath.row].selectedQuantity
                cell.btnAddItem.isHidden = false
                cell.vwStapper.isHidden = true
                if Int(arrMenuitem[indexPath.row].selectedQuantity) ?? 0 > 0 {
                    cell.btnAddItem.isHidden = true
                    cell.vwStapper.isHidden = false
                }
                cell.decreaseData = {
                    var strQty = ""
                    if cell.lblNoOfItem.text != ""{
                        var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                        if value == 1 {
                            strQty = ""
                            cell.btnAddItem.isHidden = false
                            cell.vwStapper.isHidden = true
                        }else if value > 1{
                            value = value - 1
                            cell.lblNoOfItem.text = String(value)
                            strQty = "\(value)"
                        }
                    }
                    var pr = 0
                    pr = strQty.toInt() * self.arrMenuitem[indexPath.row].price.toInt()
                    self.arrMenuitem[indexPath.row].selectedQuantity = strQty
                    let objItem = selectedOrderItems(restaurant_item_id: self.arrMenuitem[indexPath.row].id, quantity: self.arrMenuitem[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrMenuitem[indexPath.row].name, originalPrice: self.arrMenuitem[indexPath.row].price, size: "", selectedQuantity: "\(strQty)")
                    self.checkOrderItems(objOrder: objItem)
                }
                cell.IncreseData = {
                    var strQty = ""
                    var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                    if self.arrMenuitem[indexPath.row].quantity.toInt() > value {
                        if cell.lblNoOfItem.text != "" {
                            
                            value = value + 1
                            cell.lblNoOfItem.text = String(value)
                            strQty = "\(value)"
                            
                        }
                        var pr = 0
                        pr = strQty.toInt() * self.arrMenuitem[indexPath.row].price.toInt()
                        self.arrMenuitem[indexPath.row].selectedQuantity = strQty
                        let objItem = selectedOrderItems(restaurant_item_id: self.arrMenuitem[indexPath.row].id, quantity: self.arrMenuitem[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrMenuitem[indexPath.row].name, originalPrice: self.arrMenuitem[indexPath.row].price, size: "", selectedQuantity: "\(strQty)")
                        self.checkOrderItems(objOrder: objItem)
                    } else {
                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                    }
                }
                cell.btnAddAction = {
                    if self.arrMenuitem[indexPath.row].quantity.toInt() >= 1 {
                        cell.btnAddItem.isHidden = true
                        cell.vwStapper.isHidden = false
                        let strQty = "1"
                        cell.lblNoOfItem.text = strQty
                        self.arrMenuitem[indexPath.row].selectedQuantity = strQty
                        var pr = 0
                        pr = strQty.toInt() * self.arrMenuitem[indexPath.row].price.toInt()
                        let objItem = selectedOrderItems(restaurant_item_id: self.arrMenuitem[indexPath.row].id, quantity: self.arrMenuitem[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrMenuitem[indexPath.row].name, originalPrice: self.arrMenuitem[indexPath.row].price, size: "", selectedQuantity: "\(strQty)")
                        self.checkOrderItems(objOrder: objItem)
                    } else {
                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                    }
                }
                let variantValue = arrMenuitem[indexPath.row].variant.toInt()
                if variantValue > 0{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.customize = {
                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                    controller.selectedRestaurantId = self.arrMenuitem[indexPath.row].id
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
                cell.lblItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name
                cell.lblItemPrice.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price
                cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size
                cell.lblNoOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].selectedQuantity
                
                cell.btnAdd.isHidden = false
                cell.vwStapper.isHidden = true
                if Int(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].selectedQuantity) ?? 0 > 0 {
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                }
                
                if arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant == "1"{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.decreaseData = { [self] in
                    var strQty = ""
                    if cell.lblNoOfItem.text != ""{
                        var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                        if value == 1 {
                            cell.btnAdd.isHidden = false
                            cell.vwStapper.isHidden = true
                        }else if value > 1 {
                            value = value - 1
                            cell.lblNoOfItem.text = String(value)
                            strQty = "\(value)"
                        }
                    }
                    self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].selectedQuantity = strQty
                    var pr = 0
                    pr = strQty.toInt() * self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.toInt()
                    let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price, size: arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size, selectedQuantity: "\(strQty)")
                    self.checkOrderItems(objOrder: objItem)
                }
                cell.IncreseData = {
                    var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                    if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity.toInt() > value {
                        var strQty = ""
                        if cell.lblNoOfItem.text != "" {
                            value = value + 1
                            cell.lblNoOfItem.text = String(value)
                            strQty = "\(value)"
                        }
                        self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].selectedQuantity = strQty
                        var pr = 0
                        pr = strQty.toInt() * self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.toInt()
                        let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price, size: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size, selectedQuantity: strQty)
                        self.checkOrderItems(objOrder: objItem)
                    }
                    else {
                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                    }
                }
                cell.btnAddAction = {
                    if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity.toInt() >= 1 {
                        cell.btnAdd.isHidden = true
                        cell.vwStapper.isHidden = false
                        let strQty = "1"
                        cell.lblNoOfItem.text = strQty
                        self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].selectedQuantity = strQty
                        var pr = 0
                        pr = strQty.toInt() * self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.toInt()
                        let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price, size: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size, selectedQuantity: strQty)
                        self.checkOrderItems(objOrder: objItem)
                    }
                    else {
                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                    }
                }
                let variantValue = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant.toInt()
                if variantValue > 0{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.customize = {
                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                    controller.selectedRestaurantId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
            cell.lblItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].name
            cell.lblItemPrice.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].price
            cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].size
            cell.lblNoOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].selectedQuantity
            cell.btnAdd.isHidden = false
            cell.vwStapper.isHidden = true
            if Int(arrFoodMenu[indexPath.section].subMenu[indexPath.row].selectedQuantity) ?? 0 > 0 {
                cell.btnAdd.isHidden = true
                cell.vwStapper.isHidden = false
            }
            
            if arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant == "1"{
                cell.btnCustomize.isHidden = false
            }else{
                cell.btnCustomize.isHidden = true
            }
            cell.decreaseData = {
                var strQty = ""
                if cell.lblNoOfItem.text != ""{
                    var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                    if value == 1{
                        cell.btnAdd.isHidden = false
                        cell.vwStapper.isHidden = true
                    }else if value > 1{
                        value = value - 1
                        cell.lblNoOfItem.text = String(value)
                        strQty = "\(value)"
                    }
                }
                self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].selectedQuantity = strQty
                var pr = 0
                pr = strQty.toInt() * self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price.toInt()
                let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price, size: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].size, selectedQuantity: strQty)
                self.checkOrderItems(objOrder: objItem)
            }
            cell.IncreseData = {
                var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity.toInt() > value {
                    var strQty = ""
                    if cell.lblNoOfItem.text != ""{
                        
                        value = value + 1
                        cell.lblNoOfItem.text = String(value)
                        strQty = "\(value)"
                    }
                    self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].selectedQuantity = strQty
                    var pr = 0
                    pr = strQty.toInt() * self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price.toInt()
                    let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price, size: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].size, selectedQuantity: strQty)
                    self.checkOrderItems(objOrder: objItem)
                }
                else {
                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                }
            }
            cell.btnAddAction = {
                if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity.toInt() >= 1 {
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                    let strQty = "1"
                    cell.lblNoOfItem.text = strQty
                    self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].selectedQuantity = strQty
                    var pr = 0
                    pr = strQty.toInt() * self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price.toInt()
                    let objItem = selectedOrderItems(restaurant_item_id: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, quantity: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name, originalPrice: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].price, size: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].size, selectedQuantity: strQty)
                    self.checkOrderItems(objOrder: objItem)
                }
                else {
                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")","\(self.arrMenuitem[indexPath.row].quantity ?? "")"]), vc: self)
                }
            }
            let variantValue = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant.toInt()
            if variantValue > 0{
                cell.btnCustomize.isHidden = false
            }else{
                cell.btnCustomize.isHidden = true
            }
            cell.customize = {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                controller.selectedRestaurantId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                self.navigationController?.pushViewController(controller, animated: true)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 48))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 14, width: headerView.frame.width-40, height: 20)
        label.center.y = headerView.frame.size.height / 2
        
        label.font = CustomFont.NexaBold.returnFont(20)
        label.textColor = colors.black.value
        headerView.addSubview(label)
        
        if arrMenuitem.count > 0 {
            if section == 0 {
                label.text = "RestaurantDetailsVC_arrSection".Localized()
            } else {
                let expandImageView = UIImageView()
                expandImageView.frame = CGRect.init(x: headerView.frame.width - 35.66, y: 34.31, width: 16.66, height: 8.38)
                expandImageView.center.y = headerView.frame.size.height / 2
                expandImageView.image = UIImage(named: "ic_expand")
                headerView.addSubview(expandImageView)
                
                let expandButton = UIButton()
                expandButton.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
                expandButton.tag = section - 1
                expandButton.addTarget(self, action: #selector(btnExpand(_:)), for: .touchUpInside)
                headerView.addSubview(expandButton)
                label.text = arrFoodMenu[section - 1].categoryName
            }
        } else {
            let expandImageView = UIImageView()
            expandImageView.frame = CGRect.init(x: headerView.frame.width - 35.66, y: 34.31, width: 16.66, height: 8.38)
            expandImageView.center.y = headerView.frame.size.height / 2
            expandImageView.image = UIImage(named: "ic_expand")
            headerView.addSubview(expandImageView)
            
            let expandButton = UIButton()
            expandButton.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            
            expandButton.tag = section
            expandButton.addTarget(self, action: #selector(btnExpand(_:)), for: .touchUpInside)
            headerView.addSubview(expandButton)
            label.text = arrFoodMenu[section].categoryName
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 1))
        footerView.backgroundColor = UIColor(hexString: "#707070").withAlphaComponent(0.2)
        return footerView
    }
    
    func calculateTableHeight() {
        var extraHeight = 0
        if self.arrMenuitem.count > 0 {
            extraHeight = extraHeight + 45
            if self.arrFoodMenu.count > 0 {
                extraHeight = extraHeight + (self.arrFoodMenu.count * 45)
            }
        } else {
            extraHeight = self.arrFoodMenu.count * 45
        }
        self.heightTblRestDetails.constant = self.tblRestaurantDetails.contentSize.height + CGFloat(extraHeight)
        self.tblRestaurantDetails.layoutIfNeeded()
    }
    
    // MARK: - Api Calls
    func webservicePostRestaurantDetails(){
        let ResDetails = RestaurantDetailsReqModel()
        ResDetails.restaurant_id = selectedRestaurantId
        ResDetails.page = "\(pageNumber)"
        ResDetails.user_id = SingletonClass.sharedInstance.UserId
        ResDetails.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        ResDetails.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.RestaurantDetails(RestaurantDetailsmodel: ResDetails, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            if status {
                let RestDetail = RestaurantDetailsResModel.init(fromJson: response)
                self.arrMenuitem = RestDetail.data.restaurant.menuItem
                self.arrFoodMenu = RestDetail.data.restaurant.foodMenu
                self.objRestaurant = RestDetail.data.restaurant
                self.tblRestaurantDetails.reloadData()
                self.calculateTableHeight()
                self.setData()
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
            //            self.hideHUD()
            if status {
                self.objRestaurant.favourite = Status
                if self.objRestaurant.favourite == "1"{
                    self.btnNavLike.isSelected = true
                } else {
                    self.btnNavLike.isSelected = false
                }
                NotificationCenter.default.post(name: notifRefreshDashboardList, object: nil)
                NotificationCenter.default.post(name: notifRefreshRestaurantList, object: nil)
                NotificationCenter.default.post(name: notifRefreshFavouriteList, object: nil)
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}

