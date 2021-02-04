//
//  RestaurantListVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,favoriteDelegate{
    
  
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrRestaurantList = [RestaurantList]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var strItemId = ""
    var strItemType = ""
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var btnFilterOptions: UIButton!
    @IBOutlet weak var lblAllRestaurants: themeLabel!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        setUpLocalizedStrings()
//        webserviceGetRestaurantList(strSearch: "", strFilter: "")
        txtSearch.backgroundImage = UIImage()
        let button = UIButton()
        //        button.backgroundColor = .green
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
//        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        
        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavList), name: notifRefreshRestaurantList, object: nil)
        
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webserviceGetRestaurantList(strSearch: "", strFilter: "")
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - Other Methods
    @objc func refreshFavList() {
        pageNumber = 1
        self.isNeedToReload = true
        self.webserviceGetRestaurantList(strSearch: "", strFilter: "")
    }
    
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.restaurantList.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        NotificationCenter.default.removeObserver(self, name: notifDeSelectFilterRestaurant, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: notifDeSelectFilterRestaurant, object: nil)
        
        btnFilterOptions.isSelected = false
        self.changeLayoutOfFilterButton()
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
    }
    func setUpLocalizedStrings(){
        txtSearch.placeholder = "RestaurantListVC_txtSearch".Localized()
        lblAllRestaurants.text = "RestaurantListVC_lblAllRestaurants".Localized()
    }
    @objc func deSelectFilterAndRefresh() {
        btnFilterOptions.isSelected = false
        changeLayoutOfFilterButton()
    }
    
    func changeLayoutOfFilterButton() {
        if btnFilterOptions.isSelected {
            btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
        } else {
            btnFilterOptions.backgroundColor = colors.segmentDeselectedColor.value
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
            webserviceGetRestaurantList(strSearch: "", strFilter: "")
        }
        // done, do whatever
    }
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
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
            var Select = arrRestaurantList[sender.tag].favourite ?? ""
            let restaurantId = arrRestaurantList[sender.tag].id ?? ""
            if Select == "1"{
                Select = "0"
            }else{
                Select = "1"
            }
            webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
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
        return arrRestaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier, for: indexPath) as! RestaurantListCell
        cell.lblName.text = arrRestaurantList[indexPath.row].name
        cell.lblRating.text = arrRestaurantList[indexPath.row].review
        cell.lblMiles.text = String(format: "HomeVC_RestaurantCell_lblMiles".Localized(), arrRestaurantList[indexPath.row].distance)
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrRestaurantList[indexPath.row].image ?? "")"
        cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
        if arrRestaurantList[indexPath.row].favourite == "1"{
            cell.btnFavorite.isSelected = true
        }else{
            cell.btnFavorite.isSelected = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
        restDetailsVc.selectedRestaurantId = arrRestaurantList[indexPath.row].id
        restDetailsVc.isFromRestaurantList = true
        restDetailsVc.selectedIndex = "\(indexPath.row)"
        self.navigationController?.pushViewController(restDetailsVc, animated: true)
    }
    
    // MARK: - Api Calls
    @objc func webserviceGetRestaurantList(strSearch:String,strFilter:String){
        let RestaurantList = RestaurantListReqModel()
        RestaurantList.user_id = SingletonClass.sharedInstance.UserId
        RestaurantList.filter = strFilter
        RestaurantList.item = strSearch
        RestaurantList.page = "\(pageNumber)"
        RestaurantList.item_id = strItemId
        RestaurantList.item_type = strItemType
        RestaurantList.page = "\(pageNumber)"
        WebServiceSubClass.RestaurantList(RestaurantListmodel: RestaurantList, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantListResModel.init(fromJson: response)
                if self.pageNumber == 1 {
                    self.arrRestaurantList = restaurantData.data
                } else {
                    let arrTemp = restaurantData.data
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrRestaurantList.append(arrTemp![i])
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    }
                }
                self.tblMainList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            if self.arrRestaurantList.count > 0{
                self.tblMainList.restore()
            }else {
                self.tblMainList.setEmptyMessage("emptyMsg_Restaurant".Localized())
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
            // self.hideHUD()
            if status{
                self.arrRestaurantList.first(where: { $0.id == strRestaurantId })?.favourite = Status
                self.tblMainList.reloadData()
                NotificationCenter.default.post(name: notifRefreshDashboardList, object: nil)
                NotificationCenter.default.post(name: notifRefreshFavouriteList, object: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func refreshFavoriteScreen() {
        webserviceGetRestaurantList(strSearch: "", strFilter: "")
    }
}
extension RestaurantListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if lastSearchTxt.isEmpty {
            lastSearchTxt = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.7)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        if query.count > 2{
            webserviceGetRestaurantList(strSearch: query, strFilter: "")
        }
    }
}
