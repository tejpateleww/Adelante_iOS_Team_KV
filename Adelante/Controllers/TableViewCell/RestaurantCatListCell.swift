//
//  RestaurantCatListCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantCatListCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

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
