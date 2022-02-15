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
import SkeletonView
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


class RestaurantDetailsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,AddveriantDelegate,SkeletonTableViewDataSource, ExpandableLabelDelegate {
    
    
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var responseStatus : webserviceResponse = .initial
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
    var isfromMenu :Bool = false
    lazy var skeletonViewData : skeletonView = skeletonView.fromNib()
    let activityView = UIActivityIndicatorView(style: .gray)
    var SettingsData : SettingsResModel!
    var isFromFoodlist : Bool = false
    // MARK: - IBOutlets
    
    @IBOutlet weak var ViewForAddItem: UIView!
    @IBOutlet var viewPopup: UIView!
    @IBOutlet weak var tblPopup: UITableView!{
        didSet{
            tblPopup.isSkeletonable = true
        }
    }
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
    @IBOutlet weak var lblAboutRestaurant: ExpandableLabel!
    @IBOutlet weak var btnViewPolicy: submitButton!
    @IBOutlet weak var lblNoOfItem: themeLabel!
    @IBOutlet weak var lblSign: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblViewCards: themeLabel!
    @IBOutlet weak var stackPromocode: UIStackView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var tblPopupHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Lbloperatingdays: themeLabel!
    @IBOutlet weak var LblClosed: themeLabel!
    @IBOutlet weak var ViewForBottom: NSLayoutConstraint!
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        ViewForBottom.constant = -(ViewForAddItem.frame.size.height)
        viewBG.isHidden = true
        tblPopup.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblRestaurantDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        viewPopup.frame = self.view.frame
        tblPopup.delegate = self
        tblPopup.dataSource = self
        tblPopup.reloadData()
        tblRestaurantDetails.delegate = self
        tblRestaurantDetails.dataSource = self
        tblRestaurantDetails.reloadData()
        skeletonViewData.showAnimatedSkeleton()
        skeletonViewData.frame.size.width = view.frame.size.width
        self.view.addSubview(skeletonViewData)
//        webservicePostRestaurantDetails()
        setUpLocalizedStrings()
        //        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantDetails, object: nil)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        webservicePostRestaurantDetails()
    }
    override func btnBackAction() {
        if isFromFoodlist{
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
            controller.selectedIndex = 0
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBar.isHidden = true
            appDel.window?.rootViewController = nav
        }else{
            super.btnBackAction()
        }
    }
    // MARK: - Other Methods
    func registerNIB(){
        tblPopup.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblPopup.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
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
            if objRestaurant.distance != "0 Miles"{
                self.lblDistance.isHidden = false
                self.lblDistance.text =  objRestaurant.distance
            }else{
                self.lblDistance.isHidden = true
            }
            self.lblAddress.text = objRestaurant.address ?? ""
            self.lblEastern.text = objRestaurant.timeZone
            self.lblTime.text = "\(objRestaurant.fromTime ?? "")"
            self.lblCompleteTime.text = "\(objRestaurant.toTime ?? "")"
            lblAboutRestaurant.delegate = self
            lblAboutRestaurant.ellipsis = NSAttributedString(string: "...")
            lblAboutRestaurant.font = CustomFont.NexaRegular.returnFont(13)
            lblAboutRestaurant.tintColor = UIColor(hexString: "#1C1C1C")
            self.LblClosed.isHidden = objRestaurant.is_close == "0"
            self.Lbloperatingdays.text = objRestaurant.days
          
            let myAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: "#E34A25"),NSAttributedString.Key.font: CustomFont.NexaBold.returnFont(12),NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue] as [NSAttributedString.Key : Any]
            let viewMoreString = NSAttributedString(string: "View More", attributes: myAttribute)
            let viewLessString = NSAttributedString(string: "View Less", attributes: myAttribute)

           
            
            lblAboutRestaurant.collapsedAttributedLink = viewMoreString
            lblAboutRestaurant.expandedAttributedLink = viewLessString
     
            lblAboutRestaurant.shouldCollapse = true
            lblAboutRestaurant.textReplacementType = .word
            lblAboutRestaurant.numberOfLines = 5
            lblAboutRestaurant.collapsed = true
            
            lblAboutRestaurant.text = objRestaurant?.descriptionField ?? ""
//            self.lblAboutRestaurant.text = objRestaurant.descriptionField ?? ""
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
        ViewForAddItem.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        self.ViewForAddItem.clipsToBounds = true
        //        self.calculateTableHeight()
    }
    
    func addVeriantincart(veriantid: String) {
        print(veriantid)
    }
    
    
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        if objRestaurant != nil{
            if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
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
        controller.strNavTitle = "View Store Policy"// "NavigationTitles_Privacypolicy".Localized()
        controller.strStorePolicy = objRestaurant.storePolicy
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BtnRattingsAndReviews(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantReviewVC.storyboardID) as! RestaurantReviewVC
        controller.strRestaurantId = selectedRestaurantId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnCloseTap(_ sender: Any) {
        self.HidePopUp()
    }
    @IBAction func btnAddNewClick(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "BffComboVC") as! BffComboVC
        vc.selectedItemId = strItemId
        vc.selectedRestaurantId = objRestaurant.id
        self.HidePopUp()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewCart(_ sender: Any) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
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
        if tableView == tblRestaurantDetails{
            return arrMenuitem.count > 0 ? arrFoodMenu.count + 1 : arrFoodMenu.count
        }else{
            return 1
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
    //MARK: - skeletontableview datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrItemList.count > 0 ? RestaurantDetailsPopupCell.reuseIdentifier : ShimmerCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblRestaurantDetails{
            return self.setRowCount(section: section)
        }else{
            if responseStatus == .gotData{
                if arrItemList.count != 0 {
                    return self.arrItemList.count
                }else{
                    return 1
                }
            }else{
                return 1
            }
        }
        
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
                        if variantValue > 0 && self.arrMenuitem[indexPath.row].totalvariant.toInt() > 1{
                            if variantValue > 0{
                                self.arrItemList = [ItemList]()
                                self.tblPopup.showAnimatedSkeleton()
                                self.tblPopup.reloadData()
                                self.ViewForBottom.constant = 0
                                self.viewPopup.layoutIfNeeded()
                                self.viewPopup.layoutSubviews()
                                self.viewBG.isHidden = false
                                self.viewPopup.isHidden = false
                                UIView.animate(withDuration: 0.6, animations: {
                                }){ (success) in
                                    self.isfromMenu = true
                                    self.webserviceItemList(strItemId: self.arrMenuitem[indexPath.row].id)
                                    self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                                }
                            }else{
                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                                self.isfromMenu = true
                                self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                                cell.stackHide.isHidden = true
                                self.activityView.center = cell.vwStapper.center
                                cell.vwStapper.addSubview(self.activityView)
                                self.activityView.startAnimating()
                            }
                        }else{
                            self.isfromMenu = true
                            self.viewPopup.isHidden = true
                            self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.IncreseData = {
                        
                        if variantValue > 0{
                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                            controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                            controller.selectedRestaurantId = self.objRestaurant.id
                            controller.isFromRestaurant = true
                            controller.delegateAddVariant = self
                            self.strItemId = self.arrMenuitem[indexPath.row].id
                            self.navigationController?.pushViewController(controller, animated: true)
                        }else{
                            let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                            if self.arrMenuitem[indexPath.row].quantity > value {
                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                                self.isfromMenu = true
                                self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                                cell.stackHide.isHidden = true
                                self.activityView.center = cell.vwStapper.center
                                cell.vwStapper.addSubview(self.activityView)
                                self.activityView.startAnimating()
                            }else{
                                Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
                            }
                        }
                    }
                    if variantValue > 0{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.btnAddAction = {
                        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
                            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
                            let navController = UINavigationController.init(rootViewController: vc)
                            navController.modalPresentationStyle = .overFullScreen
                            navController.navigationController?.modalTransitionStyle = .crossDissolve
                            navController.navigationBar.isHidden = true
                            SingletonClass.sharedInstance.isPresented = true
                            self.present(navController, animated: true, completion: nil)
                        }else{
                            if self.objRestaurant.isdiff == 0{
                                let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                                let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                    if self.arrMenuitem[indexPath.row].quantity > 1 && variantValue > 0{
                                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                                        controller.selectedRestaurantId = self.objRestaurant.id
                                        controller.isFromRestaurant = true
                                        controller.delegateAddVariant = self
                                        self.strItemId = self.arrMenuitem[indexPath.row].id
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }else{
                                        let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                        if self.arrMenuitem[indexPath.row].quantity > value {
                                            cell.btnAddItem.isHidden = true
                                            cell.vwStapper.isHidden = false
                                            self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                            cell.stackHide.isHidden = true
                                            self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                            cell.vwStapper.addSubview(self.activityView)
                                            self.activityView.startAnimating()
                                        }else{
                                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
                                        }
                                    }
                                }
                                let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                                alert.addAction(yesAction)
                                alert.addAction(NoAction)
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if self.arrMenuitem[indexPath.row].quantity > 1 && variantValue > 0{
                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                    controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                                    controller.isFromRestaurant = true
                                    controller.selectedRestaurantId = self.objRestaurant.id
                                    controller.delegateAddVariant = self
                                    self.strItemId = self.arrMenuitem[indexPath.row].id
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }else{
                                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                    if self.arrMenuitem[indexPath.row].quantity > value {
                                        cell.btnAddItem.isHidden = true
                                        cell.vwStapper.isHidden = false
                                        self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                        cell.stackHide.isHidden = true
                                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                        cell.vwStapper.addSubview(self.activityView)
                                        self.activityView.startAnimating()
                                    }else{
                                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
                                    }
                                }
                            }
                        }
                    }
                    
                    cell.customize = {
                        if self.objRestaurant.isdiff == 0{
                            let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                                controller.selectedRestaurantId = self.objRestaurant.id
                                controller.delegateAddVariant = self
                                self.strItemId = self.arrMenuitem[indexPath.row].id
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            alert.addAction(NoAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                            controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                            controller.selectedRestaurantId = self.objRestaurant.id
                            controller.delegateAddVariant = self
                            self.strItemId = self.arrMenuitem[indexPath.row].id
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
                    let variantValue = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant.ToDouble()
                    cell.lblItemName.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name.trimmingCharacters(in: .whitespacesAndNewlines)
                    cell.lblItemPrice.text = "\(CurrencySymbol)" + arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.ConvertToTwoDecimal()
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].image ?? "")"
                    cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.lblNoOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
                    cell.lblAboutItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].Description
                    cell.btnAddItem.isHidden = false
                    cell.vwStapper.isHidden = true
                    cell.stackHide.isHidden = false
                    self.activityView.stopAnimating()
                    if indexPath.section == 1 && indexPath.row == 0{
                        if objRestaurant.foodType == 1{
                            cell.vwRadius.cornerRadius = 5
                            cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
                            cell.vwRadius.layer.borderWidth = 1
                        }else{
                            cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
                        }
                    }else{
                        cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
                    }
                    if Int(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
                        cell.btnAddItem.isHidden = true
                        cell.vwStapper.isHidden = false
                    }
                    
                    if arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant == "1"{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.decreaseData = { [self] in
                        if variantValue > 0 && self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].totalvariant.toInt() > 1{
                            if variantValue > 0{
                                self.arrItemList = [ItemList]()
                                self.tblPopup.showAnimatedSkeleton()
                                self.tblPopup.reloadData()
                                self.ViewForBottom.constant = 0
                                self.viewPopup.layoutIfNeeded()
                                self.viewPopup.layoutSubviews()
                                self.viewBG.isHidden = false
                                self.viewPopup.isHidden = false
                                UIView.animate(withDuration: 0.6, animations: {
                                    //                                self.view.layoutIfNeeded()
                                }){ (success) in
                                    self.isfromMenu = false
                                    self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId)
                                    self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                                }
                            }else{
                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                                self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                                self.isfromMenu = false
                                cell.stackHide.isHidden = true
                                self.activityView.center = cell.vwStapper.center
                                cell.vwStapper.addSubview(self.activityView)
                                self.activityView.startAnimating()
                            }
                        }else{
                            self.isfromMenu = false
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.IncreseData = {
                        if variantValue > 0{
                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                            controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                            controller.isFromRestaurant = true
                            controller.selectedRestaurantId = self.objRestaurant.id
                            controller.delegateAddVariant = self
                            self.strItemId = self.arrMenuitem[indexPath.row].id
                            self.navigationController?.pushViewController(controller, animated: true)
                        }else{
                            let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                            if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                            self.isfromMenu = false
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                            }else{
                                Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
                            }
                        }
                    }
                    cell.btnAddAction = {
                        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
                            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
                            let navController = UINavigationController.init(rootViewController: vc)
                            navController.modalPresentationStyle = .overFullScreen
                            navController.navigationController?.modalTransitionStyle = .crossDissolve
                            navController.navigationBar.isHidden = true
                            SingletonClass.sharedInstance.isPresented = true
                            self.present(navController, animated: true, completion: nil)
                        }else{
                            if self.objRestaurant.isdiff == 0{
                                let alert = UIAlertController(title: "Adelante System", message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                                let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                    if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
                                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                        controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                                        controller.selectedRestaurantId = self.objRestaurant.id
                                        controller.isFromRestaurant = true
                                        controller.delegateAddVariant = self
                                        self.strItemId = self.arrMenuitem[indexPath.row].id
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }else{
                                        let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                        if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
                                            cell.btnAddItem.isHidden = true
                                            cell.vwStapper.isHidden = false
                                            self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                            cell.stackHide.isHidden = true
                                            self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                            cell.vwStapper.addSubview(self.activityView)
                                            self.activityView.startAnimating()
                                        }else{
                                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
                                        }
                                    }
                                }
                                let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                                alert.addAction(yesAction)
                                alert.addAction(NoAction)
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                    controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                                    controller.selectedRestaurantId = self.objRestaurant.id
                                    controller.isFromRestaurant = true
                                    controller.delegateAddVariant = self
                                    self.strItemId = self.arrMenuitem[indexPath.row].id
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }else{
                                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                    if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
                                        cell.btnAddItem.isHidden = true
                                        cell.vwStapper.isHidden = false
                                        self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                        cell.stackHide.isHidden = true
                                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                        cell.vwStapper.addSubview(self.activityView)
                                        self.activityView.startAnimating()
                                    }else{
                                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
                                    }
                                }
                            }
                        }
                    }
                    if variantValue > 0{
                        cell.btnCustomize.isHidden = false
                    }else{
                        cell.btnCustomize.isHidden = true
                    }
                    cell.customize = {
                        if self.objRestaurant.isdiff == 0{
                            let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                                controller.selectedRestaurantId = self.objRestaurant.id
                                controller.delegateAddVariant = self
                                self.strItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            alert.addAction(NoAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                            controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                            controller.selectedRestaurantId = self.objRestaurant.id
                            controller.delegateAddVariant = self
                            self.strItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
                let variantValue = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant.ToDouble()
                cell.lblItemName.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].name
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrFoodMenu[indexPath.section].subMenu[indexPath.row].image ?? "")"
                cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.lblAboutItem.text = arrFoodMenu[indexPath.row].subMenu[indexPath.row].Description
                cell.lblItemPrice.text = CurrencySymbol + arrFoodMenu[indexPath.section].subMenu[indexPath.row].price
//                cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].size
                cell.lblNoOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty
                cell.btnAddItem.isHidden = false
                cell.vwStapper.isHidden = true
                cell.stackHide.isHidden = false
                self.activityView.stopAnimating()
                if Int(arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
                    cell.btnAddItem.isHidden = true
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
                    if variantValue > 0 && self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].totalvariant.toInt() > 1{
                        if variantValue > 0{
                            self.arrItemList = [ItemList]()
                            self.tblPopup.showAnimatedSkeleton()
                            self.tblPopup.reloadData()
                            self.ViewForBottom.constant = 0
                            self.viewPopup.layoutIfNeeded()
                            self.viewPopup.layoutSubviews()
                            self.viewBG.isHidden = false
                            self.viewPopup.isHidden = false
                            UIView.animate(withDuration: 0.6, animations: {
                                //                                self.view.layoutIfNeeded()
                            }){ (success) in
                                self.isfromMenu = false
                                self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId)
                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            }
                        }else{
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                            self.isfromMenu = false
                            cell.stackHide.isHidden = true
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }else{
                        self.isfromMenu = false
                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                        cell.stackHide.isHidden = true
                        self.activityView.center = cell.vwStapper.center
                        cell.vwStapper.addSubview(self.activityView)
                        self.activityView.startAnimating()
                    }
                }
                cell.IncreseData = { [self] in
                    if variantValue > 0{
                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
                        controller.selectedRestaurantId = self.objRestaurant.id
                        controller.isFromRestaurant = true
                        controller.delegateAddVariant = self
                        self.strItemId = self.arrMenuitem[indexPath.row].id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }else{
                        let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                        if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                            cell.stackHide.isHidden = true
                            self.isfromMenu = false
                            self.activityView.center = cell.vwStapper.center
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }else{
                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
                        }
                    }
                }
                if variantValue > 0{
                    cell.btnCustomize.isHidden = false
                }else{
                    cell.btnCustomize.isHidden = true
                }
                cell.btnAddAction = {
                    if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
                        let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
                        let navController = UINavigationController.init(rootViewController: vc)
                        navController.modalPresentationStyle = .overFullScreen
                        navController.navigationController?.modalTransitionStyle = .crossDissolve
                        navController.navigationBar.isHidden = true
                        SingletonClass.sharedInstance.isPresented = true
                        self.present(navController, animated: true, completion: nil)
                    }else{
                        if self.objRestaurant.isdiff == 0{
                            let alert = UIAlertController(title: "Adelante System", message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                                if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > 1 && variantValue > 0 {
                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                    controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                                    controller.selectedRestaurantId = self.objRestaurant.id
                                    controller.isFromRestaurant = true
                                    controller.delegateAddVariant = self
                                    self.strItemId = self.arrMenuitem[indexPath.row].id
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }else{
                                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                    if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
                                        cell.btnAddItem.isHidden = true
                                        cell.vwStapper.isHidden = false
                                        self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                        cell.stackHide.isHidden = true
                                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                        cell.vwStapper.addSubview(self.activityView)
                                        self.activityView.startAnimating()
                                    }else{
                                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
                                    }
                                }
                            }
                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            alert.addAction(NoAction)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                                controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                                controller.selectedRestaurantId = self.objRestaurant.id
                                controller.isFromRestaurant = true
                                controller.delegateAddVariant = self
                                self.strItemId = self.arrMenuitem[indexPath.row].id
                                self.navigationController?.pushViewController(controller, animated: true)
                            }else{
                                let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                                if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
                                    cell.btnAddItem.isHidden = true
                                    cell.vwStapper.isHidden = false
                                    self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
                                    cell.stackHide.isHidden = true
                                    self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
                                    cell.vwStapper.addSubview(self.activityView)
                                    self.activityView.startAnimating()
                                }else
                                {
                                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
                                }
                            }
                        }
                    }
                    
                }
                
                cell.customize = {
                    if self.objRestaurant.isdiff == 0{
                        let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
                        let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                            controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                            controller.selectedRestaurantId = self.objRestaurant.id
                            controller.delegateAddVariant = self
                            self.strItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                        let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
                        alert.addAction(yesAction)
                        alert.addAction(NoAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                        controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                        controller.selectedRestaurantId = self.objRestaurant.id
                        controller.delegateAddVariant = self
                        self.strItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }else{
            if responseStatus == .gotData{
                if arrItemList.count != 0 {
                    let cell:RestaurantDetailsPopupCell = tblPopup.dequeueReusableCell(withIdentifier: RestaurantDetailsPopupCell.reuseIdentifier) as! RestaurantDetailsPopupCell
                    cell.lblItemName.text = arrItemList[indexPath.row].itemName
                    cell.lblPrice.text = "\(CurrencySymbol)" + "\(arrItemList[indexPath.row].subTotal ?? 0)"
                    cell.lblDesc.text = arrItemList[indexPath.row].descriptionField
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrItemList[indexPath.row].itemImg ?? "")"
                    cell.imgRestDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.lblNoOfItem.text = arrItemList[indexPath.row].qty
                    cell.stackHide.isHidden = false
                    self.strItemId = arrItemList[indexPath.row].id
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
                    }
                    cell.decreaseData = {
                        self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                        cell.stackHide.isHidden = true
                        self.activityView.center = cell.vwStapper.center
                        cell.vwStapper.addSubview(self.activityView)
                        self.activityView.startAnimating()
                    }
                    cell.btnAddAction = {
                        if self.arrItemList[indexPath.row].quantity.ToDouble() > 1 {
                            cell.btnAdd.isHidden = true
                            cell.vwStapper.isHidden = false
                            self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "1",row: indexPath.row)
                            cell.stackHide.isHidden = true
                            self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 10, y: cell.vwStapper.frame.height/2)
                            cell.vwStapper.addSubview(self.activityView)
                            self.activityView.startAnimating()
                        }
                    }
                    cell.selectionStyle = .none
                    return cell
                    
                }else{
                    let cell = tblPopup.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                let cell = tblPopup.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblRestaurantDetails{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 48))
            headerView.backgroundColor = .white
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 14, width: headerView.frame.width-40, height: 60)
            label.center.y = headerView.frame.size.height / 2
            
            label.font = CustomFont.NexaBold.returnFont(20)
            label.textColor = colors.black.value
            headerView.addSubview(label)
            if arrMenuitem.count > 0 {
                if section == 0 {
                    label.text = "RestaurantDetailsVC_arrSection".Localized()
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
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
            if arrMenuitem.count > 0 {
                if section == 0{
                    return 60
                }else{
                    return 48
                }
            }else{
                return 48
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblRestaurantDetails{
            return UITableView.automaticDimension
        }else{
            if responseStatus == .gotData{
                if arrItemList.count != 0 {
                    return UITableView.automaticDimension
                }else{
                    return 131
                }
            }else {
                return self.responseStatus == .gotData ?  230 : 131
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 1))
        footerView.backgroundColor = UIColor(hexString: "#707070").withAlphaComponent(0.2)
        return footerView
    }
    //Expandeble label
    func willExpandLabel(_ label: ExpandableLabel) {
        if label == lblAboutRestaurant {
            lblAboutRestaurant.numberOfLines = 0
            lblAboutRestaurant.collapsed = false
        }
        
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        if label == lblAboutRestaurant {
            
        } else {
            
        }
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        if label == lblAboutRestaurant {
            lblAboutRestaurant.numberOfLines = 5
            lblAboutRestaurant.collapsed = true
        } else {
            
        }
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        if label == lblAboutRestaurant {
            
        } else {
           
        }
        
    }
    // MARK: - Api Calls
    func webservicePostRestaurantDetails(){
        let ResDetails = RestaurantDetailsReqModel()
        ResDetails.restaurant_id = selectedRestaurantId
        ResDetails.page = "\(pageNumber)"
        ResDetails.user_id = SingletonClass.sharedInstance.UserId
        ResDetails.lat = "\(SingletonClass.sharedInstance.userDefaultLocation.coordinate.latitude)"
        ResDetails.lng = "\(SingletonClass.sharedInstance.userDefaultLocation.coordinate.longitude)"
        ResDetails.search = SearchData
        WebServiceSubClass.RestaurantDetails(RestaurantDetailsmodel: ResDetails, showHud: false, completion: { (response, status, error) in
            if status {
                let RestDetail = RestaurantDetailsResModel.init(fromJson: response)
                self.skeletonViewData.removeFromSuperview()
                self.skeletonViewData.stopShimmering()
                self.skeletonViewData.stopSkeletonAnimation()
                self.arrMenuitem = RestDetail.data.restaurant.menuItem
                self.arrFoodMenu = RestDetail.data.restaurant.foodMenu
                self.objRestaurant = RestDetail.data.restaurant
                self.tblRestaurantDetails.reloadData()
                self.setData()
            } else {
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
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
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
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
                tblPopup.reloadData()
            } else {
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        }
    }
    func HidePopUp() {
        self.ViewForBottom.constant = -(self.viewPopup.frame.size.height + tblPopup.contentSize.height)
        self.viewPopup.layoutIfNeeded()
        self.viewPopup.layoutSubviews()
        self.viewBG.isHidden = true
        self.viewPopup.isHidden = true
        UIView.animate(withDuration: 1.5, animations: {
            self.view.layoutIfNeeded()
        }){ (success) in
            
        }
        
    }
    //MARK : - update quantity
    func webserviceUpdateCartQuantity(strItemid:String,strQty:String,strType:String,row:Int, PromocodeRemove: String = ""){
        let updateCart = UpdateCardQtyReqModel()
        updateCart.cart_item_id = strItemid
        updateCart.qty = strQty
        updateCart.type = strType
        updateCart.search = SearchData
        updateCart.status = "0"
        updateCart.promocode_remove = PromocodeRemove
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: false){ [self] (json, status, response) in
            
            if(status)
            {
                let cartData = updateCartResModel.init(fromJson: json)
                if cartData.is_added == "0"{
                    Utilities.displayAlert(cartData.message)
                    
                }
                self.arrUpdateQty = cartData.data
                self.arrFoodMenu = cartData.restaurant.foodMenu
                self.arrMenuitem = cartData.restaurant.menuItem
                //                self.arrItemList = cartData.data
                
                let index = IndexPath(row: row, section:0)
                
                if self.arrUpdateQty == nil {
                    self.HidePopUp()
                    self.checkItemsAndUpdateFooter(Qty: "0", Total: "0")
                }else{
                    self.checkItemsAndUpdateFooter(Qty: self.arrUpdateQty.totalQuantity, Total: self.arrUpdateQty.total)
                    if self.isfromMenu == false {
                        if self.arrFoodMenu[selectedIndexItem.section].subMenu[selectedIndexItem.row].variant == "1"{
                            let cell = self.tblPopup.cellForRow(at: index) as! RestaurantDetailsPopupCell
                            
                            if (cell.lblNoOfItem.text?.toInt())! <= 1 && strType == "0"{
                                self.HidePopUp()
                            }
                            self.arrItemList.removeAll()
                            self.arrItemList.append(contentsOf: self.arrUpdateQty.item.filter { (item) -> Bool in
                                return item.id == arrMenuitem[selectedIndexItem.row].id
                            })
                            self.tblPopup.reloadData()
                            cell.stackHide.isHidden = false
                            self.activityView.stopAnimating()
                        }
                    }else{
                        let variantValue = arrMenuitem[selectedIndexItem.row].variant.ToDouble()
                        if variantValue > 0 && arrMenuitem[selectedIndexItem.row].totalvariant.toInt() > 1{
                            if variantValue > 0{
                                let cell = self.tblPopup.cellForRow(at: index) as! RestaurantDetailsPopupCell
                                if (cell.lblNoOfItem.text?.toInt())! <= 1 && strType == "0"{
                                    cell.vwStapper.isHidden = true
                                    cell.btnAdd.isHidden = false
                                    if index.row >= 0{
                                        arrItemList.remove(at: index.row)
                                        tblPopup.deleteRows(at: [index], with: .fade)
                                    }else{
                                        HidePopUp()
                                    }
                                }
                                self.arrItemList.removeAll()
                                self.arrItemList.append(contentsOf: self.arrUpdateQty.item.filter { (item) -> Bool in
                                    return item.id == arrMenuitem[selectedIndexItem.row].id
                                })
                                self.tblPopup.reloadData()
                                cell.stackHide.isHidden = false
                                self.activityView.stopAnimating()
                            }else{
                                
                            }
                        }else{
                            if self.viewPopup.isHidden == true{
                                self.tblRestaurantDetails.reloadData()
                            }else{
                                if variantValue > 0{
                                    let cell = self.tblPopup.cellForRow(at: index) as! RestaurantDetailsPopupCell
                                    if (cell.lblNoOfItem.text?.toInt())! <= 1 && strType == "0"{
                                        cell.vwStapper.isHidden = true
                                        cell.btnAdd.isHidden = false
                                        if index.row >= 0{
                                            arrItemList.remove(at: index.row)
                                            tblPopup.deleteRows(at: [index], with: .fade)
                                        }else{
                                            cell.btnAdd.isHidden = false
                                            HidePopUp()
                                        }
                                    }
                                    self.arrItemList.removeAll()
                                    self.arrItemList.append(contentsOf: self.arrUpdateQty.item.filter { (item) -> Bool in
                                        return item.id == arrMenuitem[selectedIndexItem.row].id
                                    })
                                    self.tblPopup.reloadData()
                                    cell.stackHide.isHidden = false
                                    self.activityView.stopAnimating()
                                }
                            }
                        }
                    }
                }
                self.tblRestaurantDetails.reloadData()
            }else{
                
                if json["promocode_popup"].stringValue == "1"{
                    Utilities.showAlertWithTitleFromWindow(title: AppInfo.appName, andMessage: json["message"].stringValue, buttons: ["Ok","Cancel"]) { index in
                        if index == 0{
                            self.webserviceUpdateCartQuantity(strItemid: strItemid, strQty: strQty, strType: strType, row: row, PromocodeRemove: "1")
                        }else{
                            self.webservicePostRestaurantDetails()
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
    func webserviceItemList(strItemId:String){
        let itemlist = ItemListReqModel()
        itemlist.item_id = strItemId
        itemlist.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.itemList(itemListModel: itemlist, showHud: false){ (json, status, response) in
            self.responseStatus = .gotData
            let cell = self.tblPopup.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
            cell.stopShimmering()
            self.tblPopup.stopSkeletonAnimation()
            if(status)
            {
                print(json)
                let itemListData = ItemListResModel.init(fromJson: json)
                self.arrItemList = itemListData.data.item
//                let tempArr =  self.arrItemList.filter({ (item) -> Bool in
//                    return item.qty.toInt() != 0
//                })
                self.tblPopup.dataSource = self
                self.tblPopup.isScrollEnabled = true
                self.tblPopup.isUserInteractionEnabled = true
                self.tblPopup.reloadData()
                self.setData()
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
    func webserviceGetSettings(){
        
        WebServiceSubClass.Settings(showHud: true, completion: { (json, status, response) in
            if(status)
            {
                self.SettingsData = SettingsResModel.init(fromJson: json)
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
                controller.strNavTitle = "View Store Policy"//"NavigationTitles_Privacypolicy".Localized()
                controller.strUrl = self.SettingsData.privacyPolicy
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
}

