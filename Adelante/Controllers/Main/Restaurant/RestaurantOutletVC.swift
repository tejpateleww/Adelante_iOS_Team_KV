//
//  RestaurantOutletVC.swift
//  Adelante
//
//  Created by baps on 08/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView

class RestaurantOutletVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,favoriteDelegate, SortListDelegate,SkeletonTableViewDataSource{
    
    
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var selectedRestaurantId = ""
    var arrOutletList = [OutletData]()
    var strRestaurantName = ""
    var selectedSortTypedIndexFromcolVwFilter = 1
    var SelectFilterId = ""
    var isRefresh = false
    var responseStatus : webserviceResponse = .initial
    // MARK: - IBOutlets
    @IBOutlet weak var lblRestaurantName: themeLabel!
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var btnFilter: collectionVwFilterBtns!
    @IBOutlet weak var tblRestaurantList: UITableView!{
        didSet{
            tblRestaurantList.isSkeletonable = true
        }
    }
    @IBOutlet weak var imgRestaurantEmpty: UIImageView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        tblRestaurantList.showAnimatedSkeleton()
        self.webserviceGetRestaurantOutlet(strFilter: "")
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
        self.customTabBarController?.hideTabBar()
    }
    
    // MARK: - Other Methods
    func registerNIB(){
        tblRestaurantList.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblRestaurantList.register(UINib(nibName:"ShimmerCell", bundle: nil), forCellReuseIdentifier: "ShimmerCell")
    }
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
        self.pageNumber = 1
        self.isRefresh = true
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
        if self.isNeedToReload && self.isRefresh == false{
            self.pageNumber = self.pageNumber + 1
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
            webserviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnFilterClick(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.tblRestaurantList.reloadData()
            }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = 1
                //                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
                //                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
                self.tblRestaurantList.reloadData()
            } else {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                self.tblRestaurantList.reloadData()
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
    // MARK: - filterDelegate
    func SelectedSortList(_ SortId: String) {
        DispatchQueue.main.async {
            self.selectedSortTypedIndexFromcolVwFilter = -1
            self.tblRestaurantList.reloadData()
        }
        if SingletonClass.sharedInstance.topSellingId != "" && SortId == SingletonClass.sharedInstance.topSellingId{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CategoryVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.SelectFilterId = SortId
            self.pageNumber = 1
            webserviceGetRestaurantOutlet(strFilter: "")
        }
    }
    // MAQRK:- Skeletontableview Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.responseStatus == .gotData ? (self.arrOutletList.count > 0 ? RestaurantOutletListCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  ShimmerCell.reuseIdentifier
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
            if arrOutletList.count != 0 {
                return self.arrOutletList.count
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if responseStatus == .gotData{
            if arrOutletList.count != 0{
                let cell = tblRestaurantList.dequeueReusableCell(withIdentifier: RestaurantOutletListCell.reuseIdentifier,for: indexPath) as! RestaurantOutletListCell
                cell.lblAreaName.text = arrOutletList[indexPath.row].street
                cell.lblAddress.text = arrOutletList[indexPath.row].address
                cell.lblMiles.text = arrOutletList[indexPath.row].distance
                cell.lblRating.text = arrOutletList[indexPath.row].ratingCount
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrOutletList[indexPath.row].image ?? "")"
                cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.btnFavorite.tag = indexPath.row
                cell.btnFavorite.addTarget(self, action: #selector(btnTapFavorite(_:)), for: .touchUpInside)
                if arrOutletList[indexPath.row].favourite == "1"{
                    cell.btnFavorite.isSelected = true
                }else{
                    cell.btnFavorite.isSelected = false
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = tblRestaurantList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                
                NoDatacell.imgNoData.image = UIImage(named: "Restaurant")
                NoDatacell.lblNoDataTitle.isHidden = true
                return NoDatacell
            }
        }else{
            let cell = tblRestaurantList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
        controller.selectedRestaurantId = arrOutletList[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrOutletList.count != 0 {
                return 230
            }else{
                return tableView.frame.height
            }
        }else {
            return self.responseStatus == .gotData ?  230 : 131
        }
    }
    // MARK: - Api Calls
    func webserviceGetRestaurantOutlet(strFilter:String){
        let RestaurantOutletList = RestaurantOutletReqModel()
        RestaurantOutletList.user_id = SingletonClass.sharedInstance.UserId
        RestaurantOutletList.filter = strFilter
        RestaurantOutletList.item = ""
        RestaurantOutletList.page = "\(self.pageNumber)"
        RestaurantOutletList.restaurant_id = self.selectedRestaurantId
        RestaurantOutletList.page = "\(self.pageNumber)"
        RestaurantOutletList.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        RestaurantOutletList.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.RestaurantOutlet(OutletModel: RestaurantOutletList, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            self.responseStatus = .gotData
            if status{
                let restaurantData = RestaurantOutletsResModel.init(fromJson: response)
                let cell = self.tblRestaurantList.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier) as! ShimmerCell
                cell.stopShimmering()
                self.tblRestaurantList.stopSkeletonAnimation()
                self.isRefresh = false
                if self.pageNumber == 1 {
                    self.arrOutletList = restaurantData.data
                    let arrTemp = restaurantData.data
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                    self.setData()
                } else {
                    let arrTemp = restaurantData.data
                    //                    if arrTemp!.count > 0 {
                    //                        for i in 0..<arrTemp!.count {
                    //                            self.arrOutletList.append(arrTemp![i])
                    //                        }
                    //                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                }
                self.tblRestaurantList.dataSource = self
                self.tblRestaurantList.isScrollEnabled = true
                self.tblRestaurantList.isUserInteractionEnabled = true
                self.tblRestaurantList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
//            if self.arrOutletList.count > 0{
//                self.tblRestaurantList.restore()
//                self.imgRestaurantEmpty.isHidden = true
//                self.tblRestaurantList.isHidden = false
//                self.vwFilter.isHidden = false
//            }else {
//                self.imgRestaurantEmpty.isHidden = false
//                self.tblRestaurantList.isHidden = true
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
                self.arrOutletList.first(where: { $0.id == strRestaurantId })?.favourite = Status
                self.tblRestaurantList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func refreshFavoriteScreen() {
        self.pageNumber = 1
        self.isRefresh = true
        self.isNeedToReload = true
        webserviceGetRestaurantOutlet(strFilter: "")
    }
}
