//
//  BffComboVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SkeletonView

class SelectedVarient {
    
    var onTotalUpdated: ((_ amount: Double) -> Void)?
    
    var array: [Option] = []
    
    func add(_ varient: Option) {
        array.append(varient)
    }
    
    func remove(_ varient: Option) {
        array.removeAll(where: {$0.id == varient.id})
    }
    
    func manage(_ verient: Option) {
        if verient.isSelected {
            add(verient)
        } else {
            remove(verient)
        }
        onTotalUpdated?(totalAmount)
    }
    
    var totalAmount: Double {
        return array.map({$0.doublePrice}).reduce(0, +)
    }
}

protocol AddveriantDelegate {
    func addVeriantincart(veriantid:String)
}

class BffComboVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,SkeletonTableViewDataSource {
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var responseStatus : webserviceResponse = .initial
    var selectedcategory = 0
    var selectedSection = 0
    var expendedCell = -1
    var selectedRestaurantId = ""
    var selectedItemId = ""
    var refreshList = UIRefreshControl()
    var arrVariants : [Variant]?
    var total = Int()
    //    var objCurrentOrder : currentOrder?
    var arrSelectedVariants = [selectedVariants]()
    var arrselectedId = [String]()
    var delegateAddVariant : AddveriantDelegate!
    var selectedOption = SelectedVarient()
    var TotalItemPrice = Int()
    var itemBasePrice = Double()
    var isFromRestaurant : Bool = false
    // MARK: - IBOutlets
    
    @IBOutlet weak var tblBFFCombo: UITableView!{
        didSet{
            tblBFFCombo.isSkeletonable = true
        }
    }
    @IBOutlet weak var lblItem: themeLabel!
    @IBOutlet weak var lblTotal: themeLabel!
    @IBOutlet weak var lblSign: themeLabel!
    @IBOutlet weak var lblViewCart: themeLabel!
    @IBOutlet weak var btnViewCart: UIButton!
    @IBOutlet weak var viewFooter: UIView!
    var isFromWebservice = false
    
    // MARK: - ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        // self.customTabBarController?.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        tblBFFCombo.showAnimatedSkeleton()
        tblBFFCombo.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webservicePostCombo), for: .valueChanged)
        setUpLocalizedStrings()
        //        objCurrentOrder = SingletonClass.sharedInstance.restCurrentOrder
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblBFFCombo.frame.size.width, height: 31)
        tblBFFCombo.tableFooterView = footerView
        webservicePostCombo()
        checkItemsAndUpdateFooter()
        setup()
        
        selectedOption.onTotalUpdated = { [unowned self] amount in
            self.lblItem.text = CurrencySymbol + "\(amount+itemBasePrice)"
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.BffComboVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    func setUpLocalizedStrings(){
        //        lblItem.text = "BffComboVC_lblItem".Localized()
        lblViewCart.text = "BffComboVC_lblViewCart".Localized()
    }
    func registerNIB(){
        tblBFFCombo.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblBFFCombo.register(UINib(nibName:"BffComboShimmerCell", bundle: nil), forCellReuseIdentifier: "BffComboShimmerCell")
    }
    func checkandUpdateVariants() {
        self.arrSelectedVariants.removeAll()
        self.arrselectedId.removeAll()
        if (self.arrVariants?.count ?? 0) > 0 {
            for i in 0..<(self.arrVariants?.count ?? 0) {
                for j in 0..<(self.arrVariants?[i].option.count ?? 0) {
                    if self.arrVariants?[i].option[j].isSelected == true {
                        let dicTemp = selectedVariants.init(variant_id: self.arrVariants?[i].option[j].variantId ?? "", variant_option_id: self.arrVariants?[i].option[j].id ?? "", variant_name: self.arrVariants?[i].option[j].variantName ?? "", variant_SubName: self.arrVariants?[i].option[j].name ?? "", variant_price: self.arrVariants?[i].option[j].price ?? "", isMultiSelect: self.arrVariants?[i].option[j].menuChoice == "0" ? false : true)
                        self.arrSelectedVariants.append(dicTemp)
                    }
                }
            }
        }
        print("\(self.arrSelectedVariants.count)")
        if self.arrSelectedVariants.count > 0 {
            for i in 0..<arrSelectedVariants.count {
                print("\(self.arrSelectedVariants[i].variant_SubName)")
                self.arrselectedId.append(self.arrSelectedVariants[i].variant_option_id)
            }
        }
        checkItemsAndUpdateFooter()
    }
    func checkItemsAndUpdateFooter(){
        //                self.lblItem.text = "1 item"
        viewFooter.isHidden = false
        lblSign.isHidden = false
        lblTotal.isHidden = false
        lblItem.isHidden = false
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrVariants?.count ?? 0 > 0 ? bffComboCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  BffComboShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 3
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                return (arrVariants?[section].isExpanded == true) ?  arrVariants?[section].option.count ?? 0 : 0
            }else{
                return 1
            }
        }else{
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: bffComboCell.reuseIdentifier, for: indexPath) as! bffComboCell
                cell.lblbffComboTitle.text = arrVariants?[indexPath.section].option[indexPath.row].name
                cell.lblBffComboPrice.isHidden = (arrVariants?[indexPath.section].option[indexPath.row].price != "") ? false : true
                let varient = self.arrVariants?[indexPath.section]
                let option = varient!.option[indexPath.row]
                if arrVariants?[indexPath.section].option[indexPath.row].price == "0.00"{
                    cell.lblBffComboPrice.isHidden = true
                }else{
                    cell.lblBffComboPrice.isHidden = false
                    cell.lblBffComboPrice.text = (CurrencySymbol) + (arrVariants?[indexPath.section].option[indexPath.row].price)!
                }
                
                let selectOne = arrVariants?[indexPath.section].menuChoice.toInt()
                
                if isFromWebservice == true{
                    if arrVariants?[indexPath.section].defaultItem == "" && arrVariants?[indexPath.section].variantItem == "0"{
                        self.arrVariants?[indexPath.section].option[0].isSelected = true
                    }else{
                        if let obj = arrVariants?[indexPath.section].defaultItem.split(separator: ",") {
                            for i in obj{
                                if (arrVariants?[indexPath.section].option?[indexPath.row].id ?? "0") == i {
                                    arrVariants?[indexPath.section].option?[indexPath.row].isSelected = true
                                }
                            }
                        }
                    }
                }
                if isFromRestaurant{
                    if arrVariants?[indexPath.section].option?[indexPath.row].isSelected == true {
                        self.selectedOption.manage(option)
                    }
                }
                if arrVariants?[indexPath.section].option[indexPath.row].isSelected == true && selectOne == 0 {
                    cell.selectButton.setImage(UIImage(named: "ic_selectedBFFCombo"), for: .normal)
                } else if arrVariants?[indexPath.section].option[indexPath.row].isSelected == false && selectOne == 0 {
                    cell.selectButton.setImage(UIImage(named: "ic_unselectedBFFCombo"), for: .normal)
                } else if arrVariants?[indexPath.section].option[indexPath.row].isSelected == true && selectOne != 0 {
                    cell.selectButton.setImage(UIImage(named: "ic_paymentSelected"), for: .normal)
                } else {
                    cell.selectButton.setImage(UIImage(named: "ic_sortunSelected"), for: .normal)
                }
//                cell.selectedBtn = {
//                    self.isFromWebservice = false
//                    if selectOne == 0{
//                        self.arrVariants?[indexPath.section].option.forEach { $0.isSelected = false }
//                        self.arrVariants?[indexPath.section].option[indexPath.row].isSelected = true
//                        self.selectedOption.manage(option)
//                    }else{
//                        self.arrVariants?[indexPath.section].option[indexPath.row].isSelected = !(self.arrVariants?[indexPath.section].option[indexPath.row].isSelected ?? Bool())
//                        self.selectedOption.manage(option)
//
//                    }
//
//                }
                self.checkandUpdateVariants()
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = tblBFFCombo.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "Orders")
                NoDatacell.lblNoDataTitle.isHidden = true
                NoDatacell.selectionStyle = .none
                return NoDatacell
            }
        }else{
            let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: BffComboShimmerCell.reuseIdentifier, for: indexPath) as! BffComboShimmerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isFromRestaurant = false
        let selectOne = arrVariants?[indexPath.section].menuChoice.toInt()
        let varient = self.arrVariants?[indexPath.section]
        let option = varient!.option[indexPath.row]
        self.isFromWebservice = false
        if selectOne == 0{
            
            for i in 0..<(self.arrVariants?[indexPath.section].option?.count ?? 0)
            {
                let obj = self.arrVariants?[indexPath.section].option?[i]
                if (obj?.isSelected == true)
                {
                    obj?.isSelected = false
                }
                
                self.selectedOption.manage(obj!)
            }
            let obj2 = self.arrVariants?[indexPath.section].option?[indexPath.row]
            
            obj2?.isSelected = true
            self.selectedOption.manage(obj2!)
            
        }else{
            self.arrVariants?[indexPath.section].option[indexPath.row].isSelected = !(self.arrVariants?[indexPath.section].option[indexPath.row].isSelected ?? Bool())
            self.selectedOption.manage(option)
        }
        self.checkandUpdateVariants()
        self.tblBFFCombo.reloadSections(IndexSet(integer: indexPath.section) , with: .automatic)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                return self.arrVariants?.count ?? 0
            }else{
                return 1
            }
        }else{
            return 5
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width , height: 47))
                headerView.backgroundColor = .white
                
                let label = UILabel()
                label.frame = CGRect.init(x: 19, y: 0, width: headerView.frame.width - 118, height: 19)
                label.center.y = headerView.frame.size.height / 2
                label.text = arrVariants?[section].groupName
                label.font = CustomFont.NexaBold.returnFont(15)
                label.textColor = colors.black.value// colors.black.value
                //headerView.backgroundColor = colors.white.value
                headerView.addSubview(label)
                
                let expandImageView = UIImageView()
                expandImageView.frame = CGRect.init(x: headerView.frame.width - 35.66, y: 34.31, width: 16.66, height: 8.38)
                expandImageView.center.y = headerView.frame.size.height / 2
                if arrVariants?[section].isExpanded == true{
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
                
                return headerView
            } else {
                let NoDatacell = tblBFFCombo.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: "Bff Combo")
                NoDatacell.lblNoDataTitle.isHidden = true
                NoDatacell.selectionStyle = .none
                return NoDatacell
            }
        }else{
            let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: BffComboShimmerCell.reuseIdentifier) as! BffComboShimmerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc  func btnExpand(_ sender : UIButton) {
        if arrVariants?[sender.tag].isExpanded == true {
            arrVariants?[sender.tag].isExpanded = false
        } else {
            arrVariants?[sender.tag].isExpanded = true
        }
        //        DispatchQueue.main.async {
        self.tblBFFCombo.reloadData()
        //        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height / 2
            }
        }else {
            return self.responseStatus == .gotData ?  40 : 70
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if responseStatus == .gotData{
            if arrVariants?.count != 0 {
                return 47
            }else{
                return tableView.frame.height
            }
        }else {
            return self.responseStatus == .gotData ?  40 : 70
        }
        //        if arrVariants?.count != 0 {
        //            return 47
        //        } else {
        //            return tableView.frame.size.height
        //        }
        
    }
    
    
    // MARK: - IBActions
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
            //            self.navigationController?.popViewController(animated: true)
            let strarray = arrselectedId.joined(separator: ",")
            webwerviceAddtoCart(strAddon: strarray)
            // self.delegateAddVariant.addVeriantincart(veriantid: strarray)
        }
    }
    
    // MARK: - Api Calls
    @objc func webservicePostCombo(){
        isFromWebservice = true
        let ResVariants = RestaurantVariantsReqModel()
        ResVariants.restaurant_item_id = selectedItemId
        WebServiceSubClass.RestaurantVariants(RestaurantVariantsmodel: ResVariants, showHud: false, completion: { [self] (response, status, error) in
            //self.hideHUD()
            self.refreshList.endRefreshing()
            self.responseStatus = .gotData
            if status {
                let resVariant = RestaurantVariantResModel.init(fromJson: response)
                let cell = self.tblBFFCombo.dequeueReusableCell(withIdentifier: BffComboShimmerCell.reuseIdentifier) as! BffComboShimmerCell
                cell.stopShimmering()
//                self.lblItem.text = CurrencySymbol + resVariant.itemPrice
                itemBasePrice = Double(resVariant.itemPrice) ?? 0.00
                let objDoublePrice = Double(resVariant.itemPrice ?? "0") ?? 0
                self.total = Int(objDoublePrice)
                self.tblBFFCombo.stopSkeletonAnimation()
                self.arrVariants = resVariant.variants
                self.tblBFFCombo.dataSource = self
                self.tblBFFCombo.isScrollEnabled = true
                self.tblBFFCombo.isUserInteractionEnabled = true
                self.tblBFFCombo.reloadData()
                
                NotificationCenter.default.post(name: notifRefreshRestaurantDetails, object: nil)
            } else {
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    
    func webwerviceAddtoCart(strAddon:String){
        let addToCart = AddToCartReqModel()
        addToCart.restaurant_id = selectedRestaurantId
        addToCart.user_id = SingletonClass.sharedInstance.UserId
        addToCart.qty = "1"
        addToCart.item_id = selectedItemId
        addToCart.addon_id = strAddon
        WebServiceSubClass.AddToCart(AddToCartModel: addToCart, showHud: true) { (response, status, error) in
            if status {
                self.navigationController?.popViewController(animated: true)
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        }
    }
}
