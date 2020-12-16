//
//  addPaymentVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class addPaymentVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var cardDetails : [String] = []
    var customTabBarController: CustomTabBarVC?
    var selectedPaymentMethods = 1
    @IBOutlet weak var tblPaymentMethod: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.addPaymentVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    //MARK: -tblViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            var cell = UITableViewCell()
            if indexPath.row == 0 {
                let cell1 = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell1.reuseIdentifier, for: indexPath) as! paymentMethodCell1
                
                cell1.paymentImageView.image = UIImage(named: "ic_wallet")
                cell1.lblWallet.text = "Wallet"
                cell1.lblwalletBalance.text = "$250.00"
                cell1.vWMain.layer.borderColor = UIColor(hexString: "#E34A25").cgColor
                if indexPath.row == selectedPaymentMethods {
                    cell1.vWMain.layer.borderWidth = 1
                } else {
                     cell1.vWMain.layer.borderWidth = 0
                }
                
                cell = cell1
            } else {
                let cell2 = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell2.reuseIdentifier, for: indexPath) as! paymentMethodCell2
                cell2.vWMain.layer.borderColor = UIColor(hexString: "#E34A25").cgColor
                if indexPath.row == selectedPaymentMethods {
                    cell2.vWMain.layer.borderWidth = 1
                } else {
                     cell2.vWMain.layer.borderWidth = 0
                }
                if indexPath.row == 1
                {
                    cell2.paymentMethodImageView.image = UIImage(named: "ic_masterCard")
                    cell2.lblcardDetails.text = "**** **** **** 5967"
                    cell2.lblExpiresDate.text = "Expires 09/25"
                    cell2.selectPaymentMethodButton.isHidden = true
                } else if indexPath.row == 2 {
                    cell2.paymentMethodImageView.image = UIImage(named: "ic_visa")
                    cell2.lblcardDetails.text = "**** **** **** 3802"
                    cell2.lblExpiresDate.text = "Expires 10/27"
                    cell2.selectPaymentMethodButton.isHidden = true
                }
                cell = cell2
            }
            
            
            return cell
        case 1:
            let cell = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell2.reuseIdentifier, for: indexPath) as! paymentMethodCell2
            cell.paymentMethodImageView.image = UIImage(named: "ic_paypal")
            cell.lblcardDetails.text = "Paypal"
            cell.lblExpiresDate.text = "Default method"
            cell.selectPaymentMethodButton.isHidden = false
            return cell
        default:
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 100
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 43
        case 1:
            return 43
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tblPaymentMethod.frame.size.width, height: 43))
            let label = UILabel()
            label.frame = CGRect(x: 16, y: 0, width:  headerView .frame.size.width, height: 19)
            // let label = UILabel.init(frame: )
            label.center.y = headerView.frame.size.height / 2
            label.text = "Choose desired Payment Method"
            label.font = CustomFont.NexaRegular.returnFont(15)
            label.textColor = UIColor(hexString: "#222B45")
            label.textAlignment = .left
            print(headerView.frame)
            headerView.addSubview(label)
            return headerView
        case 1:
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tblPaymentMethod.frame.size.width, height: 43))
            let label = UILabel.init(frame: CGRect(x: 16, y: 0, width:  headerView.frame.size.width, height: 19))
            label.center.y = headerView.frame.size.height / 2
            label.text = "CURRENT METHOD"
            label.font = CustomFont.NexaLight.returnFont(13)
            label.textColor = UIColor(hexString: "#ACB1C0")
            label.textAlignment = .left
            headerView.addSubview(label)
            return headerView
        default:
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaymentMethods = indexPath.row
        tblPaymentMethod.reloadData()
        
//        let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
//        //controller.modalPresentationStyle = .fullScreen
//        controller.isHideCancelButton = true
//        controller.isHideSubmitButton = false
//        controller.btnSubmit = {
//            self.dismiss(animated: true, completion: nil)
//            // self.navigationController?.popViewController(animated: true)
//            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RateReviewVC.storyboardID)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        self.present(controller, animated: true, completion: nil)
        
        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "OK", strCancelButtonTitle: "", strDescription: "Your order has been placed.", strTitle: "Payment Successful", isShowImage: true, strImage: "ic_popupPaymentSucessful", isCancleOrder: false, viewController: self)
    }
    
    
    //MARK: -btnAction
    @IBAction func placeOrderBtn(_ sender: submitButton) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: AddCardVC.storyboardID)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
class paymentMethodCell1 : UITableViewCell {
     @IBOutlet weak var vWMain: PaymentView!
    @IBOutlet weak var lblWallet: addPaymentlable!
    @IBOutlet weak var lblwalletBalance: addPaymentlable!
    @IBOutlet weak var paymentImageView: UIImageView!
}
class paymentMethodCell2 : UITableViewCell {
     @IBOutlet weak var vWMain: PaymentView!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var lblExpiresDate: addPaymentlable!
    @IBOutlet weak var lblcardDetails: addPaymentlable!
}
