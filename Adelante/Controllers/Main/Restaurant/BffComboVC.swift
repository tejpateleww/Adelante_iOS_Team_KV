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
    var customTabBarController: CustomTabBarVC?
    var selectedcategory = 0
    var selectedSection = 0
    var expendedCell = -1
    var selectedRestaurantId = ""
    var refreshList = UIRefreshControl()
    var arrVariants = [Variant]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblBFFCombo: UITableView!
    @IBOutlet weak var lblItem: bffComboLabel!
    @IBOutlet weak var lblViewCart: bffComboLabel!
    var bffComboData = [bffCombo]()
    var arrSections = [structSections(strTitle:"RestaurantDetailsVC_arrSection".Localized(),isExpanded:false, rowCount: 3), structSections(strTitle:"RestaurantDetailsVC_arrSection1".Localized(),isExpanded:true, rowCount: 5), structSections(strTitle:"RestaurantDetailsVC_arrSection2".Localized(),isExpanded:false, rowCount: 2)]
    // MARK: - ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblBFFCombo.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webservicePostCombo), for: .valueChanged)
        setUpLocalizedStrings()
        addNavBarImage(isLeft: true, isRight: true)
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.BffComboVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        bffComboData.append(bffCombo(name: "bffComboData_name1".Localized(), subComboArray: [subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo_name1".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo_name2".Localized(), price: "", selected: true),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo_name3".Localized(), price: "", selected: false)], expanded: true))
        bffComboData.append(bffCombo(name: "bffComboData_name2".Localized(), subComboArray: [subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo2_name1".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo2_name2".Localized(), price: "", selected: true),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo2_name3".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo2_name4".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo2_name5".Localized(), price: "", selected: false)], expanded: true))
        
        bffComboData.append(bffCombo(name: "bffComboData_name3".Localized(), subComboArray: [subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo3_name1".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo3_name2".Localized(), price: "", selected: true),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo3_name3".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo3_name4".Localized(), price: "", selected: false)], expanded: true))
        bffComboData.append(bffCombo(name: "bffComboData_name4".Localized(), subComboArray: [subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo4_name1".Localized(), price: "", selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo4_name2".Localized(), price: "bffComboData_subComboArray_subBFFCombo4_price1".Localized(), selected: true),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo4_name3".Localized(), price: "bffComboData_subComboArray_subBFFCombo4_price2".Localized(), selected: false),subBFFCombo(name: "bffComboData_subComboArray_subBFFCombo4_name4".Localized(), price: "", selected: false)], expanded: true))
        
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblBFFCombo.frame.size.width, height: 31)
        tblBFFCombo.tableFooterView = footerView
        webservicePostCombo()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    func setUpLocalizedStrings(){
        lblItem.text = "BffComboVC_lblItem".Localized()
        lblViewCart.text = "BffComboVC_lblViewCart".Localized()
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrVariants[section].isExpanded == true) ? arrVariants[section].option.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: bffComboCell.reuseIdentifier, for: indexPath) as! bffComboCell
        cell.lblbffComboTitle.text = arrVariants[indexPath.section].option[indexPath.row].name
        cell.lblBffComboPrice.isHidden = (arrVariants[indexPath.section].option[indexPath.row].price != "") ? false : true
        cell.lblBffComboPrice.text = arrVariants[indexPath.section].option[indexPath.row].price
        let selectOne = arrVariants[indexPath.section].option[indexPath.row].menuChoice.toInt()
        if arrVariants[indexPath.section].option[indexPath.row].isSelected == true && selectOne == 0{
            cell.selectButton.setImage(UIImage(named: "ic_selectedBFFCombo"), for: .normal)
        }else if arrVariants[indexPath.section].option[indexPath.row].isSelected == false && selectOne == 0{
            cell.selectButton.setImage(UIImage(named: "ic_unselectedBFFCombo"), for: .normal)
        }else if arrVariants[indexPath.section].option[indexPath.row].isSelected == true && selectOne != 0{
            cell.selectButton.setImage(UIImage(named: "ic_paymentSelected"), for: .normal)
        }else{
            cell.selectButton.setImage(UIImage(named: "ic_sortunSelected"), for: .normal)
        }
        
//        cell.selectButton.setImage(UIImage(named: "ic_unselectedBFFCombo"), for: .normal)
//        if arrVariants[indexPath.section].option[indexPath.row]! {
//            cell.selectButton.isSelected = true
//        } else {
//            cell.selectButton.isSelected = false
//        }
        
        cell.selectedBtn = {
            if selectOne == 0{
                self.arrVariants[indexPath.section].option.forEach { $0.isSelected = false}
                    if self.arrVariants[indexPath.section].option[indexPath.row].isSelected == true{
                        self.arrVariants[indexPath.section].option[indexPath.row].isSelected = false
                    } else{
                        self.arrVariants[indexPath.section].option[indexPath.row].isSelected = true
                    }
                  
            }else{
                if self.arrVariants[indexPath.section].option[indexPath.row].isSelected == true{
                    self.arrVariants[indexPath.section].option[indexPath.row].isSelected = false
                } else{
                    self.arrVariants[indexPath.section].option[indexPath.row].isSelected = true
                }
            }
            self.tblBFFCombo.reloadSections(IndexSet(integer: indexPath.section) , with: .automatic)
//            for i in 0...self.arrVariants[indexPath.section].option.count
//            {
//                if i == self.arrVariants[indexPath.section].option.count {
////                    self.arrVariants[indexPath.section].option[indexPath.row].isSelected = true
//                    self.tblBFFCombo.reloadSections(IndexSet(integer: indexPath.section) , with: .automatic)
//                }
//                else
//                {
////                    self.arrVariants[indexPath.section].option[indexPath.row].isSelected = false
//                }
//            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrVariants.count
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width , height: 47))
        headerView.backgroundColor = .white
        
        
        let label = UILabel()
        label.frame = CGRect.init(x: 19, y: 0, width: headerView.frame.width - 118, height: 19)
        label.center.y = headerView.frame.size.height / 2
        label.text = arrVariants[section].groupName
        label.font = CustomFont.NexaBold.returnFont(17)
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
    }
    @objc  func btnExpand(_ sender : UIButton) {
        if arrVariants[sender.tag].isExpanded {
            arrVariants[sender.tag].isExpanded = false
        } else {
            arrVariants[sender.tag].isExpanded = true
        }
        DispatchQueue.main.async {
            self.tblBFFCombo.reloadData()
        }
    }
    
  
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
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
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - Api Calls
    @objc func webservicePostCombo(){
        let ResVariants = RestaurantVariantsReqModel()
        ResVariants.restaurant_item_id = selectedRestaurantId
        WebServiceSubClass.RestaurantVariants(RestaurantVariantsmodel: ResVariants, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            if status {
                let resVariant = RestaurantVariantResModel.init(fromJson: response)
                self.arrVariants = resVariant.variants
                self.tblBFFCombo.reloadData()
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
        DispatchQueue.main.async {
            self.refreshList.endRefreshing()
        }
    }
}
class bffCombo {
    var comboName : String?
    var subCombo : [subBFFCombo]
    var isExpanded : Bool?
    init(name:String,subComboArray:[subBFFCombo],expanded:Bool) {
        self.isExpanded = expanded
        self.comboName = name
        self.subCombo = subComboArray
    }
}
class subBFFCombo {
    var subComboName : String?
    var subComboPrice : String?
    var isSelected : Bool?
    init(name:String,price:String,selected:Bool) {
        self.subComboName = name
        self.subComboPrice = price
        self.isSelected = selected
    }
}
