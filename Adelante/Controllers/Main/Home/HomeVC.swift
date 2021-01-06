//
//  HomeVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

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

class HomeVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFilter = [structFilter(strselectedImage: UIImage.init(named: "filterImageSelected")! , strDeselectedImage: UIImage.init(named: "filterImage")!, strTitle: ""),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title1".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title2".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title3".Localized())] //["","Mobile Pickup", "Recently Viewed", "Top Rated"]
    var arrImagesForPage = ["dummyRest1", "dummyRest2" , "dummyRest1"]
    var arrImages = ["dummyRest1", "dummyRest2" , "dummyRest1", "dummyRest1", "dummyRest2" , "dummyRest1"]
    var selectedSortTypedIndexFromcolVwFilter = -1

    // MARK: - IBOutlets
    @IBOutlet weak var lblMylocation: myLocationLabel!
    @IBOutlet weak var lblAddress: myLocationLabel!
    @IBOutlet weak var colVwRestWthPage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var colVwFilterOptions: UICollectionView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setup()
    
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: false, isRight: false)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        lblNavAddressHome.text = "30 Memorial Drive, Avon MA 2322"
        btnNavAddressHome.addTarget(self, action: #selector(btnNavAddressHomeClicked(_:)), for: .touchUpInside)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deselectFilterOptionHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: NSNotification.Name(rawValue: "deselectFilterOptionHome"), object: nil)
        
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
    
    @objc func deSelectFilterAndRefresh() {
        selectedSortTypedIndexFromcolVwFilter = -1
        colVwFilterOptions.reloadData()
    }
    func setUpLocalizedStrings(){
        lblMylocation.text = "HomeVC_lblMylocation".Localized()
        lblAddress.text = "30 Memorial Drive, Avon MA 2322"
    }
    // MARK: - IBActions
    
    @IBAction func btnNotifClicked(_ sender: Any) {
        let notifVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: NotificationVC.storyboardID)
        self.navigationController?.pushViewController(notifVc, animated: true)
    }
    
    @IBAction func btnNavAddressHomeClicked(_ sender: Any) {
        
    }

    @IBAction func btnFilterClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
        }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = -1
            let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
        } else {
            self.selectedSortTypedIndexFromcolVwFilter = sender.tag
            self.colVwFilterOptions.reloadData()
        }
            if self.selectedSortTypedIndexFromcolVwFilter == 0 {
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID)
                let navController = UINavigationController.init(rootViewController: vc)
                navController.modalPresentationStyle = .overFullScreen
                navController.navigationController?.modalTransitionStyle = .crossDissolve
                navController.navigationBar.isHidden = true
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVwFilterOptions{
            return arrFilter.count
        } else if collectionView == self.colVwRestWthPage {
            return arrImagesForPage.count
        }
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         if collectionView == self.colVwFilterOptions{
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
        }else {
            let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: RestWithPageCell.reuseIdentifier, for: indexPath) as! RestWithPageCell
            cell.imgRestaurant.image = UIImage(named: arrImagesForPage[indexPath.row])
            cell.lblRestName.text = "Lorem Ipsum"
            cell.lblRestDesc.text = "Lorem Ipsum is simply dummy text"
            return cell
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
            let restListVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantListVC.storyboardID)
            self.navigationController?.pushViewController(restListVc, animated: true)
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCatListCell.reuseIdentifier, for: indexPath) as! RestaurantCatListCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
   
    // MARK: - Api Calls
//    func webserviceGetDashboard(){
//        WebServiceSubClass.deshboard(showHud: false, completion: <#T##CompletionResponse##CompletionResponse##(JSON, Bool, Any) -> ()#>)
//    }
}
