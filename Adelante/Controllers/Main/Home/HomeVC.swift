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
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "Mobile Pickup"),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "Recently Viewed"),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "Top Rated")] //["","Mobile Pickup", "Recently Viewed", "Top Rated"]
    var arrImagesForPage = ["dummyRest1", "dummyRest2" , "dummyRest1"]
    var arrImages = ["dummyRest1", "dummyRest2" , "dummyRest1", "dummyRest1", "dummyRest2" , "dummyRest1"]
    var selectedSortTypedIndexFromcolVwFilter = -1

    // MARK: - IBOutlets
    @IBOutlet weak var colVwRestWthPage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var colVwFilterOptions: UICollectionView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        selectedSortTypedIndexFromcolVwFilter = 1
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
    
    // MARK: - IBActions
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
    
}

class FilterOptionsCell : UICollectionViewCell {
    
//    var fliter : (() -> ())?
    
    @IBOutlet weak var btnFilterOptions: collectionVwFilterBtns!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - UICollectionViewCell - RestWithPageCell
class RestWithPageCell : UICollectionViewCell {
    
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var lblRestName: colVwRestaurantLabel!
    @IBOutlet weak var lblRestDesc: colVwRestaurantLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}

// MARK: - UICollectionViewCell - RestaurantCategoryCell
class RestaurantCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCategory: collectionVwFilterBtns!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - UITableViewCell - RestaurantCell
class RestaurantCatListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var selectedIndexForFood = 0
    @IBOutlet weak var colRestaurantCatList: UICollectionView!
    
    var arrCategories = ["Pizza", "Fast Food", "Sandwich","Pizza", "Fast Food", "Sandwich","Pizza", "Fast Food", "Sandwich"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colRestaurantCatList.delegate = self
        self.colRestaurantCatList.dataSource = self
        self.colRestaurantCatList.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colRestaurantCatList.dequeueReusableCell(withReuseIdentifier: RestaurantCategoryCell.reuseIdentifier, for: indexPath) as! RestaurantCategoryCell
        cell.btnCategory.setTitle(arrCategories[indexPath.row], for: .normal)
        
        let image = UIImage(named: "dummyPizza")?.withRenderingMode(.alwaysTemplate)
        cell.btnCategory.setImage(image, for: .normal)
        if indexPath.row == selectedIndexForFood
        {
            cell.btnCategory.setTitleColor(colors.black.value.withAlphaComponent(1.0), for: .normal)
            cell.btnCategory.backgroundColor = colors.segmentSelectedColor.value
            
            cell.btnCategory.imageView?.tintColor = colors.black.value.withAlphaComponent(1.0)
        } else {
            cell.btnCategory.setTitleColor(colors.black.value.withAlphaComponent(0.3), for: .normal)
            cell.btnCategory.backgroundColor = colors.segmentDeselectedColor.value
            cell.btnCategory.imageView?.tintColor = colors.black.value.withAlphaComponent(0.3)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = arrCategories[indexPath.row].size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
        return CGSize(width: s.width + 20 + 35, height: colRestaurantCatList.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexForFood = indexPath.row
        self.colRestaurantCatList.reloadData()
        //print(indexPath.row)
    }
}

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var imgRestaurant: customImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func BtnLikeDislike(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
