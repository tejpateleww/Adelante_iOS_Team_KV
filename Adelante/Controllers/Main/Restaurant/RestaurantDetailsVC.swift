//
//  RestaurantDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

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
    var arrSections = [structSections(strTitle:"Menu",isExpanded:false, rowCount: 3), structSections(strTitle:"Sandwiches",isExpanded:true, rowCount: 5), structSections(strTitle:"Salad",isExpanded:false, rowCount: 2)] //["Menu","Sandwiches","Salad"]
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblRestaurantDetails: UITableView!
    @IBOutlet weak var heightTblRestDetails: NSLayoutConstraint!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func viewDidLayoutSubviews() {
        heightTblRestDetails.constant = tblRestaurantDetails.contentSize.height
    }
    
    // MARK: - IBActions
    
    @IBAction func btnViewPolicy(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CommonWebViewVC.storyboardID) as! CommonWebViewVC
        controller.strNavTitle = "Privacy policy"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BtnRattingsAndReviews(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantReviewVC.storyboardID) as! RestaurantReviewVC
        self.navigationController?.pushViewController(controller, animated: true)
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
//        if arrSections[sender.tag].isExpanded! {
//            arrSections[sender.tag].isExpanded = false
//        } else {
//            arrSections[sender.tag].isExpanded = true
//        }
        
        DispatchQueue.main.async {
            self.tblRestaurantDetails.reloadData()
//            self.heightTblRestDetails.constant = self.tblRestaurantDetails.contentSize.height
//            self.view.layoutIfNeeded()
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrSections[section].rowCount
        }
        return arrSections[section].isExpanded == true ? arrSections[section].rowCount : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:RestaurantDetailsCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantDetailsCell", for: indexPath)as! RestaurantDetailsCell
            cell.selectionStyle = .none
            cell.customize = {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
                self.navigationController?.pushViewController(controller, animated: true)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell:RestaurantItemCell = tblRestaurantDetails.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath)as! RestaurantItemCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 48))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 14, width: headerView.frame.width-40, height: 20)
        label.center.y = headerView.frame.size.height / 2
            label.text = arrSections[section].strTitle
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
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
////             let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
////                   self.navigationController?.pushViewController(controller, animated: true)
//            break
//        case 1:
//            break
//        default:
//            break
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblRestaurantDetails.frame.width, height: 1))
        footerView.backgroundColor = UIColor(hexString: "#707070").withAlphaComponent(0.2)
        return footerView
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 110
//        }else{
//            return 55
//        }
//        return tableView.estimatedRowHeight
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return arrSections[section].strTitle
//    }
    
    // MARK: - Api Calls
}

// MARK: - UITableViewCell - RestaurantDetailsCell
class RestaurantDetailsCell:UITableViewCell{
    
    @IBOutlet weak var vwSeperator: seperatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var customize : (() -> ())?

    @IBAction func btnCustomize(_ sender: Any) {
        if let click = self.customize {
            click()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UITableViewCell - RestaurantDetailsCell
class RestaurantItemCell:UITableViewCell{
    
    @IBOutlet weak var vwSeperator: seperatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
