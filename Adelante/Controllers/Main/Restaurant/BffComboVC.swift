//
//  BffComboVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class BffComboVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Properties
    //var customTabBarController: CustomTabBarVC?
    var selectedcategory = 0
    var selectedSection = 0
    var expendedCell = -1
    var selectedRestaurantId = ""
    var refreshList = UIRefreshControl()
    var arrVariants : [Variant]?
    var objCurrentOrder : currentOrder?
    var arrSelectedVariants = [selectedVariants]()
    
    // MARK: - IBOutlets
   
    @IBOutlet weak var tblBFFCombo: UITableView!
    @IBOutlet weak var lblItem: themeLabel!
    @IBOutlet weak var lblTotal: themeLabel!
    @IBOutlet weak var lblSign: themeLabel!
    @IBOutlet weak var lblViewCart: themeLabel!
    @IBOutlet weak var btnViewCart: UIButton!
    @IBOutlet weak var viewFooter: UIView!
    
    // MARK: - ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
       // self.customTabBarController?.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblBFFCombo.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblBFFCombo.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webservicePostCombo), for: .valueChanged)
        setUpLocalizedStrings()
        addNavBarImage(isLeft: true, isRight: true)
        //self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.BffComboVC.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        objCurrentOrder = SingletonClass.sharedInstance.restCurrentOrder
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblBFFCombo.frame.size.width, height: 31)
        tblBFFCombo.tableFooterView = footerView
        webservicePostCombo()
        checkItemsAndUpdateFooter()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    func setUpLocalizedStrings(){
        lblItem.text = "BffComboVC_lblItem".Localized()
        lblViewCart.text = "BffComboVC_lblViewCart".Localized()
    }
    
    func checkandUpdateVariants() {
        self.arrSelectedVariants.removeAll()
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
            }
        }
        checkItemsAndUpdateFooter()
    }
    func checkItemsAndUpdateFooter(){
        if SingletonClass.sharedInstance.restCurrentOrder != nil{
            if SingletonClass.sharedInstance.restCurrentOrder?.order.count ?? 0 > 1 {
                self.lblItem.text = "\(SingletonClass.sharedInstance.restCurrentOrder!.order.count ) items"
            } else {
                self.lblItem.text = "\(SingletonClass.sharedInstance.restCurrentOrder!.order.count ) item"
            }
            //Note :- Unnecessary code
//            if SingletonClass.sharedInstance.restCurrentOrder?.order.count ?? 0 > 1 {
//                self.lblItem.text = "\(SingletonClass.sharedInstance.restCurrentOrder!.order.count ) items"
//            } else {
//                self.lblItem.text = "\(SingletonClass.sharedInstance.restCurrentOrder!.order.count ) item"
//            }
            if SingletonClass.sharedInstance.restCurrentOrder?.order.count ?? 0  > 0{
                viewFooter.isHidden = false
                lblSign.isHidden = false
                lblTotal.isHidden = false
                lblItem.isHidden = false
            }else{
                viewFooter.isHidden = true
                lblTotal.text = ""
                lblItem.text = ""
            }
        }else{
            viewFooter.isHidden = true
            lblTotal.text = ""
            lblItem.text = ""
            lblSign.isHidden = true
        }
        
    }
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrVariants?[section].isExpanded == true {
            return arrVariants?[section].option.count ?? 0
        } else {
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
        
        let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: bffComboCell.reuseIdentifier, for: indexPath) as! bffComboCell
        cell.lblbffComboTitle.text = arrVariants?[indexPath.section].option[indexPath.row].name
        cell.lblBffComboPrice.isHidden = (arrVariants?[indexPath.section].option[indexPath.row].price != "") ? false : true
        cell.lblBffComboPrice.text = "$" + (arrVariants?[indexPath.section].option[indexPath.row].price)!
        let selectOne = arrVariants?[indexPath.section].option[indexPath.row].menuChoice.toInt()
        if arrVariants?[indexPath.section].option[indexPath.row].isSelected == true && selectOne == 0 {
            cell.selectButton.setImage(UIImage(named: "ic_selectedBFFCombo"), for: .normal)
        } else if arrVariants?[indexPath.section].option[indexPath.row].isSelected == false && selectOne == 0 {
            cell.selectButton.setImage(UIImage(named: "ic_unselectedBFFCombo"), for: .normal)
        } else if arrVariants?[indexPath.section].option[indexPath.row].isSelected == true && selectOne != 0 {
            cell.selectButton.setImage(UIImage(named: "ic_paymentSelected"), for: .normal)
        } else {
            cell.selectButton.setImage(UIImage(named: "ic_sortunSelected"), for: .normal)
        }
        cell.selectedBtn = {
            let tempIndex = indexPath.row
            if self.arrVariants?[indexPath.section].option[tempIndex].isSelected == true {
                self.arrVariants?[indexPath.section].option[tempIndex].isSelected = false
            } else {
                self.arrVariants?[indexPath.section].option.forEach { $0.isSelected = false }
                if self.arrVariants?[indexPath.section].option[indexPath.row].isSelected == true {
                    self.arrVariants?[indexPath.section].option[indexPath.row].isSelected = false
                } else {
                    self.arrVariants?[indexPath.section].option[indexPath.row].isSelected = true
                }
                
            }
            self.checkandUpdateVariants()
            
            self.tblBFFCombo.reloadSections(IndexSet(integer: indexPath.section) , with: .automatic)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrVariants?.count == 0 {
            return 1
        } else {
            return arrVariants?.count ?? 0
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        expandImageView.image = UIImage(named: "ic_expand")
            headerView.addSubview(expandImageView)
            
            let expandButton = UIButton()
            expandButton.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            
            expandButton.tag = section
            expandButton.addTarget(self, action: #selector(btnExpand(_:)), for: .touchUpInside)
            headerView.addSubview(expandButton)
            
            return headerView
        } else {
            let NoDatacell = tblBFFCombo.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as! NoDataTableViewCell
            
            NoDatacell.imgNoData.image = UIImage(named: NoData.varient.ImageName)
            NoDatacell.lblNoDataTitle.text = "No varient available".Localized()
            
            return NoDatacell
        }
        
    }
    
    @objc  func btnExpand(_ sender : UIButton) {
        if arrVariants?[sender.tag].isExpanded == true {
            arrVariants?[sender.tag].isExpanded = false
        } else {
            arrVariants?[sender.tag].isExpanded = true
        }
        DispatchQueue.main.async {
            self.tblBFFCombo.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arrVariants?.count != 0 {
            return 47
        } else {
            return tableView.frame.size.height
        }
        
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
//            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
//            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - Api Calls
    @objc func webservicePostCombo(){
        let ResVariants = RestaurantVariantsReqModel()
        ResVariants.restaurant_item_id = selectedRestaurantId
        WebServiceSubClass.RestaurantVariants(RestaurantVariantsmodel: ResVariants, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            self.refreshList.endRefreshing()
            if status {
                let resVariant = RestaurantVariantResModel.init(fromJson: response)
                self.arrVariants = resVariant.variants
             
                
                self.tblBFFCombo.reloadData()
                NotificationCenter.default.post(name: notifRefreshRestaurantDetails, object: nil)
            } else {
               
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })

//        DispatchQueue.main.async {
//
//        }
    }
}
