//
//  RestaurantCatListCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol RestaurantCatListDelegate {
    func SelectedCategory(_ CategoryId: String,_ SelctedIndex: IndexPath)
}

class RestaurantCatListCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var selectedIdForFood = "0"
    var delegateResCatCell : RestaurantCatListDelegate?
    var arrCategories = [Category]()
    var selectedIndexPath = IndexPath()
    @IBOutlet weak var colRestaurantCatList: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colRestaurantCatList.delegate = self
        self.colRestaurantCatList.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colRestaurantCatList.dequeueReusableCell(withReuseIdentifier: RestaurantCategoryCell.reuseIdentifier, for: indexPath) as! RestaurantCategoryCell
        cell.lblCategory.text = arrCategories[indexPath.row].name
        let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrCategories[indexPath.row].image ?? "")"
        cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgCategory.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        if arrCategories[indexPath.row].id.contains(selectedIdForFood)
        {
            cell.viewCategory.backgroundColor = colors.segmentSelectedColor.value
            cell.lblCategory.textColor = UIColor.black
        } else {
            cell.viewCategory.backgroundColor = colors.segmentDeselectedColor.value
            cell.lblCategory.textColor = UIColor.init(hexString: "#A9ABAE")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = arrCategories[indexPath.row].name.size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
        return CGSize(width: s.width + 20 + 35, height: colRestaurantCatList.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIdForFood == "" {
            self.selectedIdForFood = self.arrCategories[indexPath.row].id
            selectedIndexPath = IndexPath(item:indexPath.row, section: 0)
        }
        else if self.selectedIdForFood == self.arrCategories[indexPath.row].id{
            self.selectedIdForFood = "0"
            selectedIndexPath = IndexPath(item:0 , section: 0)
        } else {
            self.selectedIdForFood = self.arrCategories[indexPath.row].id
            selectedIndexPath = IndexPath(item:indexPath.row , section: 0)
        }
        self.delegateResCatCell?.SelectedCategory(selectedIdForFood, selectedIndexPath)
    }
}
