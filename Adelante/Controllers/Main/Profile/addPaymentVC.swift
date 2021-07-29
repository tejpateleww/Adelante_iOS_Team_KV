//
//  addPaymentVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import FormTextField
import Alamofire
import SwiftyJSON

class addPaymentVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource,AddPaymentDelegate {
    
    
    // MARK: - Properties
    var cardDetails : [String] = []
    var customTabBarController: CustomTabBarVC?
    var selectedPaymentMethods = 1
    var refreshList = UIRefreshControl()
    var arrCard = [CardList]()
    var filterSelect = [0]
    var strCartID = ""
    var direction:CGFloat = 1
    var shakes = 0
     var OrderDetails : String?
    var isfromPayment : Bool = false
    // MARK: - IBOutlets
    @IBOutlet weak var tblPaymentMethod: UITableView!
    @IBOutlet weak var btnAddCart: submitButton!
    @IBOutlet weak var imgEmptyCard: UIImageView!
    
    //MARK: - Other Methods
    func shake(_ theOneYouWannaShake: UIView?) {
        UIView.animate(withDuration: 0.06, animations: {
            theOneYouWannaShake?.transform = CGAffineTransform(translationX: 5 * self.direction, y: 0)
        }) { [self] finished in
            
            if shakes >= 10 {
                theOneYouWannaShake?.transform = CGAffineTransform.identity
                return
            }
            shakes += 1
            direction = direction * -1
            shake(theOneYouWannaShake)
        }
    }
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddCart.isHidden = true
        //        tblPaymentMethod.refreshControl = refreshList
        //        refreshList.addTarget(self, action: #selector(webserviceGetAddPayment), for: .valueChanged)
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.addPaymentVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        imgEmptyCard.isHidden = true
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
                if indexPath.row == selectedPaymentMethods {
                    cell1.vWMain.layer.borderWidth = 1
                } else {
                    cell1.vWMain.layer.borderWidth = 0
                }
                cell1.btnDelete.isHidden = true
                cell1.selectPaymentMethodButton.isHidden = true
                cell1.selectionStyle = .none
                cell = cell1
            } else {
                let cell2 = tblPaymentMethod.dequeueReusableCell(withIdentifier: paymentMethodCell2.reuseIdentifier, for: indexPath) as! paymentMethodCell2
                cell2.vWMain.layer.borderColor = UIColor(hexString: "#E34A25").cgColor
                if indexPath.row == selectedPaymentMethods {
                    cell2.vWMain.layer.borderWidth = 1
                    cell2.vwCvv.isHidden = false
                } else {
                    cell2.vWMain.layer.borderWidth = 0
                    cell2.vwCvv.isHidden = true
                }
                //                cell2.paymentMethodImageView.image = self.getCardImageFromCardType(objSelectedCard: self.arrCard[indexPath.row])
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrCard[indexPath.row - 1].cardImage ?? "")"
                cell2.paymentMethodImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.paymentMethodImageView.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell2.lblcardDetails.text = arrCard[indexPath.row - 1].formatedCardNo
                cell2.lblExpiresDate.text = String(format: "addPaymentVC_lblExpiresDate".Localized(), arrCard[indexPath.row - 1].expDateMonthYear)
                cell2.selectPaymentMethodButton.isHidden = true
                cell2.btnDelete.isHidden = false
                cell2.btnDelete.addTarget(self, action: #selector(btnDeleteCardClicked(_:)), for: .touchUpInside)
                cell2.selectionStyle = .none
                cell2.PayButton = {
                    if cell2.textFieldEnterCVV.text?.trim() != self.arrCard[indexPath.row - 1].cardCvv {
                        self.direction = 1
                        self.shakes = 0
                        cell2.textFieldEnterCVV.text = ""
                        self.shake(cell2.textFieldEnterCVV)
                    }
                    else {
//                        self.WebServiceCallForOrder(OrderJson: self.OrderDetails ?? "")
                        //                        self.AddAmountDetails(cardID: self.cardDetailsData?.cards?[indexPath.row].id ?? "")
                    }
                }
                
                
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
            cell.vwCvv.isHidden = true
            //            cell2.btnDelete.addTarget(self, action: #selector(btnDeleteCardClicked(_:)), for: .touchUpInside)
            cell.selectPaymentMethodButton.isHidden = false
            cell.selectedBtn = {
                cell.selectPaymentMethodButton.isSelected = !cell.selectPaymentMethodButton.isSelected
                if cell.selectPaymentMethodButton.isSelected == true {
                    print("yes")
                    cell.selectPaymentMethodButton.setImage(UIImage(named: "ic_paymentSelected"), for: .selected)
                    
                }else{
                    cell.selectPaymentMethodButton.setImage(UIImage(named: "ic_sortunSelected"), for: .normal)
                }
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        switch indexPath.section {
    //        case 0:
    //            return 100
    //        case 1:
    //            return 100
    //        default:
    //            return 0
    //        }
    //    }
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
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if isfromPayment == true{
                    
                }else{
                    let cell1 = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell1
                    cell1.vWMain.layer.borderColor = colors.appRedColor.value.cgColor
                    WebServiceCallForOrder()
                }
            } else {
                let cell2 = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell2
                cell2.vWMain.layer.borderColor = colors.appRedColor.value.cgColor
            }
        case 1:
            let cell = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell2
        default:
            return
        }
        selectedPaymentMethods = indexPath.row
        tblPaymentMethod.reloadData()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            webServiceDeletePaymentCard(strCardId: self.arrCard[indexPath.row - 1].id)
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
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
        WebServiceSubClass.addPayment(addpaymentmodel: addpayment, showHud: false, completion: { (json, status, error) in
            // self.hideHUD()
            self.refreshList.endRefreshing()
            if(status) {
                let cardListRes = AddPaymentResModel.init(fromJson: json)
                self.arrCard = cardListRes.cards
                self.tblPaymentMethod.reloadData()
                self.imgEmptyCard.isHidden = true
            } else {
                self.imgEmptyCard.isHidden = false
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
                
            }
            //            if self.arrCard.count > 0{
            //                self.tblPaymentMethod.restore()
            //                self.imgEmptyCard.isHidden = true
            ////                self.tblPaymentMethod.isHidden = false
            //            }else {
            //                self.imgEmptyCard.isHidden = true
            ////                self.tblPaymentMethod.isHidden = true
            //            }
            //            DispatchQueue.main.async {
            //                self.refreshList.endRefreshing()
            //            }
        })
        
    }
    func WebServiceCallForOrder(){
        
        let ReqModel = orderPlaceReqModel()
        ReqModel.user_id = SingletonClass.sharedInstance.UserId
        ReqModel.cart_id = strCartID
        WebServiceSubClass.PlaceOrder(OrderModel: ReqModel, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                //controller.modalPresentationStyle = .fullScreen
                controller.isHideCancelButton = true
                controller.isHideSubmitButton = false
                controller.submitBtnTitle = "OK                       "
                controller.cancelBtnTitle = ""
                controller.strDescription = json["data"].string ?? ""
                controller.strPopupTitle = "Payment Successful"
                controller.submitBtnColor = colors.appGreenColor
                controller.cancelBtnColor = colors.appRedColor
                controller.strPopupImage = "ic_popupPaymentSucessful"
                controller.isCancleOrder = true
                controller.btnSubmit = {
                   // appDel.navigateToHome()
                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
                    controller.selectedIndex = 2
//                    if controller.selectedIndex == 2{
//                        let vc = AppStoryboard.Main.
//                    }
                    
                    SingletonClass.sharedInstance.selectInProcessInMyOrder = true
                    let nav = UINavigationController(rootViewController: controller)
                    nav.navigationBar.isHidden = true
                    appDel.window?.rootViewController = nav
//                    self.customTabBarController?.selectedIndex = 2
                }
                self.present(controller, animated: true, completion: nil)
//                commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "  Payment Successful      ", strCancelButtonTitle: "", strDescription: json["data"].string ?? "", strTitle: "", isShowImage: true, strImage: "ic_popupPaymentSucessful", isCancleOrder: false, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func refreshAddPaymentScreen() {
        webserviceGetAddPayment()
    }
    func webServiceDeletePaymentCard(strCardId: String){
        let deleteCardModel = AddPaymentDeleteReqModel()
        deleteCardModel.card_id = strCardId
        deleteCardModel.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.removePaymentList(removePaymentList: deleteCardModel, showHud: false, completion: { (json, status, error) in
            // self.hideHUD()
            if(status) {
                Utilities.showAlertOfAPIResponse(param: json["message"].string ?? "", vc: self)
                self.webserviceGetAddPayment()
            } else {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func apply() {
        let enabledBackgroundColor = UIColor.clear
        let enabledBorderColor = UIColor(hexString: "FFFFFF")
        let enabledTextColor = UIColor(hexString: "FFFFFF")
        let activeBorderColor = UIColor(hexString: "FFFFFF")
        
        FormTextField.appearance().clearButtonMode = .never
        
        FormTextField.appearance().borderWidth = 0
        FormTextField.appearance().placeHolderColor = enabledBorderColor
        FormTextField.appearance().clearButtonColor = activeBorderColor
        FormTextField.appearance().font = CustomFont.NexaRegular.returnFont(15)
        
        FormTextField.appearance().enabledBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().enabledBorderColor = enabledBorderColor
        FormTextField.appearance().enabledTextColor = enabledTextColor
        
        FormTextField.appearance().validBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().validBorderColor = enabledBorderColor
        FormTextField.appearance().validTextColor = enabledTextColor
        
        FormTextField.appearance().activeBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().activeBorderColor = activeBorderColor
        FormTextField.appearance().activeTextColor = enabledTextColor
        
        FormTextField.appearance().inactiveBackgroundColor = enabledBackgroundColor
        FormTextField.appearance().inactiveBorderColor = enabledBorderColor
        FormTextField.appearance().inactiveTextColor = enabledTextColor
        
        FormTextField.appearance().disabledBackgroundColor = UIColor(hexString: "DFDFDF")
        FormTextField.appearance().disabledBorderColor = UIColor(hexString: "DFDFDF")
        FormTextField.appearance().disabledTextColor = UIColor.white
        
        FormTextField.appearance().invalidBackgroundColor = UIColor(hexString: "FFC9C8")
        FormTextField.appearance().invalidBorderColor = UIColor(hexString: "FF4B47")
        FormTextField.appearance().invalidTextColor = UIColor(hexString: "FF4B47")
    }
}
//extension addPaymentVC {
//    func WebServiceCallForOrder(OrderJson:String){
//
//        let ReqModel = OrderReqModel()
//        ReqModel.order_data = OrderJson
//        WebServiceSubClass.PlaceOrder(OrderModel: ReqModel, showHud: false, completion: { (json, status, response) in
//            if(status)
//            {
//                commonPopup.customAlert(isHideCancelButton: true, isHideSubmitButton: false, strSubmitTitle: "  Payment Successful      ", strCancelButtonTitle: "", strDescription: json["data"].string ?? "", strTitle: "", isShowImage: true, strImage: "ic_popupPaymentSucessful", isCancleOrder: false, submitBtnColor: colors.appGreenColor, cancelBtnColor: colors.appRedColor, viewController: self)
//            }
//            else
//            {
//                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
//            }
//        })
//
//    }

//}
