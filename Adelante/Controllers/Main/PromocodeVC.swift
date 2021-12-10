//
//  PromocodeVC.swift
//  Adelante
//
//  Created by Admin on 06/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class PromocodeVC: BaseViewController {
    //MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var RestuarantID = ""
    var cartID = ""
    var PromoCodeList = [Promocode]()
    var ApplyPromoAmount: ((ApplyPromoDatum)-> ())?
    //MARK: - IBOutlets
    @IBOutlet weak var tblPromoCode: UITableView!
    @IBOutlet weak var TextFieldPromoCode: UITextField!
    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        setValue()
        WebserviceCallForFetchPromocode()
        tblPromoCode.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        TextFieldPromoCode.placeholder = "Enter Promocode"
        tblPromoCode.delegate = self
        tblPromoCode.dataSource = self
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.PromocodeVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        
    }
    
    //MARK: - other methods
    func setLocalization() {
        
    }
    func setValue() {
    }
    //MARK: - IBActions
    
    
    @IBAction func ApplyPromoCodeAction(_ sender: Any) {
        if TextFieldPromoCode.text?.trim() == "" {
            Utilities.ShowAlert(OfMessage: "Please enter promocode")
        } else {
        }
    }
}
extension PromocodeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.PromoCodeList.count == 0 {
            return 1
        } else {
            return PromoCodeList.count 
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if PromoCodeList.count == 0 {
            return tableView.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if PromoCodeList.count != 0 {
            let cell:PromocodeCell = tblPromoCode.dequeueReusableCell(withIdentifier: PromocodeCell.reuseIdentifier, for: indexPath)as! PromocodeCell
            cell.lblPromoCode.text = PromoCodeList[indexPath.row].promocode
            switch PromoCodeList[indexPath.row].offerType.lowercased() {
            case "flat":
                cell.lblOfferDescription.text = "Get flat \(CurrencySymbol)\(PromoCodeList[indexPath.row].percentage.ConvertToTwoDecimal() )"
                
                cell.lblValidOn.text = "Use code \(PromoCodeList[indexPath.row].promocode ?? "") & get flat \(CurrencySymbol)\(PromoCodeList[indexPath.row].percentage.ConvertToTwoDecimal() ) on orders above \(CurrencySymbol)\(PromoCodeList[indexPath.row].minAmount.ConvertToTwoDecimal() )"
            case "discount":
                cell.lblOfferDescription.text = "Get \(PromoCodeList[indexPath.row].percentage ?? "")% discount"
                cell.lblValidOn.text = "Use code \(PromoCodeList[indexPath.row].promocode ?? "") & get \(PromoCodeList[indexPath.row].percentage ?? "")% discount upto \(CurrencySymbol)\(PromoCodeList[indexPath.row].minAmount.ConvertToTwoDecimal() ) on orders above \(CurrencySymbol)\(PromoCodeList[indexPath.row].maxAmount.ConvertToTwoDecimal() )"
            default:
                break
            }
            if PromoCodeList[indexPath.row].applied == "1"{
                cell.btnApply.setTitle("Applied", for: .normal)
                cell.btnApply.setTitleColor(UIColor.gray, for: .normal)
                cell.btnApply.isUserInteractionEnabled = false
            }else{
                cell.ApplyClickClosour = {
                    self.WebserviceCallForPromocodeApply(promocode: self.PromoCodeList[indexPath.row].promocode ?? "")
                }
            }
            return cell
            
        } else {
            let NoDatacell = tblPromoCode.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            NoDatacell.lblNoDataTitle.text = "No promocode found"
            NoDatacell.selectionStyle = .none
            return NoDatacell
        }
    }
    
}
//MARK: - API Calls
extension PromocodeVC {
    func WebserviceCallForFetchPromocode(){
        let PromocodeList = PromocodeListReqModel()
        PromocodeList.restaurant_id = RestuarantID
        PromocodeList.user_id = SingletonClass.sharedInstance.UserId
        PromocodeList.cart_id = cartID
        WebServiceSubClass.PromoCodeList(PromocodeModel: PromocodeList, showHud: false, completion: { (response, status, error) in
            if status{
                let ResModel = PromoCodeResModel.init(fromJson: response)
                self.PromoCodeList = ResModel.promocode
                DispatchQueue.main.async {
                    self.tblPromoCode.reloadData()
                }
                
                
            }else{
                let alert = UIAlertController(title: AppName, message: response["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(OkAction)
                appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        })
    }
    func WebserviceCallForPromocodeApply(promocode:String){
        let ApplyPromoCode = PromocodeApplyReqModel()
        ApplyPromoCode.promocode = promocode
        ApplyPromoCode.user_id = SingletonClass.sharedInstance.UserId
        ApplyPromoCode.cart_id = cartID
        WebServiceSubClass.ApplyPromoCode(PromocodeModel: ApplyPromoCode, showHud: true, completion: { (response, status, error) in
            
            if status{
                let ResModel = applyPromocodeResModel.init(fromJson: response)
                let alert = UIAlertController(title: AppName, message: response["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                if let promocodeapply = self.ApplyPromoAmount{
                    if ResModel.data == nil{
                        let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(OkAction)
                    }else{
                        let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(OkAction)
                        promocodeapply(ResModel.data)
                    }
                }
                
                appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: AppName, message: error as? String, preferredStyle: UIAlertController.Style.alert)
                let OkAction = UIAlertAction(title:"OK" , style: .default) { (sct) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(OkAction)
            }
        })
    }
}
