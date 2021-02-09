//
//  RestaurantOutletVC.swift
//  Adelante
//
//  Created by baps on 08/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
class RestaurantOutletVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,favoriteDelegate {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var strItemId = ""
    var strItemType = ""
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var selectedRestaurantId = ""
    var arrOutletList = [OutletData]()
    var strRestaurantName = ""
    // MARK: - IBOutlets
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var btnFilter: collectionVwFilterBtns!
    @IBOutlet weak var tblRestaurantList: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblRestaurantList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(btnTapFavorite ), for: .touchUpInside)
        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavList), name: notifRefreshRestaurantList, object: nil)
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.webserviceGetRestaurantOutlet(strFilter: "")
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - Other Methods
    func setup(){
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.RestaurantOutletVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        NotificationCenter.default.removeObserver(self, name: notifDeSelectFilterRestaurant, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: notifDeSelectFilterRestaurant, object: nil)
        
        btnFilter.isSelected = false
        self.changeLayoutOfFilterButton()
        tblRestaurantList.delegate = self
        tblRestaurantList.dataSource = self
        tblRestaurantList.reloadData()
    }
    func setData(){
        lblRestaurantName.text = strRestaurantName
    }
    @objc func refreshFavList() {
        pageNumber = 1
        self.isNeedToReload = true
        self.webserviceGetRestaurantOutlet(strFilter: "")
    }
    @objc func deSelectFilterAndRefresh() {
        btnFilter.isSelected = false
        changeLayoutOfFilterButton()
    }
    func changeLayoutOfFilterButton() {
        if btnFilter.isSelected {
            btnFilter.backgroundColor = colors.segmentSelectedColor.value
        } else {
            btnFilter.backgroundColor = colors.segmentDeselectedColor.value
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if isNeedToReload {
            pageNumber = pageNumber + 1
            webserviceGetRestaurantOutlet(strFilter: "")
        }
        // done, do whatever
    }
    // MARK: - IBActions
    
    @IBAction func btnTapFavorite(_ sender: UIButton) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
//             vc.delegateFilter = self
//             vc.selectedSortData = self.SelectFilterId
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            var Select = arrOutletList[sender.tag].favourite ?? ""
            let restaurantId = arrOutletList[sender.tag].id ?? ""
            if Select == "1"{
                Select = "0"
            }else{
                Select = "1"
            }
            webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnFilterClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.changeLayoutOfFilterButton()
        } else {
            sender.isSelected = true
            self.changeLayoutOfFilterButton()
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID)
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOutletList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRestaurantList.dequeueReusableCell(withIdentifier: RestaurantOutletListCell.reuseIdentifier,for: indexPath) as! RestaurantOutletListCell
        cell.lblAreaName.text = arrOutletList[indexPath.row].street
        cell.lblAddress.text = arrOutletList[indexPath.row].address
        cell.lblMiles.text = arrOutletList[indexPath.row].distance
        cell.lblRating.text = arrOutletList[indexPath.row].ratingCount
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrOutletList[indexPath.row].image ?? "")"
        cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        cell.btnFavorite.addTarget(self, action: #selector(btnTapFavorite(_:)), for: .touchUpInside)
        if arrOutletList[indexPath.row].favourite == "1"{
            cell.btnFavorite.isSelected = true
        }else{
            cell.btnFavorite.isSelected = false
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
            controller.selectedRestaurantId = arrOutletList[indexPath.row].id
            controller.selectedIndex = "\(indexPath.row)"
            controller.isFromRestaurantOutlets = true
            self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Api Calls
    func webserviceGetRestaurantOutlet(strFilter:String){
        let RestaurantOutletList = RestaurantOutletReqModel()
        RestaurantOutletList.user_id = SingletonClass.sharedInstance.UserId
        RestaurantOutletList.filter = strFilter
        RestaurantOutletList.item = ""
        RestaurantOutletList.page = "\(pageNumber)"
        RestaurantOutletList.restaurant_id = selectedRestaurantId
        RestaurantOutletList.page = "\(pageNumber)"
        RestaurantOutletList.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        RestaurantOutletList.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.RestaurantOutlet(OutletModel: RestaurantOutletList, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantOutletsResModel.init(fromJson: response)
                if self.pageNumber == 1 {
                    self.arrOutletList = restaurantData.data
                    self.setData()
                } else {
                    let arrTemp = restaurantData.data
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrOutletList.append(arrTemp![i])
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    }
                }
                self.tblRestaurantList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            if self.arrOutletList.count > 0{
                self.tblRestaurantList.restore()
            }else {
                self.tblRestaurantList.setEmptyMessage("emptyMsg_Restaurant".Localized())
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    func refreshFavoriteScreen() {
        webserviceGetRestaurantOutlet(strFilter: "")
    }
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = selectedRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
            // self.hideHUD()
            if status{
                self.arrOutletList.first(where: { $0.id == strRestaurantId })?.favourite = Status
                self.tblRestaurantList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}
