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
    var PromoCodeList : [Promocode]?
    //MARK: - IBOutlets
    @IBOutlet weak var tblPromoCode: UITableView!
    @IBOutlet weak var TextFieldPromoCode: UITextField!
    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        setValue()
        
        tblPromoCode.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        
        tblPromoCode.delegate = self
        tblPromoCode.dataSource = self
        tblPromoCode.reloadData()
        
        WebserviceCallForFetchPromocode(restaurant_id: RestuarantID)
        
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.PromocodeVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
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
            self.WebserviceCallForPromocodeApply(PromocodeID: "", Promocode: self.TextFieldPromoCode.text?.trim() ?? "")
        }
    }
    
    
    
}
extension PromocodeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.PromoCodeList?.count == 0 {
            return 1
        } else {
            return PromoCodeList?.count ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if PromoCodeList?.count == 0 {
            return tableView.frame.size.height
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.PromoCodeList?.count ?? 0) != 0 {
        let cell:PromocodeCell = tblPromoCode.dequeueReusableCell(withIdentifier: PromocodeCell.reuseIdentifier, for: indexPath)as! PromocodeCell
        cell.lblPromoCode.text = PromoCodeList?[indexPath.row].promocode
        switch PromoCodeList?[indexPath.row].offerType.lowercased() {
        case "flat":
           
            cell.lblOfferDescription.text = "Get flat \(CurrencySymbol)\(PromoCodeList?[indexPath.row].percentage.ConvertToTwoDecimal() ?? "")"
            
            cell.lblValidOn.text = "Use code \(PromoCodeList?[indexPath.row].promocode ?? "") & get flat \(CurrencySymbol)\(PromoCodeList?[indexPath.row].percentage.ConvertToTwoDecimal() ?? "") on orders above \(CurrencySymbol)\(PromoCodeList?[indexPath.row].minAmount.ConvertToTwoDecimal() ?? "")"
            
         
        case "discount":
          
            cell.lblOfferDescription.text = "Get \(PromoCodeList?[indexPath.row].percentage ?? "")% discount"
            cell.lblValidOn.text = "Use code \(PromoCodeList?[indexPath.row].promocode ?? "") & get \(PromoCodeList?[indexPath.row].percentage ?? "")% discount upto \(CurrencySymbol)\(PromoCodeList?[indexPath.row].minAmount.ConvertToTwoDecimal() ?? "") on orders above \(CurrencySymbol)\(PromoCodeList?[indexPath.row].maxAmount.ConvertToTwoDecimal() ?? "")"
            
        default:
            break
        }
        
        cell.ApplyClickClosour = {
            self.WebserviceCallForPromocodeApply(PromocodeID: self.PromoCodeList?[indexPath.row].id ?? "", Promocode: self.PromoCodeList?[indexPath.row].promocode ?? "")
        }
        
        return cell
        
        } else {
            let NoDatacell = tblPromoCode.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            
            NoDatacell.imgNoData.image = UIImage(named: NoData.promocode.ImageName)
            NoDatacell.lblNoDataTitle.text = "No promocode found".Localized()
            NoDatacell.selectionStyle = .none
            return NoDatacell
        }
    }
    
}
//MARK: - API Calls
extension PromocodeVC {
    func WebserviceCallForFetchPromocode(restaurant_id:String){
        let PromocodeList = PromocodeListReqModel()
        PromocodeList.restaurant_id = restaurant_id
        PromocodeList.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.PromoCodeList(PromocodeModel: PromocodeList, showHud: false, completion: { (response, status, error) in
            
            if status{
                let ResModel = PromoCodeResModel.init(fromJson: response)
                self.PromoCodeList = ResModel.promocode
                
                self.tblPromoCode.reloadData()
              
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func WebserviceCallForPromocodeApply(PromocodeID:String,Promocode:String){
        let ApplyPromoCode = PromocodeApplyReqModel()
        ApplyPromoCode.promocode = Promocode
        ApplyPromoCode.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.ApplyPromoCode(PromocodeModel: ApplyPromoCode, showHud: false, completion: { (response, status, error) in
            
            if status{
                self.navigationController?.popViewController(animated: true)
                let ResModel = PromocodeAppliedResModel.init(fromJson: response)
                print(ResModel.promocode.toDictionary())
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PromocodeApply"), object: nil, userInfo: ResModel.promocode.toDictionary())

                
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}
