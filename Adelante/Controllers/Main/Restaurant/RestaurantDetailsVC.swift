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
import Cosmos
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


class RestaurantDetailsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,AddveriantDelegate {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrSections = [structSections(strTitle:"RestaurantDetailsVC_arrSection".Localized(),isExpanded:false, rowCount: 3), structSections(strTitle:"RestaurantDetailsVC_arrSection1".Localized(),isExpanded:true, rowCount: 5), structSections(strTitle:"RestaurantDetailsVC_arrSection2".Localized(),isExpanded:false, rowCount: 2)] //["Menu","Sandwiches","Salad"]
    var selectedRestaurantId = ""
    var arrMenuitem = [MenuItem]()
    var arrFoodMenu = [FoodMenu]()
    var objRestaurant : RestaurantDataDetails!
    var arrAddToCartItem : addCartDatum!
    var arrItemList = [ItemList]()
    var arrUpdateQty :updateQtyDatum!
    var SelectedCatId = ""
    var pageNumber = "1"
    var selectedIndex = ""
    var isFromDeshboard : Bool = false
    var isFromRestaurantList : Bool = false
    var isFromFavoriteList : Bool = false
    var isFromRestaurantOutlets : Bool = false
    var expandviewheight = 0
    var SearchData = ""
    var strItemId = ""
    var selectedIndexItem = IndexPath()
    lazy var skeletonViewData : skeletonView = skeletonView.fromNib()
    let activityView = UIActivityIndicatorView(style: .gray)
    // MARK: - IBOutlets
    @IBOutlet var viewPopup: UIView!
    @IBOutlet weak var tblPopup: UITableView!
    @IBOutlet weak var lblrating: themeLabel!
    @IBOutlet weak var tblRestaurantDetails: UITableView!
    @IBOutlet weak var heightTblRestDetails: NSLayoutConstraint!
    @IBOutlet weak var imgFoodDetails: UIImageView!
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var vwRating: CosmosView!
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
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var tblPopupHeight: NSLayoutConstraint!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPopup.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblRestaurantDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.viewBG.layer.cornerRadius = 10
        self.viewBG.clipsToBounds = true
        viewPopup.frame = self.view.frame
        tblPopup.delegate = self
        tblPopup.dataSource = self
        tblPopup.reloadData()
        skeletonViewData.showAnimatedSkeleton()
        skeletonViewData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonViewData)
        webservicePostRestaurantDetails()
        setUpLocalizedStrings()
        //        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantDetails, object: nil)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        webservicePostRestaurantDetails()
    }
    
    // MARK: - Other Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let info = object, let collObj = info as? UITableView{
            
            if collObj == self.tblRestaurantDetails{
                self.heightTblRestDetails.constant = tblRestaurantDetails.contentSize.height
            }else if collObj == self.tblPopup{
                self.tblPopupHeight.constant = tblPopup.contentSize.height
            }
        }
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.restaurantDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.liked.value], isTranslucent: true, isShowHomeTopBar: false)
        
        tblRestaurantDetails.delegate = self
        tblRestaurantDetails.dataSource = self
        tblRestaurantDetails.estimatedRowHeight = 20
        tblRestaurantDetails.reloadData()
        btnNavLike.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
    }
    func dateFormat(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let item = "7:00 PM"
        let date = dateFormatter.date(from: item)
        print("Start: \(date ?? Date())") // Start: Optional(2000-01-01 19:00:00 +0000)
    }
    func setUpLocalizedStrings(){
        lblPromoCode.text = "RestaurantDetailsVC_lblPromoCode".Localized()
        lblCode.text = "RestaurantDetailsVC_lblCode".Localized()
        lblOpenTime.text = "RestaurantDetailsVC_lblOpenTime".Localized()
        lblTimeZone.text = "RestaurantDetailsVC_lblTimeZone".Localized()
        btnViewPolicy.setTitle("RestaurantDetailsVC_btnViewPolicy".Localized(), for: .normal)
        lblSign.text = "RestaurantDetailsVC_lblSign".Localized()
        lblViewCards.text = "RestaurantDetailsVC_lblViewCart".Localized()
    }
    func setData(){
        if objRestaurant != nil{
            
            self.lblRestaurantName.text = objRestaurant.name ?? ""
            self.lblrating.text = objRestaurant.rating
            self.lblReviews.text = "(" + String(format: "RestaurantReviewVC_lblReviews".Localized(), objRestaurant.review) + ")"
            self.lblDistance.text =  objRestaurant.distance
            self.lblAddress.text = objRestaurant.address ?? ""
            self.lblEastern.text = objRestaurant.timeZone
            self.lblTime.text = "\(objRestaurant.fromTime ?? "")"
            self.lblCompleteTime.text = "\(objRestaurant.toTime ?? "")"
            self.lblAboutRestaurant.text = objRestaurant.descriptionField ?? ""
            let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(objRestaurant.image ?? "")"
            self.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            checkItemsAndUpdateFooter(Qty: objRestaurant.totalQuantity, Total: objRestaurant.totalPrice)
            if objRestaurant.favourite == "1"{
                btnNavLike.isSelected = true
            } else {
                btnNavLike.isSelected = false
            }
        }
        
    }
    
    func checkItemsAndUpdateFooter(Qty:String,Total:String){
        if Qty.toInt() > 1 {
            self.lblNoOfItem.text = Qty + " items"
        } else {
            self.lblNoOfItem.text = Qty + " item"
        }
        lblPrice.text = "\(CurrencySymbol)" + Total
        if Qty != "0"{
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
        //        self.calculateTableHeight()
    }
    
    func addVeriantincart(veriantid: String) {
        print(veriantid)
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
        controller.strStorePolicy = objRestaurant?.storePolicy ?? ""
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BtnRattingsAndReviews(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantReviewVC.storyboardID) as! RestaurantReviewVC
        controller.strRestaurantId = selectedRestaurantId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnCloseTap(_ sender: Any) {
        self.viewPopup.isHidden = true
    }
    @IBAction func btnAddNewClick(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "BffComboVC") as! BffComboVC
        vc.selectedItemId = strItemId
        vc.selectedRestaurantId = objRestaurant.id
        self.viewPopup.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewCart(_ sender: Any) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
            controller.addRemoveItem = { id,amount in
                self.webservicePostRestaurantDetails()
                
            }
            //controller.strOrderId = "5"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc  func btnExpand(_ sender : UIButton) {
        for i in 0..<arrFoodMenu.count {
            if sender.tag == i {
                if arrFoodMenu[i].isExpanded == true {
                    arrFoodMenu[i].isExpanded = false
                    let count = arrFoodMenu[i].subMenu.count * 70
                    expandviewheight = expandviewheight - count
                    break
                } else {
                    arrFoodMenu[i].isExpanded = true
                    let count = arrFoodMenu[i].subMenu.count * 70
                    expandviewheight = expandviewheight + count
                }
            } else {
                // arrFoodMenu[i].isExpanded = false
            }
        }
        
        DispatchQueue.main.async {
            //            self.calculateTableHeight()
            self.tblRestaurantDetails.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegates And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        //                return self.arrSections.count
        if tableView == tblRestaurantDetails{
            return arrMenuitem.count > 0 ? arrFoodMenu.count + 1 : arrFoodMenu.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblRestaurantDetails{
            return self.setRowCount(section: section)
        }else{
            return arrItemList.count
        }
        
    }
    func showActivityIndicatory() {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
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
        if tableView == tblRestaurantDetails{
            if arrMenuitem.count > 0 {
                if indexPath.section == 0 {
                    let cell:RestaurantDetailsCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantDetailsCell", for: indexPath)as! RestaurantDetailsCell
                    let variantValue = arrMenuitem[indexPath.row].variant.ToDouble()
                    cell.lblItemName.text = arrMenuitem[indexPath.row].name
                    cell.lblItemPrice.text = "\(CurrencySymbol)" + arrMenuitem[indexPath.row].price.ConvertToTwoDecimal()
                    cell.lblAboutItem.text = arrMenuitem[indexPath.row].descriptionField
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrMenuitem[indexPath.row].image ?? "")"
                    cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.lblNoOfItem.text = arrMenuitem[indexPath.row].cartQty
                    cell.btnAddItem.isHidden = false
                    cell.vwStapper.isHidden = true
                    cell.stackHide.isHidden = false
                    self.activityView.stopAnimating()
                    if indexPath.row == 0{
                        if objRestaurant.menuType == 1{
                            cell.vwRadius.cornerRadius = 5
                            cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
                            cell.vwRadius.layer.borderWidth = 1
                        }else{
                            cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
                        }
                    }
                    if Int(arrMenuitem[indexPath.row].cartQty) ?? 0 > 0 {
                        cell.btnAddItem.isHidden = true
                        cell.vwStapper.isHidden = false
                    }
                    cell.decreaseData = {
                        if variantValue > 0{
                            self.viewPopup.isHidden = false
                            self.view.addSubview(self.viewPopup)
                            self.webserviceItemList(strItemId: self.arrMenuitem[indexPath.row].id)
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.tblPopup.reloadData()
                        }else{
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.IncreseData = {
                        if variantValue > 0{
                            self.viewPopup.isHidden = false
                            self.view.addSubview(self.viewPopup)
                            self.webserviceItemList(strItemId: self.arrMenuitem[indexPath.row].id)
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.tblPopup.reloadData()
                        }else{
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    if variantValue > 0{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.btnAddAction = {
                        if self.objRestaurant.isdiff == 0{
                            let alert = UIAlertController(title: "Adelante System", message: "if you want to add data here your previous cart is empty", preferredStyle: UIAlertController.Style.alert)
                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                if self.arrMenuitem[indexPath.row].quantity.toInt() > 1 {
                                    cell.btnAddItem.isHidden = true
                                    cell.vwStapper.isHidden = false
                                    self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                }
                            }
                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            alert.addAction(NoAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            if self.arrMenuitem[indexPath.row].quantity.toInt() > 1 {
                                cell.btnAddItem.isHidden = true
                                cell.vwStapper.isHidden = false
                                self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                            }
                        }
                    }
                    
                    cell.customize = {
                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                        controller.selectedRestaurantId = self.objRestaurant.id
                        controller.delegateAddVariant = self
                        self.strItemId = self.arrMenuitem[indexPath.row].id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
                    let variantValue = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant.ToDouble()
                    cell.lblItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name.trimmingCharacters(in: .whitespacesAndNewlines)
                    cell.lblItemPrice.text = "\(CurrencySymbol)" + arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.ConvertToTwoDecimal()
                    cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size
                    cell.lblNoOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
                    
                    cell.btnAdd.isHidden = false
                    cell.vwStapper.isHidden = true
                    cell.StackHide.isHidden = false
                    self.activityView.stopAnimating()
                    if indexPath.section == 1 && indexPath.row == 0{
                        if objRestaurant.foodType == 1{
                            cell.vwRadius.cornerRadius = 5
                            cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
                            cell.vwRadius.layer.borderWidth = 1
                        }else{
                            cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
                        }
                    }
                    if Int(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
                        cell.btnAdd.isHidden = true
                        cell.vwStapper.isHidden = false
                    }
                    
                    if arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant == "1"{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.decreaseData = { [self] in
                        if variantValue > 0{
                            self.viewPopup.isHidden = false
                            self.view.addSubview(self.viewPopup)
                            self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id)
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.tblPopup.reloadData()
                        }else{
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                            cell.StackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.IncreseData = {
                        if variantValue > 0{
                            self.viewPopup.isHidden = false
                            self.view.addSubview(self.viewPopup)
                            self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id)
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.tblPopup.reloadData()
                        }else{
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                            cell.StackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.btnAddAction = {
                        if self.objRestaurant.isdiff == 0{
                            let alert = UIAlertController(title: "Adelante System", message: "if you want to add data here your previous cart is empty", preferredStyle: UIAlertController.Style.alert)
                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity.ToDouble() > 1{
                                    cell.btnAdd.isHidden = true
                                    cell.vwStapper.isHidden = false
                                    self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                }
                            }
                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            alert.addAction(NoAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity.ToDouble() > 1{
                                cell.btnAdd.isHidden = true
                                cell.vwStapper.isHidden = false
                                self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                            }
                        }
                        
                    }
                    if variantValue > 0{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.customize = { [self] in
                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                        controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                        controller.selectedRestaurantId = self.objRestaurant.id
                        self.strItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
                let variantValue = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant.ToDouble()
                cell.lblItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].name
                cell.lblItemPrice.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].price
                cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].size
                cell.lblNoOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty
                cell.btnAdd.isHidden = false
                cell.vwStapper.isHidden = true
                cell.StackHide.isHidden = false
                self.activityView.stopAnimating()
                if Int(arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                }
                if indexPath.section == 0 && indexPath.row == 0{
                    if objRestaurant.foodType == 1{
                        cell.vwRadius.cornerRadius = 5
                        cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
                        cell.vwRadius.layer.borderWidth = 1
                    }else{
                        cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
                    }
                }
                if arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant == "1"{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.decreaseData = {
                    if variantValue > 0{
                        self.viewPopup.isHidden = false
                        self.view.addSubview(self.viewPopup)
                        self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id)
                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                        self.tblPopup.reloadData()
                    }else{
                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                        
                        cell.StackHide.isHidden = true
                        self.activityView.center = cell.vwStapper.center
                        cell.vwStapper.addSubview(self.activityView)
                        self.activityView.startAnimating()
                    }
                }
                cell.IncreseData = { [self] in
                    if variantValue > 0{
                        self.viewPopup.isHidden = false
                        self.view.addSubview(self.viewPopup)
                        self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id)
                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                        self.tblPopup.reloadData()
                    }else{
                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                        cell.StackHide.isHidden = true
                        self.activityView.center = cell.vwStapper.center
                        cell.vwStapper.addSubview(self.activityView)
                        self.activityView.startAnimating()
                    }
                }
                if variantValue > 0{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.btnAddAction = {
                    if self.objRestaurant.isdiff == 0{
                        let alert = UIAlertController(title: "Adelante System", message: "if you want to add data here your previous cart is empty", preferredStyle: UIAlertController.Style.alert)
                        let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                            if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity.ToDouble() > 1 {
                                cell.btnAdd.isHidden = true
                                cell.vwStapper.isHidden = false
                                self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                            }
                        }
                        let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                        alert.addAction(yesAction)
                        alert.addAction(NoAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity.ToDouble() > 1 {
                            cell.btnAdd.isHidden = true
                            cell.vwStapper.isHidden = false
                            self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                        }
                    }
                    
                }
                
                cell.customize = {
                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                    controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                    controller.selectedRestaurantId = self.objRestaurant.id
                    self.strItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell:RestaurantDetailsPopupCell = tblPopup.dequeueReusableCell(withIdentifier: RestaurantDetailsPopupCell.reuseIdentifier) as! RestaurantDetailsPopupCell
            cell.lblItemName.text = arrItemList[indexPath.row].itemName
            cell.lblPrice.text = "\(CurrencySymbol)" + arrItemList[indexPath.row].price.ConvertToTwoDecimal()
            cell.lblDesc.text = arrItemList[indexPath.row].descriptionField
            let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrItemList[indexPath.row].itemImg ?? "")"
            cell.imgRestDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgRestDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            cell.lblNoOfItem.text = arrItemList[indexPath.row].qty
            self.strItemId = arrItemList[indexPath.row].id
            
            //            self.activityView.stopAnimating()
            //            cell.stackHide.isHidden = false
            if arrItemList[indexPath.row].qty == "0"{
                cell.btnAdd.isHidden = false
                cell.vwStapper.isHidden = true
            }else{
                cell.btnAdd.isHidden = true
                cell.vwStapper.isHidden = false
            }
            cell.IncreseData = {
                self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "1",row: indexPath.row)
                cell.stackHide.isHidden = true
                self.activityView.center = cell.vwStapper.center
                cell.vwStapper.addSubview(self.activityView)
                self.activityView.startAnimating()
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                //                    self.activityView.stopAnimating()
                //                    cell.stackHide.isHidden = false
                //                    cell.lblNoOfItem.text = self.arrItemList[indexPath.row].qty
                //                })
            }
            cell.decreaseData = {
                self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "0",row: indexPath.row)
                cell.stackHide.isHidden = true
                self.activityView.center = cell.vwStapper.center
                cell.vwStapper.addSubview(self.activityView)
                self.activityView.startAnimating()
            }
            cell.btnAddAction = {
                if self.arrItemList[indexPath.row].quantity.ToDouble() > 1 {
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                    self.webwerviceAddtoCart(strItemId: self.arrItemList[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblRestaurantDetails{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 48))
            headerView.backgroundColor = .white
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
                    if arrFoodMenu[section - 1].isExpanded == true{
                        expandImageView.image = UIImage(named: "ic_upExpand")
                    }else{
                        expandImageView.image = UIImage(named: "ic_expand")
                    }
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
                if arrFoodMenu[section].isExpanded == true{
                    expandImageView.image = UIImage(named: "ic_upExpand")
                }else{
                    expandImageView.image = UIImage(named: "ic_expand")
                }
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
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblRestaurantDetails{
            return 48
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 1))
        footerView.backgroundColor = UIColor(hexString: "#707070").withAlphaComponent(0.2)
        return footerView
    }
    
    // MARK: - Api Calls
    func webservicePostRestaurantDetails(){
        let ResDetails = RestaurantDetailsReqModel()
        ResDetails.restaurant_id = selectedRestaurantId
        ResDetails.page = "\(pageNumber)"
        ResDetails.user_id = SingletonClass.sharedInstance.UserId
        ResDetails.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        ResDetails.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        ResDetails.search = SearchData
        WebServiceSubClass.RestaurantDetails(RestaurantDetailsmodel: ResDetails, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status {
                let RestDetail = RestaurantDetailsResModel.init(fromJson: response)
                self.skeletonViewData.removeFromSuperview()
                self.skeletonViewData.stopShimmering()
                self.skeletonViewData.stopSkeletonAnimation()
                self.arrMenuitem = RestDetail.data.restaurant.menuItem
                self.arrFoodMenu = RestDetail.data.restaurant.foodMenu
                self.objRestaurant = RestDetail.data.restaurant
                self.tblRestaurantDetails.reloadData()
                //                self.calculateTableHeight()
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
    
    
    func webwerviceAddtoCart(strItemId:String,Section:Int,row:Int){
        let addToCart = AddToCartReqModel()
        addToCart.restaurant_id = selectedRestaurantId
        addToCart.user_id = SingletonClass.sharedInstance.UserId
        addToCart.qty = "1"
        addToCart.item_id = strItemId
        addToCart.addon_id = ""
        addToCart.search = SearchData
        WebServiceSubClass.AddToCart(AddToCartModel: addToCart, showHud: false) { [self] (response, status, error) in
            if status {
                let cartitem = addCartResModel.init(fromJson: response)
                arrAddToCartItem = cartitem.data
                arrFoodMenu = cartitem.restaurant.foodMenu
                arrMenuitem = cartitem.restaurant.menuItem
                objRestaurant.isdiff = cartitem.restaurant.isdiff
                self.checkItemsAndUpdateFooter(Qty: arrAddToCartItem.totalQuantity, Total: arrAddToCartItem.total)
                tblRestaurantDetails.reloadData()
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        }
    }
    //MARK : - update quantity
    func webserviceUpdateCartQuantity(strItemid:String,strQty:String,strType:String,row:Int){
        let updateCart = UpdateCardQtyReqModel()
        updateCart.cart_item_id = strItemid
        updateCart.qty = strQty
        updateCart.type = strType
        updateCart.search = SearchData
        updateCart.status = "0"
        
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: false){ [self] (json, status, response) in
            if(status)
            {
                let cartData = updateCartResModel.init(fromJson: json)
                self.arrUpdateQty = cartData.data
                self.arrFoodMenu = cartData.restaurant.foodMenu
                self.arrMenuitem = cartData.restaurant.menuItem
                if self.arrUpdateQty == nil {
                    self.viewPopup.isHidden = true
                    //self.checkItemsAndUpdateFooter(Qty: self.arrUpdateQty.totalQuantity, Total: self.arrUpdateQty.total)
                }else{
                    self.checkItemsAndUpdateFooter(Qty: self.arrUpdateQty.totalQuantity, Total: self.arrUpdateQty.total)
                    let index = IndexPath(row: row, section: 0)
                    if self.arrMenuitem.count == 0 {
                        if self.arrFoodMenu[index.section].subMenu[index.row].variant == "1"{
                            let cell = self.tblPopup.cellForRow(at: index) as! RestaurantDetailsPopupCell
                            
                            if (cell.lblNoOfItem.text?.toInt())! <= 1 && strType == "0"{
                                self.viewPopup.isHidden = true
                            }
                            for i in 0...self.arrUpdateQty.item.count - 1{
                                if strItemid == self.arrUpdateQty.item[i].cartItemId{
                                    cell.lblNoOfItem.text = self.arrUpdateQty.item[i].cartQty
                                }
                            }
                            cell.stackHide.isHidden = false
                            self.activityView.stopAnimating()
                        }
                    }else{
                        let variantValue = arrMenuitem[selectedIndexItem.row].variant.ToDouble()
                        if variantValue > 0{
                            let cell = self.tblPopup.cellForRow(at: index) as! RestaurantDetailsPopupCell
                            
                            if (cell.lblNoOfItem.text?.toInt())! <= 1 && strType == "0"{
                                self.viewPopup.isHidden = true
                            }
                            for i in 0...self.arrUpdateQty.item.count - 1{
                                if strItemid == self.arrUpdateQty.item[i].cartItemId{
                                    cell.lblNoOfItem.text = self.arrUpdateQty.item[i].cartQty
                                }
                            }
                            cell.stackHide.isHidden = false
                            self.activityView.stopAnimating()
                        }
                    }
                }
                self.tblRestaurantDetails.reloadData()
            }else{
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
    func webserviceItemList(strItemId:String){
        let itemlist = ItemListReqModel()
        itemlist.item_id = strItemId
        itemlist.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.itemList(itemListModel: itemlist, showHud: false){ (json, status, response) in
            if(status)
            {
                print(json)
                let itemListData = ItemListResModel.init(fromJson: json)
                self.arrItemList = itemListData.data.item
                self.tblPopup.reloadData()
                self.setData()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
}

