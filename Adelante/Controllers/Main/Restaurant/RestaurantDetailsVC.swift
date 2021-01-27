//
//  RestaurantDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
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
protocol FavoriteUpdateDelegate {
    func refreshRestaurantFavorite()
}

class RestaurantDetailsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Properties
    var delegateFavoprite : FavoriteUpdateDelegate!
    var customTabBarController: CustomTabBarVC?
    var arrSections = [structSections(strTitle:"RestaurantDetailsVC_arrSection".Localized(),isExpanded:false, rowCount: 3), structSections(strTitle:"RestaurantDetailsVC_arrSection1".Localized(),isExpanded:true, rowCount: 5), structSections(strTitle:"RestaurantDetailsVC_arrSection2".Localized(),isExpanded:false, rowCount: 2)] //["Menu","Sandwiches","Salad"]
    var selectedRestaurantId = ""
    var arrMenuitem = [MenuItem]()
    var arrFoodMenu = [FoodMenu]()
    var arrSubMenu = [SubMenu]()
    var objRestaurant : Restaurantinfo!
    var SelectedCatId = ""
    var pageNumber = "1"
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
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        webservicePostRestaurantDetails()
        setUpLocalizedStrings()
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
        //        btnNavLike.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        //        btnNavLike.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
        
    }
    func setUpLocalizedStrings(){
        lblRestaurantName.text = "RestaurantDetailsVC_lblRestaurantName".Localized()
        lblRating.text = "4.2"
        lblReviews.text = String(format: "RestaurantDetailsVC_lblReviews".Localized(), "53")
        lblPromoCode.text = "RestaurantDetailsVC_lblPromoCode".Localized()
        lblCode.text = "RestaurantDetailsVC_lblCode".Localized()
        lblDistance.text = String(format: "RestaurantDetailsVC_lblDistance".Localized(), "1.7")
        lblAddress.text = "43369 Ellsworth St, remont,CA";
        lblOpenTime.text = "RestaurantDetailsVC_lblOpenTime".Localized()
        lblTime.text = "RestaurantDetailsVC_lblTime".Localized()
        lblTimeZone.text = "RestaurantDetailsVC_lblTimeZone".Localized()
        lblEastern.text = "RestaurantDetailsVC_lblEastern".Localized()
        lblAboutRestaurant.text = "RestaurantDetailsVC_lblAboutRestaurant".Localized()
        btnViewPolicy.setTitle("RestaurantDetailsVC_btnViewPolicy".Localized(), for: .normal)
        lblNoOfItem.text = String(format: "RestaurantDetailsVC_lblNoOfItem".Localized(), "1")
        lblSign.text = "RestaurantDetailsVC_lblSign".Localized()
        lblPrice.text = "$30"
        lblViewCards.text = "RestaurantDetailsVC_lblViewCart".Localized()
    }
    func setData(){
        if objRestaurant != nil{
            self.lblRestaurantName.text = objRestaurant.name ?? ""
            self.lblPrice.text = objRestaurant.name ?? ""
            self.lblRating.text = objRestaurant.rating ?? ""
            self.lblReviews.text = String(format: "RestaurantReviewVC_lblReviews".Localized(), objRestaurant.review)
            //            self.lblTimeZone.text = objRestaurant.
            self.lblDistance.text = String(format: "HomeVC_RestaurantCell_lblMiles".Localized(), objRestaurant.distance)
            self.lblAddress.text = objRestaurant.address ?? ""
            if objRestaurant.promocode == ""{
                stackPromocode.isHidden = true
            }else{
                stackPromocode.isHidden = false
            }
            self.lblCode.text = objRestaurant.promocode ?? ""
            self.lblTime.text = objRestaurant.fromTime ?? ""
            self.lblCompleteTime.text = objRestaurant.toTime ?? ""
            self.lblAboutRestaurant.text = objRestaurant.descriptionField ?? ""
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(objRestaurant.image ?? "")"
            self.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        }
    }
    override func viewDidLayoutSubviews() {
//         heightTblRestDetails.constant = tblRestaurantDetails.contentSize.height + 50
    }
    
    // MARK: - IBActions
    //    @IBAction func buttonTapFavorite(_ sender: UIButton) {
    ////        var Select = arrResDetail[].favourite ?? ""
    ////        let restaurantId = arrResDetail[sender.tag].id ?? ""
    ////        if Select == "1"{
    ////            Select = "0"
    ////        }else{
    ////            Select = "1"
    ////        }
    ////        webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
    //        if btnNavLike.isSelected{
    //            btnNavLike.isSelected = false
    //        }else{
    //            btnNavLike.isSelected = true
    //        }
    //    }
    @IBAction func btnViewPolicy(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
        controller.strNavTitle = "NavigationTitles_Privacypolicy".Localized()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BtnRattingsAndReviews(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantReviewVC.storyboardID) as! RestaurantReviewVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func buttonAdd(_ sender: UIButton) {
        
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
        for i in 0..<arrSections.count {
            if sender.tag != 0 {
                if sender.tag == i {
                    if arrSections[i].isExpanded == true {
                        arrSections[i].isExpanded = false
                        break
                    } else {
                        arrSections[i].isExpanded = true
                    }
                } else {
                    arrSections[i].isExpanded = false
                }
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
        if section == 0 {
            return arrMenuitem.count
        }
        return arrFoodMenu[section - 1].subMenu.count
//        return arrSections[section].isExpanded == true ? arrSections[section].rowCount : 0
//        if section == 0 {
//            return arrSections[section].rowCount
//        }
//        return arrSections[section].isExpanded == true ? arrSections[section].rowCount : 0
    }
    func setRowCount(section : Int) -> Int{
        var rowCount = 0
        if section == 0{
            if arrMenuitem.count > 0{
                rowCount = arrMenuitem.count
            }else{
                rowCount = arrFoodMenu[section].subMenu.c
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:RestaurantDetailsCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantDetailsCell", for: indexPath)as! RestaurantDetailsCell
            cell.lblItemName.text = arrMenuitem[indexPath.row].name
            cell.lblItemPrice.text = arrMenuitem[indexPath.row].price
            cell.lblAboutItem.text = arrMenuitem[indexPath.row].descriptionField
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrMenuitem[indexPath.row].image ?? "")"
            cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            cell.selectionStyle = .none
            //            cell.
            cell.customize = {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
            cell.lblItem.text = arrFoodMenu[indexPath.row].categoryName
            cell.lblItemPrice.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price
            cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].size
            cell.btnAdd.addTarget(self, action: #selector(buttonAdd(_:)), for: .touchUpInside)
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
        
        if section != 0 {
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
            label.text = arrFoodMenu[section - 1].categoryName
            
        }
        else{
            label.text = "RestaurantDetailsVC_arrSection".Localized()
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
    
    // MARK: - Api Calls
    func webservicePostRestaurantDetails(){
        let ResDetails = RestaurantDetailsReqModel()
        ResDetails.restaurant_id = selectedRestaurantId
        ResDetails.page = "\(pageNumber)"
        WebServiceSubClass.RestaurantDetails(RestaurantDetailsmodel: ResDetails, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let RestDetail = RestaurantDetailsResModel.init(fromJson: response)
                self.arrMenuitem = RestDetail.data.restaurant.menuItem
                self.arrFoodMenu = RestDetail.data.restaurant.foodMenu
//                self.arrSubMenu = RestDetail.data.restaurant.
                self.objRestaurant = RestDetail.data.restaurant
                self.tblRestaurantDetails.reloadData()
                self.heightTblRestDetails.constant = self.tblRestaurantDetails.contentSize.height + 150
                self.setData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            //            if self.arrMenuitem.count > 0{
            //                self.tblRestaurantDetails.restore()
            //            }else {
            //                self.tblRestaurantDetails.setEmptyMessage("emptyMsg_Restaurant".Localized())
            //            }
        })
    }
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: true, completion: { (response, status, error) in
            //            self.hideHUD()
            if status{
                self.webservicePostRestaurantDetails()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}

