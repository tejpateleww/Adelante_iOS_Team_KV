//
//  FavouritesVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

protocol favoriteDelegate{
    func refreshFavoriteScreen()
}

class FavouritesVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFavoriteRest = [RestaurantFavorite]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var selectedRestaurantId = ""
    var delegateFav : favoriteDelegate!
    var isRefresh = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var imgFavorite: UIImageView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        setUpLocalizedStrings()
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        txtSearch.backgroundImage = UIImage()
        let button = UIButton()
        //        button.backgroundColor = .green
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        setup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
        //        pageNumber = 1
        webservicePostRestaurantFav(strSearch: "")
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.favourites.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearch.frame.height))
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
        // done, do whatever
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavoriteRest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainList.dequeueReusableCell(withIdentifier: YourFavouriteCell.reuseIdentifier, for: indexPath) as! YourFavouriteCell
        cell.lblItemName.text = arrFavoriteRest[indexPath.row].name
        cell.lblRating.text = arrFavoriteRest[indexPath.row].review
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrFavoriteRest[indexPath.row].image ?? "")"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
        controller.selectedRestaurantId = arrFavoriteRest[indexPath.row].restaurantId
        controller.selectedIndex = "\(indexPath.row)"
        controller.isFromFavoriteList = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Api Calls
    @objc func webservicePostRestaurantFav(strSearch : String){
        let RestaurantFavorite = RestaurantFavoriteReqModel()
        RestaurantFavorite.name = strSearch
        RestaurantFavorite.user_id = SingletonClass.sharedInstance.UserId
        RestaurantFavorite.page = "\(self.pageNumber)"
        WebServiceSubClass.RestaurantFavorite(RestaurantFavoritemodel: RestaurantFavorite, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantFavResModel.init(fromJson: response)
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
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            
                            if self.arrFavoriteRest.contains(where: {$0.id == arrTemp![i].id}) {
                             
                            } else {
                             
                                self.arrFavoriteRest.append(arrTemp![i])
                            }
                            
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                }
                DispatchQueue.main.async {
                    self.tblMainList.reloadData()
                }
            } else {
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            //            self.arrFavoriteRest.removeAll()
            //            self.tblMainList.reloadData()
            if self.arrFavoriteRest.count > 0 {
                self.tblMainList.restore()
                self.imgFavorite.isHidden = true
//                self.tblMainList.isHidden = false
                
            } else {
//                self.tblMainList.isHidden = true
                self.imgFavorite.isHidden = false
                //                self.view.bringSubviewToFront(self.imgFavorite)
                //                self.tblMainList.setEmptyMessage("emptyMsg_Restaurant".Localized())
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
            //            self.hideHUD()
            if status{
                self.pageNumber = 1
                self.webservicePostRestaurantFav(strSearch: "")
                //                self.arrFavoriteRest.first(where: { $0.id == strRestaurantId })?.favourite = Status
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
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        txtSearch.resignFirstResponder()
//    }
    @objc private func makeNetworkCall(_ query: String)
    {
//        txtSearch.
        if query == ""{
//            txtSearch.resignFirstResponder()
            webservicePostRestaurantFav(strSearch: "")
            // arrFavoriteRest.removeAll()
            // tblMainList.reloadData()
        }else{
            if query.count > 2{
//                txtSearch.resignFirstResponder()
                self.pageNumber = 1
                webservicePostRestaurantFav(strSearch: query)
                
            }
        }
    }
}
