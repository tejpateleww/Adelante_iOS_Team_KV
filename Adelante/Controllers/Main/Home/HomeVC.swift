 //
//  HomeVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import SkeletonView
 
struct structFilter {
    
    var strselectedImage : UIImage
    var strDeselectedImage:UIImage
    var strTitle : String
    init(strselectedImage:UIImage, strDeselectedImage:UIImage ,strTitle :String) {
        self.strselectedImage = strselectedImage
        self.strDeselectedImage = strDeselectedImage
        self.strTitle = strTitle
    }
}

class HomeVC: BaseViewController,UINavigationControllerDelegate, UIGestureRecognizerDelegate , RestaurantCatListDelegate ,SortListDelegate,favoriteDelegate{
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFilter = [structFilter(strselectedImage: UIImage.init(named: "filterImageSelected")! , strDeselectedImage: UIImage.init(named: "filterImage")!, strTitle: ""),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title1".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title2".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title3".Localized())] //["","Mobile Pickup", "Recently Viewed", "Top Rated"]
    var selectedSortTypedIndexFromcolVwFilter = 1
    var refresher = UIRefreshControl()
    var arrCategories = [Category]()
    var arrRestaurant  = [Restaurant]()
    var arrBanner = [Banner]()
    var SelectedCatId = ""
    var SelectFilterId = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = false
    var pageLimit = 5
    var selectedRestaurantId = ""
    var isRefresh = false
    // MARK: - IBOutlets
    @IBOutlet weak var lblMylocation: myLocationLabel!
    @IBOutlet weak var lblAddress: myLocationLabel!
    @IBOutlet weak var colVwRestWthPage: UICollectionView!{
        didSet{
            colVwRestWthPage.isSkeletonable = true
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblMainList: UITableView!{
        didSet{
            tblMainList.isSkeletonable = true
        }
    }
    @IBOutlet weak var colVwFilterOptions: UICollectionView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        setUpLocalizedStrings()
        self.colVwRestWthPage.showAnimatedSkeleton()
        self.tblMainList.showAnimatedSkeleton()
        webserviceGetDashboard()
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshListing), for: .valueChanged)
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        setup()
        pageControl.numberOfPages = arrBanner.count
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tblMainList.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Other Methods
    func registerNIB(){
        tblMainList.register(UINib(nibName:"NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tblMainList.register(UINib(nibName:"HomeSkeletonCell", bundle: nil), forCellReuseIdentifier: "HomeSkeletonCell")
        colVwRestWthPage.register(UINib(nibName:"NoDataCollectionview", bundle: nil), forCellWithReuseIdentifier: "NoDataCollectionview")
        colVwRestWthPage.register(UINib(nibName:"ShimmarCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ShimmarCollectionCell")
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: false, isRight: false)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        lblNavAddressHome.text = "30 Memorial Drive, Avon MA 2322"
        btnNavAddressHome.addTarget(self, action: #selector(btnNavAddressHomeClicked(_:)), for: .touchUpInside)
        
        NotificationCenter.default.removeObserver(self, name: notifDeSelectFilterHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: notifDeSelectFilterHome, object: nil)
        NotificationCenter.default.removeObserver(self, name: notifRefreshDashboardList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListing), name: notifRefreshDashboardList, object: nil)
        
        colVwRestWthPage.delegate = self
        colVwRestWthPage.dataSource = self
        colVwRestWthPage.reloadData()
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
        colVwFilterOptions.delegate = self
        colVwFilterOptions.dataSource = self
        colVwFilterOptions.reloadData()
        pageControl.hidesForSinglePage = true
    }
    @objc func refreshListing(){
        self.pageNumber = 1
        isRefresh = true
        self.isNeedToReload = true
        webserviceGetDashboard()
    }
    @objc func deSelectFilterAndRefresh() {
        selectedSortTypedIndexFromcolVwFilter = -1
        colVwFilterOptions.reloadData()
    }
    func setUpLocalizedStrings(){
        lblMylocation.text = "HomeVC_lblMylocation".Localized()
        lblAddress.text = "30 Memorial Drive, Avon MA 2322"
    }
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            var Select = arrRestaurant[sender.tag].favourite ?? ""
            let restaurantId = arrRestaurant[sender.tag].id ?? ""
            if Select == "1"{
                Select = "0"
            }else{
                Select = "1"
            }
            webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnNotifClicked(_ sender: Any) {
        let notifVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: NotificationVC.storyboardID)
        self.navigationController?.pushViewController(notifVc, animated: true)
    }
    
    @IBAction func btnNavAddressHomeClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
//        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "EditLocationVC")
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
            }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = 1
//                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
//                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
                self.colVwFilterOptions.reloadData()
            } else {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                self.colVwFilterOptions.reloadData()
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
}
 extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource,SkeletonTableViewDataSource,SkeletonCollectionViewDataSource{
    // MARK: - SkeletonCollectionview Datasource
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            return 0
        }
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        if responseStatus == .gotData{
//            return responseStatus == .gotData ? (self.arrFilter.count > 0 ? FilterOptionsCell.reuseIdentifier : NoDataCollectionview.reuseIdentifier) :  ShimmarCollectionCell.reuseIdentifier
//        }else{
            return responseStatus == .gotData ? (self.arrBanner.count > 0 ? RestWithPageCell.reuseIdentifier : NoDataCollectionview.reuseIdentifier) :  ShimmarCollectionCell.reuseIdentifier
//        }
    }
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVwFilterOptions{
            return arrFilter.count
        } else if collectionView == self.colVwRestWthPage {
            return arrBanner.count > 0 ? arrBanner.count : 5
        }
        return arrRestaurant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colVwFilterOptions{
//            if responseStatus == .gotData{
//                if arrFilter.count != 0 {
                    let cell = colVwFilterOptions.dequeueReusableCell(withReuseIdentifier: FilterOptionsCell.reuseIdentifier, for: indexPath) as! FilterOptionsCell
                    cell.btnFilterOptions.setTitle(arrFilter[indexPath.row].strTitle, for: .normal)
                    
                    if selectedSortTypedIndexFromcolVwFilter != -1 && selectedSortTypedIndexFromcolVwFilter == indexPath.row {
                        cell.btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
                        cell.btnFilterOptions.setImage(arrFilter[indexPath.row].strselectedImage, for: .normal)
                        cell.btnFilterOptions.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
                    }
                    else {
                        cell.btnFilterOptions.backgroundColor = colors.segmentDeselectedColor.value
                        cell.btnFilterOptions.setImage(arrFilter[indexPath.row].strDeselectedImage, for: .normal)
                        cell.btnFilterOptions.setTitleColor(colors.black.value.withAlphaComponent(0.3), for: .normal)
                    }
                    cell.btnFilterOptions.isUserInteractionEnabled = true
                    cell.btnFilterOptions.tag = indexPath.row
                    cell.btnFilterOptions.addTarget(self, action: #selector(btnFilterClicked(_:)), for: .touchUpInside)
                    return cell
//
//                }else{
//                    let NoDatacell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionview", for: indexPath) as! NoDataCollectionview
//                    NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
//                    NoDatacell.lblNoDataTitle.text = "No_data_favorite".Localized()
//                    return NoDatacell
//                }
//            }else{
//                let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: ShimmarCollectionCell.reuseIdentifier, for: indexPath) as! ShimmarCollectionCell
//                return cell
//            }
        }else {
            if responseStatus == .gotData{
                if arrFilter.count != 0 {
                    let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: RestWithPageCell.reuseIdentifier, for: indexPath) as! RestWithPageCell
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrBanner[indexPath.row].image ?? "")"
                    cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    if cell.lblRestName.text == ""{
                        cell.vwRestName.isHidden = true
                    }else{
                        cell.vwRestName.isHidden = false
                    }
                    if cell.lblRestDesc.text == ""{
                        cell.vwRestDesc.isHidden = true
                    }else{
                        cell.vwRestDesc.isHidden = false
                    }
                    cell.lblRestName.text = arrBanner[indexPath.row].name
                    cell.lblRestDesc.text = arrBanner[indexPath.row].descriptionField
                    return cell
                }else{
                    let NoDatacell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionview", for: indexPath) as! NoDataCollectionview
                    NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
                    NoDatacell.lblNoDataTitle.text = "No_data_favorite".Localized()
                    return NoDatacell
                }
            }else{
                    let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: ShimmarCollectionCell.reuseIdentifier, for: indexPath) as! ShimmarCollectionCell
                    return cell
                }
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.colVwFilterOptions{
            if indexPath.row == 0 {
                return CGSize(width: colVwFilterOptions.frame.size.height, height: colVwFilterOptions.frame.size.height)
            }
            let s = arrFilter[indexPath.row].strTitle.size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
            return CGSize(width: s.width + 20, height: colVwFilterOptions.frame.size.height)
        } else {
            return CGSize(width: colVwRestWthPage.frame.size.width, height: colVwRestWthPage.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.colVwRestWthPage {
            self.pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.colVwFilterOptions{
            let restaurantListVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantListVC.storyboardID) as! RestaurantListVC
            self.navigationController?.pushViewController(restaurantListVc, animated: true)
        }
    }
    // MARK: - Skeleton Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            return 0
        }
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if indexPath.row == 0{
            return responseStatus == .gotData ? (self.arrCategories.count > 0 ? RestaurantCatListCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  HomeSkeletonCell.reuseIdentifier
        }
        return responseStatus == .gotData ? (self.arrRestaurant.count > 0 ? RestaurantCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  HomeSkeletonCell.reuseIdentifier
    }
    // MARK: - UITableViewDelegates And Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return arrRestaurant.count + 3 //> 0 ? arrRestaurant.count + 1 : 1
        if responseStatus == .gotData{
            return arrRestaurant.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
//            if responseStatus == .gotData{
//                if arrRestaurant.count != 0 {
                    let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCatListCell.reuseIdentifier, for: indexPath) as! RestaurantCatListCell
                    cell.arrCategories = self.arrCategories
                    cell.delegateResCatCell = self
                    cell.colRestaurantCatList.reloadData()
                    cell.selectionStyle = .none
                    return cell
                    
//                }else{
//                    let NoDatacell = tblMainList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
//
//                    NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
//                    NoDatacell.lblNoDataTitle.text = "No_data_favorite".Localized()
//
//                    return NoDatacell
//                }
//            }else{
//                let cell = tblMainList.dequeueReusableCell(withIdentifier: HomeSkeletonCell.reuseIdentifier, for: indexPath) as! HomeSkeletonCell
//                print("Shimmer category cell loaded")
//                return cell
//            }
//        }
        }
                else {
            if responseStatus == .gotData{
                if arrRestaurant.count != 0 {
                    let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
                    cell.lblItemName.text = arrRestaurant[indexPath.row - 1].name
                    cell.lblMiles.text = arrRestaurant[indexPath.row - 1].distance//arrRestaurant[indexPath.row - 1].distance
                    cell.lblRating.text = arrRestaurant[indexPath.row - 1].review
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrRestaurant[indexPath.row - 1].image ?? "")"
                    cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.btnFavorite.tag = indexPath.row - 1
                    cell.btnFavorite.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
                    if arrRestaurant[indexPath.row - 1].favourite == "1"{
                        cell.btnFavorite.isSelected = true
                    }else{
                        cell.btnFavorite.isSelected = false
                    }
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let NoDatacell = tblMainList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    
                    NoDatacell.imgNoData.image = UIImage(named: NoData.Favorite.ImageName)
                    NoDatacell.lblNoDataTitle.text = "No_data_favorite".Localized()
                    
                    return NoDatacell
                }
            }else{
                let cell = tblMainList.dequeueReusableCell(withIdentifier: HomeSkeletonCell.reuseIdentifier, for: indexPath) as! HomeSkeletonCell
                print("Shimmer RestaurantCell  loaded")
                cell.selectionStyle = .none
                return cell
            }
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 40 : 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantOutletVC.storyboardID) as! RestaurantOutletVC
            controller.selectedRestaurantId = arrRestaurant[indexPath.row - 1].id
            controller.strRestaurantName = arrRestaurant[indexPath.row - 1].name
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - RestaurantCatListCelldelegate
    func SelectedCategory(_ CategoryId: String) {
        self.SelectedCatId = CategoryId
        print("selectedcategoryid",SelectedCatId)
        self.pageNumber = 1
        self.webserviceGetDashboard()
    }
    // MARK: - filterDelegate
    func SelectedSortList(_ SortId: String) {
        
        DispatchQueue.main.async {
            self.selectedSortTypedIndexFromcolVwFilter = -1
            self.colVwFilterOptions.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        if SingletonClass.sharedInstance.topSellingId != "" && SortId == SingletonClass.sharedInstance.topSellingId{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CategoryVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.SelectFilterId = SortId
            self.pageNumber = 1
            webserviceGetDashboard()
        }
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if isNeedToReload && isRefresh == false {
            self.pageNumber = self.pageNumber + 1
            webserviceGetDashboard()
        }
        // done, do whatever
    }
    // MARK: - Api Calls
    @objc func webserviceGetDashboard(){
        let Deshboard = DashboardReqModel()
        Deshboard.category_id = SelectedCatId
        Deshboard.user_id = SingletonClass.sharedInstance.UserId
        Deshboard.filter = SelectFilterId
        Deshboard.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        Deshboard.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        Deshboard.page = "\(self.pageNumber)"
        WebServiceSubClass.deshboard(DashboardModel: Deshboard, showHud: false, completion: { (response, status, error)in
            responseStatus = .gotData
            if status{
                let Homedata = DashBoardResModel.init(fromJson: response)
                let cell = self.tblMainList.dequeueReusableCell(withIdentifier: HomeSkeletonCell.reuseIdentifier) as! HomeSkeletonCell
                cell.stopShimmering()
                self.tblMainList.stopSkeletonAnimation()
                let indexPath = IndexPath.init(row: 0, section: 0)
                let Bannercell = self.colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: ShimmarCollectionCell.reuseIdentifier, for: indexPath) as! ShimmarCollectionCell
                Bannercell.stopShimmering()
                self.colVwRestWthPage.stopSkeletonAnimation()
                self.arrCategories = Homedata.category
                self.arrBanner = Homedata.banner
                self.pageControl.numberOfPages = self.arrBanner.count
                self.isRefresh = false
                if self.pageNumber == 1 {
                    self.arrRestaurant = Homedata.restaurant
                    
                    let arrTemp = Homedata.restaurant
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    } else {
                        self.isNeedToReload = true
                    }
                } else {
                    let arrTemp = Homedata.restaurant
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrRestaurant.append(arrTemp![i])
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
                self.colVwRestWthPage.dataSource = self
                self.colVwRestWthPage.isScrollEnabled = true
                self.colVwRestWthPage.isUserInteractionEnabled = true
                self.colVwRestWthPage.reloadData()
            }else{
                Utilities.displayErrorAlert(response["message"].string ?? "No internet connection")
                //                Utilities.showAlertOfAPIResponse(param: error ?? "No internet connection", vc: self)
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    
    func webwerviceFavorite(strRestaurantId:String,Status:String) {
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
            //            self.hideHUD()
            if status{
//                self.webserviceGetDashboard()
                self.arrRestaurant.first(where: { $0.id == strRestaurantId })?.favourite = Status
                self.tblMainList.reloadData()
                NotificationCenter.default.post(name: notifRefreshRestaurantList, object: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func refreshDeshboardList(strStatus: String, selectedIndex: String) {
        self.pageNumber = 1
        self.isRefresh = true
        self.isNeedToReload = true
        webserviceGetDashboard()
//        if selectedIndex != ""{
//            let i = Int(selectedIndex) ?? 0
//            arrRestaurant[i].favourite = strStatus
//            tblMainList.reloadRows(at: [IndexPath(row: i + 1, section: 0)], with: .automatic)
//        }
    }
    
    func refreshFavoriteScreen() {
        webserviceGetDashboard()
    }
}
