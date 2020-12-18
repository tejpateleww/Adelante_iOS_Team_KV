//
//  MyOrderDetailsVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyOrderDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSegmentTag = 0
    var isSharedOrder = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var vwBarCode: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblRestName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblServiceFeeTitle: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblTaxesTitle: UILabel!
    @IBOutlet weak var lblTaxes: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnShareOrder: submitButton!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var vwRateOrder: UIView!
    @IBOutlet weak var vwShareOrder: UIView!
    
    @IBOutlet weak var heightTblItems: NSLayoutConstraint!
    
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
        if selectedSegmentTag == 0 {
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.pastOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        } else {
            setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.upcomingOrderDetails.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        }
        setUpOrderDetails()
    }
    
    func setUpOrderDetails() {
        if selectedSegmentTag == 0 {
            self.vwCancel.isHidden = true
            self.vwRateOrder.isHidden = false
            self.vwShareOrder.isHidden = true
            self.vwBarCode.isHidden = true
        } else {
            self.vwCancel.isHidden = false
            self.vwRateOrder.isHidden = true
            if isSharedOrder {
                self.vwShareOrder.isHidden = true
            } else {
                self.vwShareOrder.isHidden = false
            }
            self.vwBarCode.isHidden = false
        }
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.reloadData()
        self.heightTblItems.constant = tblItems.contentSize.height
    }
    
    // MARK: - IBActions
    @IBAction func btnCancelOrderClicked(_ sender: Any) {
//        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
//
//        controller.isHideCancelButton = true
//        controller.isHideSubmitButton = false
//               //controller.modalPresentationStyle = .fullScreen
//        controller.isCancleOrder = true
//               controller.btnSubmit = {
//                   self.dismiss(animated: true, completion: nil)
//                    self.navigationController?.popViewController(animated: true)
//
//               }
//               self.present(controller, animated: true, completion: nil)
        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "Cancel Order", strCancelButtonTitle: "", strDescription: "Do you really want to cancel the order?", strTitle: "Are you Sure?", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appRedColor, cancelBtnColor: colors.appRedColor, viewController: self)
//        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "Cancel Order", strCancelButtonTitle: "", strDescription: "Do you really want to cancel the order?", strTitle: "Are you Sure?", isShowImage: true, strImage: "ic_popupCancleOrder", isCancleOrder: true, submitBtnColor: colors.appGreenColor.value, cancelBtnColor: colors.appOrangeColor.value ,viewController: self)
    }
    
    @IBAction func btnRateOrderClicked(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID)
                   self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnShareOrderClicked(_ sender: Any) {
        self.isSharedOrder = true
        setUpOrderDetails()
    }
    
    // MARK: - UITableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblItems.dequeueReusableCell(withIdentifier: MyOrderDetailsCell.reuseIdentifier, for: indexPath) as! MyOrderDetailsCell
        if selectedSegmentTag == 1 && isSharedOrder {
            cell.lblSharedFrom.isHidden = false
        } else {
            cell.lblSharedFrom.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Api Calls
    
}

// MARK: - UITableViewCell --> MyOrderDetailsCell
class MyOrderDetailsCell: UITableViewCell {
    
    // MARK: - IBOutlets of MyOrderDetailsCell
    
    @IBOutlet weak var lblItemName: orderDetailsLabel!
    @IBOutlet weak var lblDateTime: orderDetailsLabel!
    @IBOutlet weak var lblSharedFrom: orderDetailsLabel!
    
    // MARK: - Properties
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
