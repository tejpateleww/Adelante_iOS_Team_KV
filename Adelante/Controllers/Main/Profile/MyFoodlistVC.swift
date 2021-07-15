//
//  MyFoodlistVC.swift
//  Adelante
//
//  Created by baps on 04/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

class MyFoodlistVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,SkeletonTableViewDataSource {

    // MARK: - Properties
    var responseStatus : webserviceResponse = .initial
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var arrOrderData = [ItemList]()
    var strcartitemid = ""
    var objFoodlist : myFoodlistDatum?
    // MARK: - IBOutlet
    @IBOutlet weak var tblFoodLIst: UITableView!
    {
        didSet{
            tblFoodLIst.isSkeletonable = true
        }
    }

    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        tblFoodLIst.showAnimatedSkeleton()
        webserviceGetFoodlist()
        tblFoodLIst.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(webserviceGetFoodlist), for: .valueChanged)
        tblFoodLIst.reloadData()
        setup()
    }
    
    // MARK: - Other Methods
    func registerNIB(){
        tblFoodLIst.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblFoodLIst.register(UINib(nibName: "ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myFoodlist.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.clearAll.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func btnClearAllClick() {
        webserviceRemoveCart()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - IBActions
    
    @IBAction func btnAddToCartClick(_ sender: Any) {
        webservicefoodlisttocart()
    }
    // MARK: - SkeletonTableview Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrOrderData.count > 0 ? MyFoodlistCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 10
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrOrderData.count != 0 {
                return self.arrOrderData.count
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if responseStatus == .gotData{
            if arrOrderData.count != 0{
                let cell:MyFoodlistCell = tblFoodLIst.dequeueReusableCell(withIdentifier: "MyFoodlistCell", for: indexPath) as! MyFoodlistCell
                self.strcartitemid = arrOrderData[indexPath.row].cartItemId
                cell.lblComboTitle.text = arrOrderData[indexPath.row].itemName
                cell.lblPrice.text = arrOrderData[indexPath.row].price
                cell.lblDisc.text = arrOrderData[indexPath.row].descriptionField
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrOrderData[indexPath.row].itemImg ?? "")"
                cell.imgFoodLIst.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgFoodLIst.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                if arrOrderData[indexPath.row].qty.toInt() > 0{
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                }else{
                    cell.btnAdd.isHidden = false
                    cell.vwStapper.isHidden = true
                }
                cell.IncreseData = {
                    self.webserviceUpdateCartQuantity(strItemid: self.arrOrderData[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
                }
                cell.decreaseData = {
                    self.webserviceUpdateCartQuantity(strItemid: self.arrOrderData[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
                }
                cell.btnAddAction = {
                    cell.btnAdd.isHidden = true
                    cell.vwStapper.isHidden = false
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = tblFoodLIst.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "MyFoodlist")
                NoDatacell.lblNoDataTitle.isHidden = true//text = "Be The First to Rate This Store".Localized()
                NoDatacell.selectionStyle = .none
                return NoDatacell
            }
        }else{
            let cell = tblFoodLIst.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrOrderData.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }else {
            return self.responseStatus == .gotData ?  230 : 131
        }
    }
    
    // MARK: - Api Calls
    @objc func webserviceGetFoodlist(){
        let GetfoodList = GetFoodlistReqModel()
        GetfoodList.user_id = SingletonClass.sharedInstance.UserId
        
        WebServiceSubClass.GetFoodList(getFoodlistModel: GetfoodList, showHud: false,completion: { (response, status, error) in
            self.refreshList.endRefreshing()
            self.responseStatus = .gotData
            let cell = self.tblFoodLIst.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
            cell.stopShimmering()
            self.tblFoodLIst.stopSkeletonAnimation()
            self.tblFoodLIst.dataSource = self
            self.tblFoodLIst.isScrollEnabled = true
            self.tblFoodLIst.isUserInteractionEnabled = true
            self.tblFoodLIst.reloadData()
            if status{
                let myfoodlistData = MyFoodLIstResModel.init(fromJson: response)
                self.arrOrderData = myfoodlistData.data.item
                self.objFoodlist = myfoodlistData.data
                self.tblFoodLIst.reloadData()
                DispatchQueue.main.async {
                    self.refreshList.endRefreshing()
                }
            }
            else
            {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func webserviceRemoveCart(){
        let clearFoodlist = RemoveCartReqModel()
//        clearFoodlist.cart_item_id = strcartitemid
        clearFoodlist.user_id = SingletonClass.sharedInstance.UserId
        clearFoodlist.type = "1"
        WebServiceSubClass.removeFoodList(removeFoodList: clearFoodlist, showHud: false,completion: { (json, status, error) in
            // self.hideHUD()
            if(status) {
                Utilities.showAlertOfAPIResponse(param: json["message"].string ?? "", vc: self)
                self.arrOrderData.removeAll()
                self.webserviceGetFoodlist()
            } else {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection!")
            }
        })
    }
    func webserviceUpdateCartQuantity(strItemid:String,strQty:String,strType:String,row:Int){
        let updateCart = UpdateCardQtyReqModel()
        updateCart.cart_item_id = strItemid
        updateCart.qty = strQty
        updateCart.type = strType
        updateCart.search = ""
        updateCart.status = "1"
        WebServiceSubClass.UpdateItemQty(updateQtyModel: updateCart, showHud: true){ (json, status, response) in
            if(status)
            {
                let cartData = updateCartResModel.init(fromJson: json)
                self.arrOrderData = cartData.data.item
                let index = IndexPath(row: row, section: 0)
                let cell = self.tblFoodLIst.cellForRow(at: index) as! MyFoodlistCell
                for i in 0...self.arrOrderData.count - 1{
                    if strItemid == self.arrOrderData[i].cartItemId{
                        cell.lblNoOfItem.text = self.arrOrderData[i].qty
                    }
                }
//                Utilities.displayAlert(json["message"].string ?? "")
                self.tblFoodLIst.reloadData()
              //  self.setData()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
    func webservicefoodlisttocart(){
        let strURL = APIEnvironment.baseURL + ApiKey.FoodlisttoCart.rawValue + "/" + (objFoodlist?.foodlistId ?? "")
        WebServiceSubClass.foodlisttocart(strURL: strURL, completion: { (json, status, response) in
            if(status)
            {
                let vc =  AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "checkOutVC") as! checkOutVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
}


class shimmerView : UIView{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.startShimmeringAnimation(animationSpeed: 1.4, direction: .leftToRight, repeatCount: 1000)

    }
}
