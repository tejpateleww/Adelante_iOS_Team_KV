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
    var refreshList = UIRefreshControl()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblBFFCombo: UITableView!
    @IBOutlet weak var lblItem: bffComboLabel!
    @IBOutlet weak var lblViewCart: bffComboLabel!
    var bffComboData = [bffCombo]()
    
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    func setUpLocalizedStrings(){
        lblItem.text = "BffComboVC_lblItem".Localized()
        lblViewCart.text = "BffComboVC_lblViewCart".Localized()
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bffComboData[section].isExpanded == true) ? bffComboData[section].subCombo.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBFFCombo.dequeueReusableCell(withIdentifier: bffComboCell.reuseIdentifier, for: indexPath) as! bffComboCell
        cell.lblbffComboTitle.text = bffComboData[indexPath.section].subCombo[indexPath.row].subComboName
        cell.lblBffComboPrice.isHidden = (bffComboData[indexPath.section].subCombo[indexPath.row].subComboPrice != "") ? false : true
        cell.lblBffComboPrice.text = bffComboData[indexPath.section].subCombo[indexPath.row].subComboPrice
        
        //cell.selectButton.setImage(UIImage(named: "ic_unselectedBFFCombo"), for: .normal)
        if bffComboData[indexPath.section].subCombo[indexPath.row].isSelected! {
            cell.selectButton.isSelected = true
        } else {
            cell.selectButton.isSelected = false
        }
        
        cell.selectedBtn = {
            for i in 0...self.bffComboData[indexPath.section].subCombo.count
            {
                if i == self.bffComboData[indexPath.section].subCombo.count {
                    self.bffComboData[indexPath.section].subCombo[indexPath.row].isSelected = true
                    self.tblBFFCombo.reloadSections(IndexSet(integer: indexPath.section) , with: .automatic)
                }
                else
                {
                    self.bffComboData[indexPath.section].subCombo[i].isSelected = false
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return bffComboData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width , height: 47))
        headerView.backgroundColor = .white
        
        
        let label = UILabel()
        label.frame = CGRect.init(x: 19, y: 0, width: headerView.frame.width - 118, height: 19)
        label.center.y = headerView.frame.size.height / 2
        label.text = bffComboData[section].comboName
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
        if bffComboData[sender.tag].isExpanded! {
            bffComboData[sender.tag].isExpanded = false
        } else {
            bffComboData[sender.tag].isExpanded = true
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
            self.present(navController, animated: true, completion: nil)
        }else{
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID) as! checkOutVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - Api Calls
    @objc func webservicePostCombo(){
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
