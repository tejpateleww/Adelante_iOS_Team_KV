//
//  RestaurantListVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

class RestaurantListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, SortListDelegate,SkeletonTableViewDataSource{
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var selectedSortTypedIndexFromcolVwFilter = 1
    var responseStatus : webserviceResponse = .initial
    var arrRestaurantList = [RestaurantList]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var strItemId = ""
    var strItemType = ""
    var SelectFilterId = ""
    var isRefresh = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!{
        didSet{
            tblMainList.isSkeletonable = true
        }
    }
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var btnFilterOptions: UIButton!
    @IBOutlet weak var lblAllRestaurants: themeLabel!
    @IBOutlet weak var imgEmptyRestaurant: UIImageView!
    @IBOutlet weak var vwFilter: UIView!
    


    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        txtSearch.delegate = self
        tblMainList.stopSkeletonAnimation()
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        setUpLocalizedStrings()
        txtSearch.backgroundImage = UIImage()
        let button = UIButton()
        //        button.backgroundColor = .green
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        NotificationCenter.default.removeObserver(self, name: notifRefreshRestaurantList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavList), name: notifRefreshRestaurantList, object: nil)
        setup()
    }
    func registerNIB(){
        tblMainList.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblMainList.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        webserviceGetRestaurantList(strSearch: "", strFilter: "")
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - Other Methods
    @objc func refreshFavList() {
        self.pageNumber = 1
        self.isRefresh = true
        self.isNeedToReload = true
        self.webserviceGetRestaurantList(strSearch: "", strFilter: "")
    }
    func SelectedSortList(_ SortId: String) {
        DispatchQueue.main.async {
            self.selectedSortTypedIndexFromcolVwFilter = -1
            self.tblMainList.reloadData()
        }
        if SingletonClass.sharedInstance.topSellingId != "" && SortId == SingletonClass.sharedInstance.topSellingId{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CategoryVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.SelectFilterId = SortId
            pageNumber = 1
            webserviceGetRestaurantList(strSearch: "", strFilter: "")
        }
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
        if self.isNeedToReload && self.isRefresh == false{
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
            webserviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.tblMainList.reloadData()
            }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = 1
//                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
//                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
                self.tblMainList.reloadData()
            } else {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                self.tblMainList.reloadData()
            }
            if self.selectedSortTypedIndexFromcolVwFilter == 0 {
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID) as! sortPopupVC
                vc.delegateFilter = self
                vc.selectedSortData = self.SelectFilterId
                let navController = UINavigationController.init(rootViewController: vc)
                navController.modalPresentationStyle = .overFullScreen
                navController.navigationController?.modalTransitionStyle = .crossDissolve
                navController.navigationBar.isHidden = true
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    //MARK: - skeletontableview datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrRestaurantList.count > 0 ? RestaurantListCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 5
        }
        return 3
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrRestaurantList.count != 0 {
                return self.arrRestaurantList.count
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if responseStatus == .gotData{
            if arrRestaurantList.count != 0 {
                let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier, for: indexPath) as! RestaurantListCell
                cell.lblName.text = arrRestaurantList[indexPath.row].name
                cell.lblRating.text = arrRestaurantList[indexPath.row].review
                cell.lblMiles.text = arrRestaurantList[indexPath.row].distance
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrRestaurantList[indexPath.row].image ?? "")"
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
            }else
            {
                let NoDatacell = tblMainList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
                NoDatacell.lblNoDataTitle.text = "No_data_favorite".Localized()
                
                return NoDatacell
            }
        }else{
            let cell = tblMainList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrRestaurantList.count == 0{
            print("No Data Found")
        }else{
            let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
            restDetailsVc.selectedRestaurantId = arrRestaurantList[indexPath.row].id
            restDetailsVc.isFromRestaurantList = true
            restDetailsVc.selectedIndex = "\(indexPath.row)"
            self.navigationController?.pushViewController(restDetailsVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.responseStatus == .gotData ?  230 : 131
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
        RestaurantList.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        RestaurantList.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.RestaurantList(RestaurantListmodel: RestaurantList, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            self.responseStatus = .gotData
            if status{
                let restaurantData = RestaurantListResModel.init(fromJson: response)
                let cell = self.tblMainList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
                cell.stopShimmering()
                self.tblMainList.stopSkeletonAnimation()
                self.isRefresh = false
                if self.pageNumber == 1 {
                    self.arrRestaurantList = restaurantData.data
                    let arrTemp = restaurantData.data
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                } else {
                    let arrTemp = restaurantData.data
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrRestaurantList.append(arrTemp![i])
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                }
                self.tblMainList.dataSource = self
                self.tblMainList.isScrollEnabled = true
                self.tblMainList.isUserInteractionEnabled = true
                self.tblMainList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
//            if self.arrRestaurantList.count > 0{
//                self.tblMainList.restore()
//                self.imgEmptyRestaurant.isHidden = true
//                self.tblMainList.isHidden = false
//                self.vwFilter.isHidden = false
//            }else {
//                self.imgEmptyRestaurant.isHidden = false
//                self.tblMainList.isHidden = true
//                self.vwFilter.isHidden = true
//            }


            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    func webserviceFavorite(strRestaurantId:String,Status:String){
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
//        txtSearch.resignFirstResponder()
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        if query == ""{
            webserviceGetRestaurantList(strSearch: query, strFilter: "")
        }else{
            if query.count > 2{
//                txtSearch.resignFirstResponder()
                self.pageNumber = 1
                webserviceGetRestaurantList(strSearch: query, strFilter: "")
            }
        }
    }
}
