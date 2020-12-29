//
//  CategoryVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class CategoryVC: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setup()
    }
    
    // MARK: - Other Methods
    func setup() {
      //  self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.topCategories.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.tfSearch.frame.height))
        tfSearch.leftView = padding
        tfSearch.leftViewMode = UITextField.ViewMode.always
    }
    func setUpLocalizedStrings(){
        tfSearch.placeholder = "CategoryVC_tfSearch".Localized()
    }
    // MARK: - IBActions
    
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CategoryCell = collectionCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)as! CategoryCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let widthForCell = (collectionCategory.frame.size.width - 12) / 2
        let heightForCell = (widthForCell * 120) / 164
        return CGSize(width: widthForCell, height: heightForCell)
    }
    
    // MARK: - Api Calls
}

