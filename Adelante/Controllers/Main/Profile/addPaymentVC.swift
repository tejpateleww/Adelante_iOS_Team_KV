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
import SocketIO
import CoreLocation
import GoogleMaps
import BraintreeDropIn

class addPaymentVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource,AddPaymentDelegate {
    
    
    // MARK: - Properties
    var cardDetails : [String] = []
    var customTabBarController: CustomTabBarVC?
    var selectedPaymentMethods: IndexPath?
    var refreshList = UIRefreshControl()
    var arrCard = [CardList]()
    var filterSelect = [0]
    var strCartID = ""
    var direction:CGFloat = 1
    var shakes = 0
    var OrderDetails : String?
    var orderid = ""
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
        setUpLocalizedStrings()
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.addPaymentVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        fetchClientToken()
        imgEmptyCard.isHidden = true
        webserviceGetAddPayment()
    }
    var ClientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpGVXpJMU5pSXNJbXRwWkNJNklqSXdNVGd3TkRJMk1UWXRjMkZ1WkdKdmVDSXNJbWx6Y3lJNkltaDBkSEJ6T2k4dllYQnBMbk5oYm1SaWIzZ3VZbkpoYVc1MGNtVmxaMkYwWlhkaGVTNWpiMjBpZlEuZXlKbGVIQWlPakUyTXpBMU56RTBOalVzSW1wMGFTSTZJakl5WmpKaU56WXpMVE5sTURFdE5HUXdZeTFoTnpJMExUUTFOalUwTVRrNVpEWmhaQ0lzSW5OMVlpSTZJbVJqY0hOd2VUSmljbmRrYW5JemNXNGlMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwyRndhUzV6WVc1a1ltOTRMbUp5WVdsdWRISmxaV2RoZEdWM1lYa3VZMjl0SWl3aWJXVnlZMmhoYm5RaU9uc2ljSFZpYkdsalgybGtJam9pWkdOd2MzQjVNbUp5ZDJScWNqTnhiaUlzSW5abGNtbG1lVjlqWVhKa1gySjVYMlJsWm1GMWJIUWlPblJ5ZFdWOUxDSnlhV2RvZEhNaU9sc2liV0Z1WVdkbFgzWmhkV3gwSWwwc0luTmpiM0JsSWpwYklrSnlZV2x1ZEhKbFpUcFdZWFZzZENKZExDSnZjSFJwYjI1eklqcDdmWDAuMFZtd2JodkIxNlc2RFU5WFdfa1JPXzJqWk13UXR5SVFuU3RxcXhIV25EdU11dlU4ZXQ1RVBRVVZyRjRSMGd3dXZYZE1GWkhFYU9OZk5GdUhxSHJqRlEiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgiLCJmZWF0dXJlcyI6WyJ0b2tlbml6ZV9jcmVkaXRfY2FyZHMiXX0sImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy9kY3BzcHkyYnJ3ZGpyM3FuL2NsaWVudF9hcGkiLCJlbnZpcm9ubWVudCI6InNhbmRib3giLCJtZXJjaGFudElkIjoiZGNwc3B5MmJyd2RqcjNxbiIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwidmVubW8iOiJvZmZsaW5lIiwiY2hhbGxlbmdlcyI6WyJjdnYiLCJwb3N0YWxfY29kZSJdLCJ0aHJlZURTZWN1cmVFbmFibGVkIjp0cnVlLCJhbmFseXRpY3MiOnsidXJsIjoiaHR0cHM6Ly9vcmlnaW4tYW5hbHl0aWNzLXNhbmQuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9kY3BzcHkyYnJ3ZGpyM3FuIn0sImFwcGxlUGF5Ijp7ImNvdW50cnlDb2RlIjoiVVMiLCJjdXJyZW5jeUNvZGUiOiJVU0QiLCJtZXJjaGFudElkZW50aWZpZXIiOiJtZXJjaGFudC5jb20uYnJhaW50cmVlcGF5bWVudHMuYXBwbGUtcGF5LWRlbW8uQnJhaW50cmVlLURlbW8iLCJzdGF0dXMiOiJtb2NrIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4IiwiZGlzY292ZXIiLCJtYWVzdHJvIl19LCJwYXlwYWxFbmFibGVkIjp0cnVlLCJicmFpbnRyZWVfYXBpIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbSIsImFjY2Vzc190b2tlbiI6ImV5SjBlWEFpT2lKS1YxUWlMQ0poYkdjaU9pSkZVekkxTmlJc0ltdHBaQ0k2SWpJd01UZ3dOREkyTVRZdGMyRnVaR0p2ZUNJc0ltbHpjeUk2SW1oMGRIQnpPaTh2WVhCcExuTmhibVJpYjNndVluSmhhVzUwY21WbFoyRjBaWGRoZVM1amIyMGlmUS5leUpsZUhBaU9qRTJNekExTnpFME5qVXNJbXAwYVNJNklqYzJNekl6WVRJMExXTXdaV1l0TkdGaVlTMDVNRGsyTFRZM05ETmpZVGMyTnpRNU9TSXNJbk4xWWlJNkltUmpjSE53ZVRKaWNuZGthbkl6Y1c0aUxDSnBjM01pT2lKb2RIUndjem92TDJGd2FTNXpZVzVrWW05NExtSnlZV2x1ZEhKbFpXZGhkR1YzWVhrdVkyOXRJaXdpYldWeVkyaGhiblFpT25zaWNIVmliR2xqWDJsa0lqb2laR053YzNCNU1tSnlkMlJxY2pOeGJpSXNJblpsY21sbWVWOWpZWEprWDJKNVgyUmxabUYxYkhRaU9uUnlkV1Y5TENKeWFXZG9kSE1pT2xzaWRHOXJaVzVwZW1VaUxDSnRZVzVoWjJWZmRtRjFiSFFpWFN3aWMyTnZjR1VpT2xzaVFuSmhhVzUwY21WbE9sWmhkV3gwSWwwc0ltOXdkR2x2Ym5NaU9udDlmUS5WelZkZHZZSDBTdW1LbGxfeElYbXF5bFVsVldmTEhNX2xCcVVfQmVIOElzMnM3RUQtVjR6bmtWbzRic3pLbVVKMU1ULVBEUmE0NnFGRTZYRG9kcE54USJ9LCJwYXlwYWwiOnsiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJlbnZpcm9ubWVudE5vTmV0d29yayI6dHJ1ZSwidW52ZXR0ZWRNZXJjaGFudCI6ZmFsc2UsImFsbG93SHR0cCI6dHJ1ZSwiZGlzcGxheU5hbWUiOiJBY21lIFdpZGdldHMsIEx0ZC4gKFNhbmRib3gpIiwiY2xpZW50SWQiOm51bGwsInByaXZhY3lVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vcHAiLCJ1c2VyQWdyZWVtZW50VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3RvcyIsImJhc2VVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFzc2V0c1VybCI6Imh0dHBzOi8vY2hlY2tvdXQucGF5cGFsLmNvbSIsImRpcmVjdEJhc2VVcmwiOm51bGwsImVudmlyb25tZW50Ijoib2ZmbGluZSIsImJyYWludHJlZUNsaWVudElkIjoibWFzdGVyY2xpZW50MyIsIm1lcmNoYW50QWNjb3VudElkIjoic3RjaDJuZmRmd3N6eXR3NSIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9fQ=="
    func fetchClientToken() {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            self.ClientToken = String(data: data ?? Data(), encoding: String.Encoding.utf8) ?? ""
            
            
            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
        }.resume()
    }
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        
        let DropIN = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request, handler: { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCanceled == true) {
                print("CANCELED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                let selectedPaymentMethodType = result.paymentMethodType
                let selectedPaymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        })
        DispatchQueue.main.async {
            self.present(DropIN!, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    //MARK: -tblViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                if indexPath == selectedPaymentMethods {
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
                if indexPath == selectedPaymentMethods {
                    cell2.vWMain.layer.borderWidth = 1
                    cell2.vwCvv.isHidden = false
                } else {
                    cell2.vWMain.layer.borderWidth = 0
                    cell2.vwCvv.isHidden = true
                }
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
            if indexPath == selectedPaymentMethods {
                cell.selectPaymentMethodButton.isSelected = true
            }
            else{
                cell.selectPaymentMethodButton.isSelected = false
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
                if isfromPayment{
                    
                }else{
                    let cell1 = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell1
                    cell1.vWMain.layer.borderColor = colors.appRedColor.value.cgColor
                    WebServiceCallForOrder()
                }
            } else {
                let cell2 = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell2
                cell2.vWMain.layer.borderColor = colors.appRedColor.value.cgColor
            }
            selectedPaymentMethods = indexPath
        case 1:
            self.showDropIn(clientTokenOrTokenizationKey: ClientToken)
            let cell = tblPaymentMethod.cellForRow(at: indexPath) as! paymentMethodCell2
            cell.selectPaymentMethodButton.isSelected = !cell.selectPaymentMethodButton.isSelected
            selectedPaymentMethods = indexPath
        default:
            return
        }
        
        tblPaymentMethod.reloadData()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            webServiceDeletePaymentCard(strCardId: self.arrCard[indexPath.row - 1].id)
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
                self.imgEmptyCard.isHidden = true
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
                
            }
        })
        
    }
    func WebServiceCallForOrder(){
        
        let ReqModel = orderPlaceReqModel()
        ReqModel.user_id = SingletonClass.sharedInstance.UserId
        ReqModel.cart_id = strCartID
        WebServiceSubClass.PlaceOrder(OrderModel: ReqModel, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                
                self.orderid = json["order_id"].stringValue
                let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
                controller.isHideCancelButton = true
                controller.isHideSubmitButton = false
                controller.submitBtnTitle = "OK                         "
                controller.cancelBtnTitle = ""
                controller.strDescription = json["data"].string ?? ""
                controller.strPopupTitle = "Payment Successful"
                controller.submitBtnColor = colors.appGreenColor
                controller.cancelBtnColor = colors.appRedColor
                controller.strPopupImage = "ic_popupPaymentSucessful"
                controller.isCancleOrder = true
                
                self.socketManageSetup()
                controller.btnSubmit = {
                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
                    controller.selectedIndex = 2
                    SingletonClass.sharedInstance.selectInProcessInMyOrder = true
                    let nav = UINavigationController(rootViewController: controller)
                    nav.navigationBar.isHidden = true
                    appDel.window?.rootViewController = nav
                }
                self.present(controller, animated: true, completion: nil)
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
            if(status) {
                Utilities.showAlertOfAPIResponse(param: json["message"].string ?? "", vc: self)
                self.webserviceGetAddPayment()
            } else {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
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

extension addPaymentVC{
    func socketManageSetup(){
        SocketIOManager.shared.establishSocketConnection()
        allSocketOffMethods()
        self.SocketOnMethods()
    }
    
    func SocketOnMethods() {
        
        SocketIOManager.shared.socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
            SocketIOManager.shared.isSocketOn = false
        }
        
        SocketIOManager.shared.socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
            SocketIOManager.shared.isSocketOn = true
            
        }
        
        
        print("===========\(SocketIOManager.shared.socket.status)========================",SocketIOManager.shared.socket.status.active)
        SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
            SocketIOManager.shared.isSocketOn = true
            //            self.allSocketOffMethods()
            self.emitSocketUserConnect()
            
            self.allSocketOnMethods()
            
        }
        //Connect User On Socket
        SocketIOManager.shared.establishConnection()
        //MARK: -====== Socket connection =======
        
        print("==============\(SocketIOManager.shared.socket.status)=====================",SocketIOManager.shared.socket.status.active)
        
        if SocketIOManager.shared.socket.status.active{
            self.allSocketOffMethods()
            self.emitSocketUserConnect()
            self.allSocketOnMethods()
        }
    }
    
    
    
    // ON ALL SOCKETS
    func allSocketOnMethods() {
        print("\n\n", #function, "\n\n")
        onSocketConnectUser()
        //        onSocket_SendMessage()
        onSocketUpdateLocation()
        
    }
    
    // OFF ALL SOCKETS
    func allSocketOffMethods() {
        print("\n\n", #function, "\n\n")
        SocketIOManager.shared.socket.off(SocketData.kConnectUser.rawValue)
        //        SocketIOManager.shared.socket.off(SocketKeys.SendMessage.rawValue)
        SocketIOManager.shared.socket.off(SocketData.kLocationTracking.rawValue)
    }
    
    //-------------------------------------
    // MARK:= SOCKET ON METHODS =
    //-------------------------------------
    func onSocketConnectUser(){
        SocketIOManager.shared.socketCall(for: SocketData.kConnectUser.rawValue) { (json) in
            print(#function, "\n ", json)
        }
    }
    
    
    func onSocketUpdateLocation(){
        SocketIOManager.shared.socketCall(for: SocketData.kLocationTracking.rawValue) { (json) in
//            print(#function, "\n ",json)
//            self.driverLat = json.first?.1.first?.1.arrayValue[0].doubleValue ?? 0.0 //json["lat"].doubleValue
//            self.driverLng = json.first?.1.first?.1.arrayValue[1].doubleValue ?? 0.0//json["lng"].doubleValue
//
//            if !self.isgetDriverlocation{
//                self.isgetDriverlocation = true
//                self.mapRouteForcurrentToRestaurant(PickupLat: SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude, PickupLng: SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude, destLat: self.driverLat , DestLng: self.driverLng)
//            }
//            self.updateMarker(lat: self.driverLat, lng: self.driverLng)
//            self.setDriverMarker()
            
        }
    }
    
    //-------------------------------------
    // MARK:= SOCKET EMIT METHODS =
    //-------------------------------------
    
    // Socket Emit Connect user
    func emitSocketUserConnect(){
        print(#function)
        //        customer_id,lat,lng
        let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.UserId
        ]
        SocketIOManager.shared.socketEmit(for: SocketData.kConnectUser.rawValue, with: param)
        self.emitSocketUpdateLocation()
    }
    
    func emitSocketUpdateLocation() {
        print(#function)
//        SocketIOManager.shared.socketEmit(for: SocketData.kDriverLocation.rawValue, with: [:])
        let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.UserId,
                                    "order_id" : self.orderid,
                                    "lat": SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude ,
                                    "lng" :SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude
        ]
        SocketIOManager.shared.socketEmit(for: SocketData.kLocationTracking.rawValue, with: param)
        
    }
}
extension addPaymentVC: GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status
           switch status {
           case .restricted:
             print("Location access was restricted.")
           case .denied:
             print("User denied access to location.")
             // Display the map using the default location.
//             vwMap.isHidden = false
           case .notDetermined:
             print("Location status not determined.")
           case .authorizedAlways: fallthrough
           case .authorizedWhenInUse:
             print("Location status is OK.")
           @unknown default:
             fatalError()
           }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last?.coordinate.latitude)// coordinate.latitude)
        print(locations.last?.coordinate.longitude)
               if let location = locations.last {

                SingletonClass.sharedInstance.userCurrentLocation = location
                
//                self.updateMarker(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
//                setCustomerMarker()
                
            }
              
    }
   
}
