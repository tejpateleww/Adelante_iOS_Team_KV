//
//  MyAccountVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyAccountVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Properties
    var myACDetailsARray:[String] = ["","","","","","",""]
    var allDetails = [myAccountDetails(icon: UIImage(named: "ic_myOrder")!, title: "My Orders", subTitle: []),
                  
                  myAccountDetails(icon: UIImage(named: "ic_payemt")!, title: "Payment", subTitle: []),
                  myAccountDetails(icon: UIImage(named: "ic_myFoodList")!, title: "My Foodlist", subTitle: []),
                  myAccountDetails(icon: UIImage(named: "ic_aboutUS")!, title: "About Us", subTitle: [subAccountDetails(subTitle: "Terms & conditions "),subAccountDetails(subTitle: "Privacy policy "),subAccountDetails(subTitle: "Terms & conditions "),subAccountDetails(subTitle: "Terms & conditions "),subAccountDetails(subTitle: "Terms & conditions ")]),
                  myAccountDetails(icon: UIImage(named: "ic_Help")!, title: "Help", subTitle: [subAccountDetails(subTitle: "Feedback")]),
                  myAccountDetails(icon: UIImage(named: "ic_changePassword")!, title: "Change Password", subTitle: []),
                  myAccountDetails(icon: UIImage(named: "ic_Logout")!, title: "Logout", subTitle: []),
    ]
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblAcountDetails: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myAccount.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        tblAcountDetails.delegate = self
        tblAcountDetails.dataSource = self
        tblAcountDetails.reloadData()
    }
    
    // MARK: - IBActions
    
    //MARK: -tableView Methos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expendedCell == section
        {
            return allDetails[section].subDetails!.count
        }
        else  {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAcountDetails.dequeueReusableCell(withIdentifier: myAccountSubDetails.reuseIdentifier, for: indexPath) as! myAccountSubDetails
        cell.lblAccountSubDetails.text = allDetails[indexPath.section].subDetails![indexPath.row].subAccountTitle
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDetails.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 58))
        
        let iconImageView = UIImageView()
        iconImageView.frame = CGRect(x: 0, y: 28.5, width: 23, height: 23)
        iconImageView.image = allDetails[section].detailsIcon
        headerView.addSubview(iconImageView)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 35, y: 28.5, width: headerView.frame.width - 80, height: 23)
        label.text = allDetails[section].detailsTitle
        label.font = CustomFont.NexaRegular.returnFont(17)
        label.textColor = colors.black.value// colors.black.value
        //headerView.backgroundColor = colors.white.value
        headerView.addSubview(label)
        
        let expandImageView = UIImageView()
        expandImageView.frame = CGRect.init(x: headerView.frame.width - 16.66, y: 34.31, width: 16.66, height: 8.38)
        expandImageView.image = UIImage(named: "ic_expand")
        headerView.addSubview(expandImageView)
        
        let expandButton = UIButton()
        expandButton.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        
        expandButton.tag = section
        expandButton.addTarget(self, action: #selector(btnExpand(_:)), for: .touchUpInside)
        headerView.addSubview(expandButton)
        if allDetails[section].subDetails?.count == 0
        {
            expandImageView.isHidden = true
            expandButton.isHidden = true
        }
        return headerView
    }
    @objc  func btnExpand(_ sender : UIButton) {
        if expendedCell == sender.tag
        {
            expendedCell = -1
            DispatchQueue.main.async {
                self.tblAcountDetails.reloadData()
            }
            
        }
        else
        {
            expendedCell = sender.tag
            DispatchQueue.main.async {
                self.tblAcountDetails.reloadData()
            }
        }
    }
    var expendedCell = -1
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let checkoutVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: checkOutVC.storyboardID)
            self.navigationController?.pushViewController(checkoutVc, animated: true)
        }
    }
    // MARK: - Api Calls
    
}

class myAccountSubDetails : UITableViewCell {
    
    @IBOutlet weak var lblAccountSubDetails: myaccountLabel!
}

class myAccountDetails
{
    var detailsIcon : UIImage?
    var detailsTitle : String?
    var subDetails : [subAccountDetails]?
    init(icon:UIImage,title:String,subTitle:[subAccountDetails]) {
        self.detailsIcon = icon
        self.detailsTitle = title
        self.subDetails = subTitle
    }
    
}

class subAccountDetails
{
    var subAccountTitle : String?
    init(subTitle:String) {
        self.subAccountTitle = subTitle
    }
}
