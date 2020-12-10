
//
//  myAccountDetailsVC.swift
//  Adelante
//
//  Created by Apple on 04/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyAccountVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var myACDetailsARray:[String] = ["","","","","","",""]
    
    var allDetails = [myAccountDetails]()
    
    @IBOutlet weak var tblAcountDetails: UITableView!
    
    
    
  
    var customTabBarController: CustomTabBarVC?
    
    override func viewDidLoad() {
          super.viewDidLoad()
         addNavBarImage(isLeft: true, isRight: true)
          
          allDetails = [myAccountDetails(icon: UIImage(named: "ic_myOrder")!, title: "My Orders", subTitle: [], selectedIcon: UIImage(named: "ic_myOrderSelected")!),
                        
                        myAccountDetails(icon: UIImage(named: "ic_payemt")!, title: "Payment", subTitle: [], selectedIcon: UIImage(named: "ic_payemtSelected")!),
                        myAccountDetails(icon: UIImage(named: "ic_myFoodList")!, title: "My Foodlist", subTitle: [], selectedIcon: UIImage(named: "ic_myFoodListSelected")!),
                        myAccountDetails(icon: UIImage(named: "ic_aboutUS")!, title: "About Us", subTitle: [subAccountDetails(subTitle: "Terms & conditions "),subAccountDetails(subTitle: "Privacy policy ")], selectedIcon: UIImage(named: "ic_aboutUSSelected")!),
                        myAccountDetails(icon: UIImage(named: "ic_Help")!, title: "Help", subTitle: [subAccountDetails(subTitle: "Feedback")], selectedIcon: UIImage(named: "ic_HelpSelected")!),
                        myAccountDetails(icon: UIImage(named: "ic_changePassword")!, title: "Change Password", subTitle: [], selectedIcon: UIImage(named: "ic_changePasswordSelected")!),
                        myAccountDetails(icon: UIImage(named: "ic_Logout")!, title: "Logout", subTitle: [], selectedIcon: UIImage(named: "ic_LogoutSelected")!),
          ]
          setup()
      
      self.navigationController?.interactivePopGestureRecognizer?.delegate = self

      }
    
      override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          self.customTabBarController?.showTabBar()
        
      }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myAccount.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        tblAcountDetails.reloadData()
    }
    //MARK: -btnAction
    @IBAction func btnMyprofile(_ sender: UIButton)
    {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyProfileVC.storyboardID) as! MyProfileVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
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
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 43.5))
        
        let iconImageView = UIImageView()
        iconImageView.frame = CGRect(x: 0, y: 20.5, width: 23, height: 23)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = allDetails[section].detailsIcon
        headerView.addSubview(iconImageView)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 35, y: 20.5, width: headerView.frame.width - 80, height: 23)
        if section == expendedCell
        {
            label.font = CustomFont.NexaBold.returnFont(17)
            iconImageView.image = allDetails[section].selectedDetailsIcon
        }
        else{
            label.font = CustomFont.NexaRegular.returnFont(17)
            iconImageView.image = allDetails[section].detailsIcon
        }
        label.text = allDetails[section].detailsTitle
        
        label.textColor = colors.black.value// colors.black.value
        //headerView.backgroundColor = colors.white.value
        headerView.addSubview(label)
        
        let expandImageView = UIImageView()
        expandImageView.frame = CGRect.init(x: headerView.frame.width - 16.66, y: 34.31, width: 16.66, height: 8.38)
        expandImageView.center.y = label.center.y
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
        }
        
        return headerView
    }
    @objc  func btnExpand(_ sender : UIButton) {
        switch sender.tag {
        case 0:
            print(sender.tag)
            customTabBarController?.selectedIndex = 2
        //
        case 1:
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID) as! addPaymentVC
            self.navigationController?.pushViewController(controller, animated: true)
         
            print(sender.tag)
        case 2:
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MyFoodlistVC.storyboardID) as! MyFoodlistVC
            self.navigationController?.pushViewController(controller, animated: true)
         
            print(sender.tag)
        case 3:
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
            controller.strNavTitle = "About Us"
            self.navigationController?.pushViewController(controller, animated: true)
            print(sender.tag)
        case 4:
            print(sender.tag)
        case 5:
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ChangePasswordVC.storyboardID) as! ChangePasswordVC
            self.navigationController?.pushViewController(controller, animated: true)
            print(sender.tag)
        case 6:
            
            print(sender.tag)
        case 7:
            print(sender.tag)
        default:
            print(sender.tag)
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
                controller.strNavTitle = "Terms & conditions"
                self.navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
                controller.strNavTitle = "Privacy policy"
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                print(indexPath.row)
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: FeedbackVC.storyboardID) as! FeedbackVC
                
                self.navigationController?.pushViewController(controller, animated: true)
                
            default:
                print(indexPath.row)
            }
        }
    }
    var expendedCell = 0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
class myAccountSubDetails : UITableViewCell {
    
    @IBOutlet weak var lblAccountSubDetails: myaccountLabel!
}
class myAccountDetails
{
    var detailsIcon : UIImage?
    var selectedDetailsIcon : UIImage?
    var detailsTitle : String?
    var subDetails : [subAccountDetails]?
    init(icon:UIImage,title:String,subTitle:[subAccountDetails],selectedIcon : UIImage) {
        self.detailsIcon = icon
        self.detailsTitle = title
        self.subDetails = subTitle
        self.selectedDetailsIcon = selectedIcon
    }
    
}
class subAccountDetails
{
    var subAccountTitle : String?
    init(subTitle:String) {
        self.subAccountTitle = subTitle
    }
}
