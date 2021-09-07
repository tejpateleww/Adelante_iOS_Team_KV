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
import GooglePlaces
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
    
    
//        func SelectedCategory(_ CategoryId: String) -> (Bool, String) {
//
//            self.SelectedCatId = CategoryId
//            return webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
//        }
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
    var SelectedCatId = "0"
    var SelectedCatIndex = IndexPath()
    var SelectFilterId = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = false
    var pageLimit = 5
    var selectedRestaurantId = ""
    var isRefresh = false
    var headerCell : RestaurantCatListCell?
    let activityView = UIActivityIndicatorView(style: .white)
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
        self.SelectedCategory(SelectedCatId, SelectedCatIndex)
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshListing), for: .valueChanged)
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        setup()
        pageControl.numberOfPages = arrBanner.count
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        print("homeVc \(#function)")
//        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        print("homeVc \(#function)")
    }
    override func viewDidLayoutSubviews() {
        
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
        //        tblMainList.reloadData()
        
        
        colVwFilterOptions.delegate = self
        colVwFilterOptions.dataSource = self
        colVwFilterOptions.reloadData()
        
        pageControl.hidesForSinglePage = true
    }
    @objc func refreshListing(){
        responseStatus = .initial
        arrRestaurant.removeAll()
        tblMainList.reloadData()
        colVwRestWthPage.reloadData()
        colVwFilterOptions.reloadData()
        self.pageNumber = 1
        isRefresh = true
        self.isNeedToReload = true
        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
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
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            let notifVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: NotificationVC.storyboardID)
            self.navigationController?.pushViewController(notifVc, animated: true)
        }
    }
    
    @IBAction func btnNavAddressHomeClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue) |
                                                    GMSPlaceField.addressComponents.rawValue |
                                                    GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
                self.tblMainList.reloadData()
            }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = 1
                self.colVwFilterOptions.reloadData()
                self.tblMainList.reloadData()
            } else {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                self.colVwFilterOptions.reloadData()
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
}
extension HomeVC :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource,SkeletonTableViewDataSource,SkeletonCollectionViewDataSource{
    // MARK: - skeletonCollectionview Datasource
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            return 0
        }
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return responseStatus == .gotData ? (self.arrBanner.count > 0 ? RestWithPageCell.reuseIdentifier : NoDataCollectionview.reuseIdentifier) :  ShimmarCollectionCell.reuseIdentifier
    }
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVwFilterOptions{
            return arrFilter.count
        } else if collectionView == self.colVwRestWthPage {
            if responseStatus == .gotData{
                if arrBanner.count != 0 {
                    return self.arrBanner.count
                }else{
                    return 1
                }
            }else{
                return 5
            }
        }
        return arrRestaurant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == self.colVwFilterOptions{
            let cell = colVwFilterOptions.dequeueReusableCell(withReuseIdentifier: FilterOptionsCell.reuseIdentifier, for: indexPath) as! FilterOptionsCell
            cell.btnFilterOptions.setTitle(arrFilter[indexPath.row].strTitle, for: .normal)
            
            if selectedSortTypedIndexFromcolVwFilter != -1 && selectedSortTypedIndexFromcolVwFilter == indexPath.row {
                cell.btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
                cell.btnFilterOptions.setImage(arrFilter[indexPath.row].strselectedImage, for: .normal)
                cell.btnFilterOptions.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
//                webserviceGetDashboard(isFromFilter: false, strTabfilter: String(selectedSortTypedIndexFromcolVwFilter - 1))
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
        }else {
            if responseStatus == .gotData{
                if arrBanner.count != 0 {
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
                    NoDatacell.lblNoDataTitle.text = "No Data Found"
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
            //restaurantListVc.strItemId = arrBanner[indexPath.row].id
            self.navigationController?.pushViewController(restaurantListVc, animated: true)
        }
    }
    //MARK : - Skeletontableview Datasource
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            return 0
        }
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return responseStatus == .gotData ? (self.arrRestaurant.count > 0 ? RestaurantCell.reuseIdentifier : NoDataTableViewCell.reuseIdentifier) :  HomeSkeletonCell.reuseIdentifier
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if responseStatus == .gotData{
            if arrRestaurant.count != 0 {
                return arrRestaurant.count
            }else{
                return 1
            }
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if responseStatus == .gotData{
            if arrRestaurant.count != 0 {
                let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
                cell.lblItemName.text = arrRestaurant[indexPath.row].name
                cell.lblMiles.text = arrRestaurant[indexPath.row].distance//arrRestaurant[indexPath.row - 1].distance
                cell.lblRating.text = arrRestaurant[indexPath.row].rating_count
                cell.btnFavorite.isHidden = false
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrRestaurant[indexPath.row].image ?? "")"
                cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                cell.btnFavouriteClick = {
                    if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
                        let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
                        let navController = UINavigationController.init(rootViewController: vc)
                        navController.modalPresentationStyle = .overFullScreen
                        navController.navigationController?.modalTransitionStyle = .crossDissolve
                        navController.navigationBar.isHidden = true
                        SingletonClass.sharedInstance.isPresented = true
                        self.present(navController, animated: true, completion: nil)
                    }else{
                        var Select = self.arrRestaurant[indexPath.row].favourite ?? ""
                        let restaurantId = self.arrRestaurant[indexPath.row].id ?? ""
                        if Select == "1"{
                            Select = "0"
                        }else{
                            Select = "1"
                        }
                        self.webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
                        cell.btnFavorite.isHidden = true
                        self.activityView.center = CGPoint(x: cell.vwIndicator.frame.width / 2, y: cell.vwIndicator.frame.height/2)
                        self.activityView.color = .red
                        cell.vwIndicator.addSubview(self.activityView)
                        self.activityView.startAnimating()
                    }
                }
                if arrRestaurant[indexPath.row].favourite == "1"{
                    cell.btnFavorite.isSelected = true
                }else{
                    cell.btnFavorite.isSelected = false
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = tblMainList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "Restaurant")
                NoDatacell.lblNoDataTitle.isHidden = true
                NoDatacell.selectionStyle = .none
                return NoDatacell
            }
        }else{
            let cell = tblMainList.dequeueReusableCell(withIdentifier: HomeSkeletonCell.reuseIdentifier, for: indexPath) as! HomeSkeletonCell
            print("Shimmer RestaurantCell loaded")
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if responseStatus == .gotData{
            if arrRestaurant.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height / 2 + 60
            }
        }else {
            return responseStatus == .gotData ?  230 : 131
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerCell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCatListCell.reuseIdentifier) as? RestaurantCatListCell
        headerCell?.arrCategories = self.arrCategories
        headerCell?.delegateResCatCell = self
        headerCell?.selectedIdForFood = self.SelectedCatId
        headerCell?.selectedIndexPath = self.SelectedCatIndex
        headerCell?.colRestaurantCatList.reloadData()
        headerCell?.selectionStyle = .none
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrRestaurant[indexPath.row].type != "outlet" {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantOutletVC.storyboardID) as! RestaurantOutletVC
            controller.selectedRestaurantId = arrRestaurant[indexPath.row].id
            controller.strRestaurantName = arrRestaurant[indexPath.row].name
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
            restDetailsVc.selectedRestaurantId = arrRestaurant[indexPath.row].id
            restDetailsVc.isFromRestaurantList = true
            restDetailsVc.selectedIndex = "\(indexPath.row)"
            self.navigationController?.pushViewController(restDetailsVc, animated: true)
        }
    }
    // MARK: - RestaurantCatListCelldelegate
    func SelectedCategory(_ CategoryId: String, _ SelctedIndex: IndexPath) {
        self.SelectedCatId = CategoryId
        self.SelectedCatIndex = SelctedIndex
        print("selectedcategoryid",SelectedCatId)
        self.pageNumber = 1
        self.webserviceGetDashboard(isFromFilter:false, strTabfilter: "")
    }
    // MARK: - filterDelegate
    func SelectedSortList(_ SortId: String) {
        DispatchQueue.main.async {
            self.selectedSortTypedIndexFromcolVwFilter = -1
            self.colVwFilterOptions.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        self.SelectFilterId = SortId
        self.pageNumber = 1
        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if isNeedToReload && isRefresh == false {
            self.pageNumber = self.pageNumber + 1
            webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
        }
    }
    // MARK: - Api Calls
    @objc func webserviceGetDashboard(isFromFilter : Bool,strTabfilter:String){
        let Deshboard = DashboardReqModel()
        Deshboard.category_id = SelectedCatId
        Deshboard.user_id = SingletonClass.sharedInstance.UserId
        Deshboard.filter = SelectFilterId
        Deshboard.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        Deshboard.lng =  "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        Deshboard.page = "\(self.pageNumber)"
        Deshboard.tab_filter = strTabfilter
        WebServiceSubClass.deshboard(DashboardModel: Deshboard, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            responseStatus = .gotData
            if status{
                let Homedata = DashBoardResModel.init(fromJson: response)
                let cell = self.tblMainList.dequeueReusableCell(withIdentifier: HomeSkeletonCell.reuseIdentifier) as! HomeSkeletonCell
                cell.stopShimmering()
                self.tblMainList.stopSkeletonAnimation()
                let indexPath = IndexPath.init(row: 0, section: 0)
                let Bannercell = self.colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: ShimmarCollectionCell.reuseIdentifier, for: indexPath) as! ShimmarCollectionCell
                Bannercell.stopShimmering()
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
                
                if isFromFilter{
                    let indexes = (0..<self.arrRestaurant.count).map { IndexPath(row: $0, section: 0) }
                    self.tblMainList.reloadRows(at: indexes, with: .fade)
                    DispatchQueue.main.async {
                        self.headerCell?.colRestaurantCatList.scrollToItem(at: self.SelectedCatIndex, at: .centeredHorizontally, animated: false)
                    }
                }else{
                    self.tblMainList.reloadData()
                }
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
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
                NotificationCenter.default.post(name: notifRefreshFavouriteList, object: nil)
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
    func refreshDeshboardList(strStatus: String, selectedIndex: String) {
        self.pageNumber = 1
        self.isRefresh = true
        self.isNeedToReload = true
        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
    }
    
    func refreshFavoriteScreen() {
        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
    }
}

extension HomeVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place ID: \(place.placeID!)")
        lblAddress.text =  place.name
        SingletonClass.sharedInstance.userCurrentLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        webserviceGetDashboard(isFromFilter: false, strTabfilter: "")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

