//
//  FavouritesVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

protocol favoriteDelegate{
    func refreshFavoriteScreen()
}

class FavouritesVC: BaseViewController, UITableViewDelegate, SkeletonTableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITableViewDataSource {
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var responseStatus : webserviceResponse = .initial
    var arrFavoriteRest = [RestaurantFavorite]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var selectedRestaurantId = ""
    var delegateFav : favoriteDelegate!
    var isRefresh = false
    let ScreenHeight = UIScreen.main.bounds.height
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!{
        didSet {
            tblMainList.isSkeletonable  = true
        }
    }
    
    @IBOutlet weak var txtSearch: UISearchBar!
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNIB()
        txtSearch.delegate = self
        setUpLocalizedStrings()
        self.tblMainList.showAnimatedSkeleton()
        webservicePostRestaurantFav(strSearch: "")
      
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        txtSearch.backgroundImage = UIImage()
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        setup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
        webservicePostRestaurantFav(strSearch: "")
    }
    func registerNIB(){
        tblMainList.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblMainList.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.favourites.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
        NotificationCenter.default.removeObserver(self, name: notifRefreshFavouriteList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavList), name: notifRefreshFavouriteList, object: nil)
    }
    @objc func refreshFavList() {
        self.pageNumber = 1
        self.isNeedToReload = true
        self.isRefresh = true
        self.webservicePostRestaurantFav(strSearch: "")
    }
    func setUpLocalizedStrings() {
        txtSearch.placeholder = "FavouritesVC_txtSearch".Localized()
    }
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        var Select = arrFavoriteRest[sender.tag].favourite ?? ""
        let restaurantId = arrFavoriteRest[sender.tag].restaurantId ?? ""
        if Select == "1"{
            Select = "0"
        }else{
            Select = "1"
        }
        webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if self.isNeedToReload && self.isRefresh == false{
            self.pageNumber = self.pageNumber + 1
            webservicePostRestaurantFav(strSearch: "")
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrFavoriteRest.count > 0 ? YourFavouriteCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.responseStatus == .gotData{
            return 0
        }
        return 3
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrFavoriteRest.count != 0 {
                return self.arrFavoriteRest.count
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrFavoriteRest.count != 0 {
                return 230
            }else{
                return tableView.frame.height
            }
        }else {
            return self.responseStatus == .gotData ?  230 : 131
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if responseStatus == .gotData{
            if arrFavoriteRest.count != 0 {
                let cell = tblMainList.dequeueReusableCell(withIdentifier: YourFavouriteCell.reuseIdentifier, for: indexPath) as! YourFavouriteCell
                cell.lblItemName.text = arrFavoriteRest[indexPath.row].name
                cell.lblRating.text = arrFavoriteRest[indexPath.row].review
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrFavoriteRest[indexPath.row].image ?? "")"
                cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.btnFavorite.tag = indexPath.row
                cell.btnFavorite.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
                if arrFavoriteRest[indexPath.row].favourite == "1"{
                    cell.btnFavorite.isSelected = true
                }else{
                    cell.btnFavorite.isSelected = false
                }
                cell.selectionStyle = .none
                return cell
            }
            else {
                let NoDatacell = tblMainList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: "Favorite LIst")
                NoDatacell.lblNoDataTitle.isHidden = true
                
                return NoDatacell
            }
        }else{
            let cell = tblMainList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrFavoriteRest.count == 0{
            print("No Data Found")
        }else{
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
            controller.selectedRestaurantId = arrFavoriteRest[indexPath.row].restaurantId
            controller.selectedIndex = "\(indexPath.row)"
            controller.isFromFavoriteList = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - Api Calls
    @objc func webservicePostRestaurantFav(strSearch : String){
        let RestaurantFavorite = RestaurantFavoriteReqModel()
        RestaurantFavorite.name = strSearch
        RestaurantFavorite.user_id = SingletonClass.sharedInstance.UserId
        RestaurantFavorite.page = "\(self.pageNumber)"
        WebServiceSubClass.RestaurantFavorite(RestaurantFavoritemodel: RestaurantFavorite, showHud: false, completion: { (response, status, error) in
            self.refreshList.endRefreshing()
            self.responseStatus = .gotData
            if status{
                let restaurantData = RestaurantFavResModel.init(fromJson: response)
                let cell = self.tblMainList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
                cell.stopShimmering()
                self.tblMainList.stopSkeletonAnimation()
                
                if self.pageNumber == 1 {
                    self.arrFavoriteRest = restaurantData.data.restaurantDetails
                    self.isRefresh = false
                    let arrTemp = restaurantData.data.restaurantDetails
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                } else {
                    let arrTemp = restaurantData.data.restaurantDetails
                    if (arrTemp?.count ?? 0) > 0 {
                        for i in 0..<arrTemp!.count {
                            if self.arrFavoriteRest.contains(where: {$0.id == arrTemp![i].id}) {
                            } else {
                                self.arrFavoriteRest.append(arrTemp![i])
                            }
                        }
                    }
                    if (arrTemp?.count ?? 0) < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                }
                self.tblMainList.dataSource = self
                self.tblMainList.isScrollEnabled = true
                self.tblMainList.isUserInteractionEnabled = true
                self.tblMainList.reloadData()
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
            if status{
                self.pageNumber = 1
                self.webservicePostRestaurantFav(strSearch: "")
                NotificationCenter.default.post(name: notifRefreshDashboardList, object: nil)
                NotificationCenter.default.post(name: notifRefreshRestaurantList, object: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}
extension FavouritesVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if lastSearchTxt.isEmpty {
            lastSearchTxt = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.7)
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        if query == ""{
            webservicePostRestaurantFav(strSearch: "")
        }else{
            if query.count > 2{
                self.pageNumber = 1
                webservicePostRestaurantFav(strSearch: query)
                
            }
        }
    }
}
