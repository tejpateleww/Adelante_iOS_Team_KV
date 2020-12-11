//
//  checkOutVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import MapKit
class checkOutVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var customTabBarController: CustomTabBarVC?
    @IBOutlet weak var tblAddedProduct: UITableView!
    @IBOutlet weak var tblOrderDetails: UITableView!
    
    @IBOutlet weak var restaurantLocationView: checkoutView!
    @IBOutlet weak var tblOrderDetailsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblAddProductHeight: NSLayoutConstraint!
    var arrayForTitle : [String] = ["Subtotal","Service Fee","Taxes"]
    var arrayForPrice : [String] = ["30","2","7"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        tblOrderDetailsHeight.constant = CGFloat(arrayForTitle.count * 43)
        tblAddProductHeight.constant = CGFloat(arrayForTitle.count * 60)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.checkOutVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        addMapView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    func addMapView()
    {
        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: restaurantLocationView.frame.size.width, height: restaurantLocationView.frame.size.height)
        restaurantLocationView.addSubview(mapView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblAddedProduct:
            return arrayForTitle.count
        case tblOrderDetails:
            return arrayForPrice.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblAddedProduct:
            let cell = tblAddedProduct.dequeueReusableCell(withIdentifier: addedProductCell.reuseIdentifier, for: indexPath) as! addedProductCell
            cell.decreaseClick = {
                cell.lbltotalCount.text = (Int(cell.lbltotalCount.text!)! == 0) ? "0" : "\(Int(cell.lbltotalCount.text!)! - 1)"
            }
            cell.increaseClick = {
                cell.lbltotalCount.text = "\(Int(cell.lbltotalCount.text!)! + 1)"
                
            }
            return cell
        case tblOrderDetails:
            let cell = tblOrderDetails.dequeueReusableCell(withIdentifier: orderDetailsCell.reuseIdentifier, for: indexPath) as! orderDetailsCell
            cell.lblTitle.text = arrayForTitle[indexPath.row]
            cell.lblPrice.text = "$\(arrayForPrice[indexPath.row])"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblAddedProduct:
            return 60
        case tblOrderDetails:
            return 43
        default:
            return 43
        }
        
    }
    
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: addPaymentVC.storyboardID)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

class orderDetailsCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: CheckOutLabel!
    @IBOutlet weak var lblPrice: CheckOutLabel!
}

class addedProductCell : UITableViewCell {
    
    @IBOutlet weak var lbltotalCount: CheckOutLabel!
    @IBAction func decreaseBtn(_ sender: Any) {
        if let click = self.decreaseClick {
            click()
        }
    }
    var decreaseClick : (() -> ())?
    var increaseClick : (() -> ())?
    @IBAction func increaseBtn(_ sender: Any) {
        if let click = self.increaseClick {
            click()
        }
    }
}
