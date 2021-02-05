//
//  addPaymentVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage


class addPaymentVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource,AddPaymentDelegate {
    
    
    // MARK: - Properties
    var cardDetails : [String] = []
    var customTabBarController: CustomTabBarVC?
    var selectedPaymentMethods = 1
    var refreshList = UIRefreshControl()
    var arrCard = [CardList]()    
    // MARK: - IBOutlets
    @IBOutlet weak var tblPaymentMethod: UITableView!
    @IBOutlet weak var btnAddCart: submitButton!
    
    //MARK: - Other Methods
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tblPaymentMethod.refreshControl = refreshList
//        refreshList.addTarget(self, action: #selector(webserviceGetAddPayment), for: .valueChanged)
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.addPaymentVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        webserviceGetAddPayment()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    //MARK: -tblViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrCard.count
        switch section {
        case 0:
            return arrCard.count + 1
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
                cell1.lblWallet.text = "addPaymentVC_lblWallet".Localized()
                cell1.lblwalletBalance.text = "$250.00"
                cell1.vWMain.layer.borderColor = UIColor(hexString: "#E34A25").cgColor
//                if indexPath.row == selectedPaymentMethods {
//                    cell1.vWMain.layer.borderWidth = 1
//                } else {
//                    cell1.vWMain.layer.borderWidth = 0
//                }
                cell1.btnDelete.isHidden = true
                cell1.selectPaymentMethodButton.isHidden = true
                
                cell = cell1
            } else {
                let cell2 = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell2.reuseIdentifier, for: indexPath) as! paymentMethodCell2
                cell2.vWMain.layer.borderColor = UIColor(hexString: "#E34A25").cgColor
//                if indexPath.row == selectedPaymentMethods {
//                    cell2.vWMain.layer.borderWidth = 1
//                } else {
//                    cell2.vWMain.layer.borderWidth = 0
//                }
                //                cell2.paymentMethodImageView.image = self.getCardImageFromCardType(objSelectedCard: self.arrCard[indexPath.row])
                let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrCard[indexPath.row - 1].cardImage ?? "")"
                cell2.paymentMethodImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.paymentMethodImageView.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell2.lblcardDetails.text = arrCard[indexPath.row - 1].formatedCardNo
                cell2.lblExpiresDate.text = String(format: "addPaymentVC_lblExpiresDate".Localized(), arrCard[indexPath.row - 1].expDateMonthYear)
                cell2.selectPaymentMethodButton.isHidden = true
                cell2.btnDelete.isHidden = false
                cell2.btnDelete.addTarget(self, action: #selector(btnDeleteCardClicked(_:)), for: .touchUpInside)
                cell = cell2
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell2.reuseIdentifier, for: indexPath) as! paymentMethodCell2
            cell.paymentMethodImageView.image = UIImage(named: "ic_paypal")
            cell.lblcardDetails.text = "Paypal"
            cell.lblExpiresDate.text = "Default method"
            cell.btnDelete.isHidden = true
//            cell2.btnDelete.addTarget(self, action: #selector(btnDeleteCardClicked(_:)), for: .touchUpInside)
            cell.selectPaymentMethodButton.isHidden = true
            cell.selectionStyle = .none
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
            headerView.backgroundColor = .white
            
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
            headerView.backgroundColor = .white
            
            let label = UILabel.init(frame: CGRect(x: 16, y: 0, width:  headerView.frame.size.width, height: 19))
            label.center.y = headerView.frame.size.height / 2
            label.text = "CURRENT METHOD"
            label.font = CustomFont.NexaBold.returnFont(13)
            label.textColor = UIColor(hexString: "#ACB1C0")
            label.textAlignment = .left
            headerView.addSubview(label)
            return headerView
        default:
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            headerView.backgroundColor = .white
            return headerView
        }
    }
    func setUpLocalizedStrings(){
        btnAddCart.setTitle("addPaymentVC_btnAddCart".Localized(), for: .normal)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaymentMethods = indexPath.row
        tblPaymentMethod.reloadData()
//        commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "OK", strCancelButtonTitle: "", strDescription: "Your order has been placed.", strTitle: "Payment Successful", isShowImage: true, strImage: "ic_popupPaymentSucessful", isCancleOrder: false, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appGreenColor, viewController: self)
    }
    
    //MARK: -btnAction
    @IBAction func btnAddcardClick(_ sender: submitButton) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: AddCardVC.storyboardID) as! AddCardVC
        controller.delegatePayment = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnDeleteCardClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: AppName,
                                                message: "alertMsg_DeletePaymentCard".Localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel".Localized(), style: .cancel))
        alertController.addAction(UIAlertAction(title: "Delete".Localized(), style: .default){ _ in
            self.webServiceDeletePaymentCard(strCardId: self.arrCard[sender.tag].id)
        })
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    // MARK: - Api Calls
    @objc func webserviceGetAddPayment(){
        let addpayment = AddPaymentReqModel()
        addpayment.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.addPayment(addpaymentmodel: addpayment, showHud: true, completion: { (json, status, error) in
            // self.hideHUD()
             if(status) {
                 let cardListRes = AddPaymentResModel.init(fromJson: json)
                 self.arrCard = cardListRes.cards
                 self.tblPaymentMethod.reloadData()
             } else {
                 Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong!")
             }
         })
        DispatchQueue.main.async {
            self.refreshList.endRefreshing()
        }
    }
    func refreshAddPaymentScreen() {
        webserviceGetAddPayment()
    }
    func webServiceDeletePaymentCard(strCardId: String){
        let deleteCardModel = AddPaymentDeleteReqModel()
        deleteCardModel.card_id = strCardId
        deleteCardModel.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.removePaymentList(removePaymentList: deleteCardModel, showHud: true, completion: { (json, status, error) in
            // self.hideHUD()
             if(status) {
                 Utilities.showAlertOfAPIResponse(param: json["message"].string ?? "", vc: self)
                 self.webserviceGetAddPayment()
             } else {
                 Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong!")
             }
         })
    }
}
