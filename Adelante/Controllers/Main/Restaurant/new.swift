////
////  new.swift
////  Adelante
////
////  Created by Nirav S on 03/03/22.
////  Copyright © 2022 EWW071. All rights reserved.
////
//
//import Foundation
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    if tableView == tblRestaurantDetails{
//        if arrMenuitem.count > 0 {
//            if indexPath.section == 0 {
//                let cell:RestaurantDetailsCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailsCell", for: indexPath) as! RestaurantDetailsCell
//
//                let variantValue = arrMenuitem[indexPath.row].variant.ToDouble()
//                cell.lblItemName.text = arrMenuitem[indexPath.row].name
//                cell.lblItemPrice.text = "\(CurrencySymbol)" + arrMenuitem[indexPath.row].price.ConvertToTwoDecimal()
//                cell.lblAboutItem.text = arrMenuitem[indexPath.row].descriptionField
//                cell.ExpandedLabel = { index in
//                    cell.lblAboutItem.numberOfLines =  cell.lblAboutItem.numberOfLines == 0 ? 2 : 0
//                    cell.lblAboutItem.collapsed = cell.lblAboutItem.numberOfLines != 0
//
////                        self.tblRestaurantDetails.reloadData()
//                    self.tblRestaurantDetails.reloadRows(at: [indexPath], with: .none)
//                }
//
//                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrMenuitem[indexPath.row].image ?? "")"
//                cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
//                cell.lblNoOfItem.text = arrMenuitem[indexPath.row].cartQty
//                cell.btnAddItem.isHidden = false
//                cell.vwStapper.isHidden = true
//                cell.stackHide.isHidden = false
//                self.activityView.stopAnimating()
//                if indexPath.row == 0{
//                    if objRestaurant.menuType == 1{
//                        cell.vwRadius.cornerRadius = 5
//                        cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
//                        cell.vwRadius.layer.borderWidth = 1
//                    }else{
//                        cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
//                    }
//                }
//                if Int(arrMenuitem[indexPath.row].cartQty) ?? 0 > 0 {
//                    cell.btnAddItem.isHidden = true
//                    cell.vwStapper.isHidden = false
//                }
//                cell.decreaseData = {
//                    if variantValue > 0 && self.arrMenuitem[indexPath.row].totalvariant.toInt() > 1{
//                        if variantValue > 0{
//                            self.arrItemList = [ItemList]()
//                            self.tblPopup.showAnimatedSkeleton()
//                            self.tblPopup.reloadData()
//                            self.ViewForBottom.constant = 0
//                            self.viewPopup.layoutIfNeeded()
//                            self.viewPopup.layoutSubviews()
//                            self.viewBG.isHidden = false
//                            self.viewPopup.isHidden = false
//                            UIView.animate(withDuration: 0.6, animations: {
//                            }){ (success) in
//                                self.isfromMenu = true
//                                self.webserviceItemList(strItemId: self.arrMenuitem[indexPath.row].id)
//                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                            }
//                        }else{
//                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                            self.isfromMenu = true
//                            self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                            cell.stackHide.isHidden = true
//                            self.activityView.center = cell.vwStapper.center
//                            cell.vwStapper.addSubview(self.activityView)
//                            self.activityView.startAnimating()
//                        }
//                    }else{
//                        self.isfromMenu = true
//                        self.viewPopup.isHidden = true
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                        cell.stackHide.isHidden = true
//                        self.activityView.center = cell.vwStapper.center
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                    }
//                }
//                cell.IncreseData = {
//
//                    if variantValue > 0{
//                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                        controller.selectedRestaurantId = self.objRestaurant.id
//                        controller.isFromRestaurant = true
//                        controller.delegateAddVariant = self
//                        controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                        self.strItemId = self.arrMenuitem[indexPath.row].id
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }else{
//                        let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                        if self.arrMenuitem[indexPath.row].quantity > value {
//                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                            self.isfromMenu = true
//                            self.webserviceUpdateCartQuantity(strItemid: self.arrMenuitem[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
//                            cell.stackHide.isHidden = true
//                            self.activityView.center = cell.vwStapper.center
//                            cell.vwStapper.addSubview(self.activityView)
//                            self.activityView.startAnimating()
//                        }else{
//                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
//                        }
//                    }
//                }
//                if variantValue > 0{
//                    cell.btnCustomize.isHidden = false
//                }else{
//                    cell.btnCustomize.isHidden = true
//                }
//                cell.btnAddAction = {
//                    if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
//                        let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
//                        let navController = UINavigationController.init(rootViewController: vc)
//                        navController.modalPresentationStyle = .overFullScreen
//                        navController.navigationController?.modalTransitionStyle = .crossDissolve
//                        navController.navigationBar.isHidden = true
//                        SingletonClass.sharedInstance.isPresented = true
//                        self.present(navController, animated: true, completion: nil)
//                    }else{
//                        if self.objRestaurant.isdiff == 0{
//                            let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                                if self.arrMenuitem[indexPath.row].quantity > 1 && variantValue > 0{
//                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                                    controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                                    controller.selectedRestaurantId = self.objRestaurant.id
//                                    controller.isFromRestaurant = true
//                                    controller.delegateAddVariant = self
//                                    self.strItemId = self.arrMenuitem[indexPath.row].id
//                                    controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }else{
//                                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                                    if self.arrMenuitem[indexPath.row].quantity > value {
//                                        cell.btnAddItem.isHidden = true
//                                        cell.vwStapper.isHidden = false
//                                        self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                        cell.stackHide.isHidden = true
//                                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                        cell.vwStapper.addSubview(self.activityView)
//                                        self.activityView.startAnimating()
//                                    }else{
//                                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
//                                    }
//                                }
//                            }
//                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                            alert.addAction(yesAction)
//                            alert.addAction(NoAction)
//                            self.present(alert, animated: true, completion: nil)
//                        }else{
//                            if self.arrMenuitem[indexPath.row].quantity > 1 && variantValue > 0{
//                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                                controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                                controller.isFromRestaurant = true
//                                controller.selectedRestaurantId = self.objRestaurant.id
//                                controller.delegateAddVariant = self
//                                controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                                self.strItemId = self.arrMenuitem[indexPath.row].id
//                                self.navigationController?.pushViewController(controller, animated: true)
//                            }else{
//                                let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                                if self.arrMenuitem[indexPath.row].quantity > value {
//                                    cell.btnAddItem.isHidden = true
//                                    cell.vwStapper.isHidden = false
//                                    self.webwerviceAddtoCart(strItemId: self.arrMenuitem[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                    cell.stackHide.isHidden = true
//                                    self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                    cell.vwStapper.addSubview(self.activityView)
//                                    self.activityView.startAnimating()
//                                }else{
//                                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrMenuitem[indexPath.row].name ?? "")",self.arrMenuitem[indexPath.row].quantity]), vc: self)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                cell.customize = {
//                    if self.objRestaurant.isdiff == 0{
//                        let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                        let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                            controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                            controller.selectedRestaurantId = self.objRestaurant.id
//                            controller.delegateAddVariant = self
//                            controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                            self.strItemId = self.arrMenuitem[indexPath.row].id
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
//                        let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                        alert.addAction(yesAction)
//                        alert.addAction(NoAction)
//                        self.present(alert, animated: true, completion: nil)
//                    }else{
//                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                        controller.selectedRestaurantId = self.objRestaurant.id
//                        controller.delegateAddVariant = self
//                        controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                        self.strItemId = self.arrMenuitem[indexPath.row].id
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
//                }
////                    cell.selectionStyle = .none
//                return cell
//            } else {
//                let cell:RestaurantItemCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath) as! RestaurantItemCell
//                let variantValue = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant.ToDouble()
//                cell.lblItemName.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name.trimmingCharacters(in: .whitespacesAndNewlines)
//                cell.lblItemPrice.text = "\(CurrencySymbol)" + arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].price.ConvertToTwoDecimal()
//                cell.lblAboutItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].Description
//                cell.ExpandedLabel = { index in
//                    cell.lblAboutItem.numberOfLines =  cell.lblAboutItem.numberOfLines == 0 ? 3 : 0
//                    cell.lblAboutItem.collapsed = cell.lblAboutItem.numberOfLines != 0
////                        self.tblRestaurantDetails.reloadData()
//                    self.tblRestaurantDetails.reloadRows(at: [indexPath], with: .none)
//                }
//                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].image ?? "")"
//                cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
//                cell.lblNoOfItem.text = arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//
//                cell.btnAddItem.isHidden = false
//                cell.vwStapper.isHidden = true
//                cell.stackHide.isHidden = false
//                self.activityView.stopAnimating()
//                if indexPath.section == 1 && indexPath.row == 0{
//                    if objRestaurant.foodType == 1{
//                        cell.vwRadius.cornerRadius = 5
//                        cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
//                        cell.vwRadius.layer.borderWidth = 1
//                    }else{
//                        cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
//                    }
//                }else{
//                    cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
//                }
//                if Int(arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
//                    cell.btnAddItem.isHidden = true
//                    cell.vwStapper.isHidden = false
//                }
//
//                if arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].variant == "1"{
//                    cell.btnCustomize.isHidden = false
//                }else{
//                    cell.btnCustomize.isHidden = true
//                }
//                cell.decreaseData = { [self] in
//                    if variantValue > 0 && self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].totalvariant.toInt() > 1{
//                        if variantValue > 0{
//                            self.arrItemList = [ItemList]()
//                            self.tblPopup.showAnimatedSkeleton()
//                            self.tblPopup.reloadData()
//                            self.ViewForBottom.constant = 0
//                            self.viewPopup.layoutIfNeeded()
//                            self.viewPopup.layoutSubviews()
//                            self.viewBG.isHidden = false
//                            self.viewPopup.isHidden = false
//                            UIView.animate(withDuration: 0.6, animations: {
//                                //                                self.view.layoutIfNeeded()
//                            }){ (success) in
//                                self.isfromMenu = false
//                                self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId)
//                                self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                            }
//                        }else{
//                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
//                            self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                            self.isfromMenu = false
//                            cell.stackHide.isHidden = true
//                            self.activityView.center = cell.vwStapper.center
//                            cell.vwStapper.addSubview(self.activityView)
//                            self.activityView.startAnimating()
//                        }
//                    }else{
//                        self.isfromMenu = false
//                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                        cell.stackHide.isHidden = true
//                        self.activityView.center = cell.vwStapper.center
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                    }
//                }
//                cell.IncreseData = {
//                    if variantValue > 0{
//                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                        controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                        controller.isFromRestaurant = true
//                        controller.selectedRestaurantId = self.objRestaurant.id
//                        controller.delegateAddVariant = self
//                        self.strItemId = self.arrMenuitem[indexPath.row].id
//                        controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }else{
//                        let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                        if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
//                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section - 1)
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
//                        self.isfromMenu = false
//                        cell.stackHide.isHidden = true
//                        self.activityView.center = cell.vwStapper.center
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                        }else{
//                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
//                        }
//                    }
//                }
//                cell.btnAddAction = {
//                    if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
//                        let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
//                        let navController = UINavigationController.init(rootViewController: vc)
//                        navController.modalPresentationStyle = .overFullScreen
//                        navController.navigationController?.modalTransitionStyle = .crossDissolve
//                        navController.navigationBar.isHidden = true
//                        SingletonClass.sharedInstance.isPresented = true
//                        self.present(navController, animated: true, completion: nil)
//                    }else{
//                        if self.objRestaurant.isdiff == 0{
//                            let alert = UIAlertController(title: "Adelante System", message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                            let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                                if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
//                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                                    controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                                    controller.selectedRestaurantId = self.objRestaurant.id
//                                    controller.isFromRestaurant = true
//                                    controller.delegateAddVariant = self
//                                    controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                                    self.strItemId = self.arrMenuitem[indexPath.row].id
//                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }else{
//                                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                                    if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
//                                        cell.btnAddItem.isHidden = true
//                                        cell.vwStapper.isHidden = false
//                                        self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                        cell.stackHide.isHidden = true
//                                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                        cell.vwStapper.addSubview(self.activityView)
//                                        self.activityView.startAnimating()
//                                    }else{
//                                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
//                                    }
//                                }
//                            }
//                            let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                            alert.addAction(yesAction)
//                            alert.addAction(NoAction)
//                            self.present(alert, animated: true, completion: nil)
//                        }else{
//                            if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
//                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                                controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                                controller.selectedRestaurantId = self.objRestaurant.id
//                                controller.isFromRestaurant = true
//                                controller.delegateAddVariant = self
//                                self.strItemId = self.arrMenuitem[indexPath.row].id
//                                controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                                self.navigationController?.pushViewController(controller, animated: true)
//                            }else{
//                                let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                                if self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity > value {
//                                    cell.btnAddItem.isHidden = true
//                                    cell.vwStapper.isHidden = false
//                                    self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                    cell.stackHide.isHidden = true
//                                    self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                    cell.vwStapper.addSubview(self.activityView)
//                                    self.activityView.startAnimating()
//                                }else{
//                                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].quantity]), vc: self)
//                                }
//                            }
//                        }
//                    }
//                }
//                if variantValue > 0{
//                    cell.btnCustomize.isHidden = false
//                }else{
//                    cell.btnCustomize.isHidden = true
//                }
//                cell.customize = {
//                    if self.objRestaurant.isdiff == 0{
//                        let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                        let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                            controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                            controller.selectedRestaurantId = self.objRestaurant.id
//                            controller.delegateAddVariant = self
//                            controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                            self.strItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
//                        let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                        alert.addAction(yesAction)
//                        alert.addAction(NoAction)
//                        self.present(alert, animated: true, completion: nil)
//                    }else{
//                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                        controller.selectedItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                        controller.selectedRestaurantId = self.objRestaurant.id
//                        controller.delegateAddVariant = self
//                        controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                        self.strItemId = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].id
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
//                }
////                    cell.selectionStyle = .none
//                return cell
//            }
//        } else {
//            let cell:RestaurantItemCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath) as! RestaurantItemCell
//            let variantValue = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant.ToDouble()
//            cell.lblItemName.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].name
//            cell.lblAboutItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].Description
//            cell.ExpandedLabel = { index in
//                cell.lblAboutItem.numberOfLines =  cell.lblAboutItem.numberOfLines == 0 ? 3 : 0
//                cell.lblAboutItem.collapsed = cell.lblAboutItem.numberOfLines != 0
////                    self.tblRestaurantDetails.reloadData()
//                self.tblRestaurantDetails.reloadRows(at: [indexPath], with: .none)
//
//            }
//            let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrFoodMenu[indexPath.section].subMenu[indexPath.row].image ?? "")"
//            cell.imgFoodDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            cell.imgFoodDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
//
//            cell.lblItemPrice.text = CurrencySymbol + arrFoodMenu[indexPath.section].subMenu[indexPath.row].price
////                cell.lblSizeOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].size
//            cell.lblNoOfItem.text = arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty
//            cell.btnAddItem.isHidden = false
//            cell.vwStapper.isHidden = true
//            cell.stackHide.isHidden = false
//            self.activityView.stopAnimating()
//            if Int(arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty) ?? 0 > 0 {
//                cell.btnAddItem.isHidden = true
//                cell.vwStapper.isHidden = false
//            }
//            if indexPath.section == 0 && indexPath.row == 0{
//                if objRestaurant.foodType == 1{
//                    cell.vwRadius.cornerRadius = 5
//                    cell.vwRadius.layer.borderColor = colors.appOrangeColor.value.cgColor
//                    cell.vwRadius.layer.borderWidth = 1
//                }else{
//                    cell.vwRadius.layer.borderColor = colors.clearCol.value.cgColor
//                }
//            }
//            if arrFoodMenu[indexPath.section].subMenu[indexPath.row].variant == "1"{
//                cell.btnCustomize.isHidden = false
//            }else{
//                cell.btnCustomize.isHidden = true
//            }
//            cell.decreaseData = {
//                if variantValue > 0 && self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].totalvariant.toInt() > 1{
//                    if variantValue > 0{
//                        self.arrItemList = [ItemList]()
//                        self.tblPopup.showAnimatedSkeleton()
//                        self.tblPopup.reloadData()
//                        self.ViewForBottom.constant = 0
//                        self.viewPopup.layoutIfNeeded()
//                        self.viewPopup.layoutSubviews()
//                        self.viewBG.isHidden = false
//                        self.viewPopup.isHidden = false
//                        UIView.animate(withDuration: 0.6, animations: {
//                            //                                self.view.layoutIfNeeded()
//                        }){ (success) in
//                            self.isfromMenu = false
//                            self.webserviceItemList(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId)
//                            self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                        }
//                    }else{
//                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                        self.isfromMenu = false
//                        cell.stackHide.isHidden = true
//                        self.activityView.center = cell.vwStapper.center
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                    }
//                }else{
//                    self.isfromMenu = false
//                    self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                    self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                    cell.stackHide.isHidden = true
//                    self.activityView.center = cell.vwStapper.center
//                    cell.vwStapper.addSubview(self.activityView)
//                    self.activityView.startAnimating()
//                }
//            }
//            cell.IncreseData = { [self] in
//                if variantValue > 0{
//                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                    controller.selectedItemId = self.arrMenuitem[indexPath.row].id
//                    controller.selectedRestaurantId = self.objRestaurant.id
//                    controller.isFromRestaurant = true
//                    controller.delegateAddVariant = self
//                    controller.AddVeriantQty = self.arrMenuitem[indexPath.row].cartQty
//                    self.strItemId = self.arrMenuitem[indexPath.row].id
//                    self.navigationController?.pushViewController(controller, animated: true)
//                }else{
//                    let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                    if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
//                        self.selectedIndexItem = IndexPath(row: indexPath.row, section: indexPath.section)
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartItemId, strQty: "1", strType: "1", row: indexPath.row)
//                        cell.stackHide.isHidden = true
//                        self.isfromMenu = false
//                        self.activityView.center = cell.vwStapper.center
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                    }else{
//                        Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
//                    }
//                }
//            }
//            if variantValue > 0{
//                cell.btnCustomize.isHidden = false
//            }else{
//                cell.btnCustomize.isHidden = true
//            }
//            cell.btnAddAction = {
//                if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? false == false{
//                    let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
//                    let navController = UINavigationController.init(rootViewController: vc)
//                    navController.modalPresentationStyle = .overFullScreen
//                    navController.navigationController?.modalTransitionStyle = .crossDissolve
//                    navController.navigationBar.isHidden = true
//                    SingletonClass.sharedInstance.isPresented = true
//                    self.present(navController, animated: true, completion: nil)
//                }else{
//                    if self.objRestaurant.isdiff == 0{
//                        let alert = UIAlertController(title: "Adelante System", message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                        let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                            if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > 1 && variantValue > 0 {
//                                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                                controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                                controller.selectedRestaurantId = self.objRestaurant.id
//                                controller.isFromRestaurant = true
//                                controller.delegateAddVariant = self
//                                self.strItemId = self.arrMenuitem[indexPath.row].id
//                                controller.AddVeriantQty = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty
//                                self.navigationController?.pushViewController(controller, animated: true)
//                            }else{
//                                let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                                if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
//                                    cell.btnAddItem.isHidden = true
//                                    cell.vwStapper.isHidden = false
//                                    self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                    cell.stackHide.isHidden = true
//                                    self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                    cell.vwStapper.addSubview(self.activityView)
//                                    self.activityView.startAnimating()
//                                }else{
//                                    Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
//                                }
//                            }
//                        }
//                        let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                        alert.addAction(yesAction)
//                        alert.addAction(NoAction)
//                        self.present(alert, animated: true, completion: nil)
//                    }else{
//                        if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > 1 && variantValue > 0{
//                            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                            controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                            controller.selectedRestaurantId = self.objRestaurant.id
//                            controller.isFromRestaurant = true
//                            controller.delegateAddVariant = self
//                            controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                            self.strItemId = self.arrMenuitem[indexPath.row].id
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }else{
//                            let value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
//                            if self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity > value {
//                                cell.btnAddItem.isHidden = true
//                                cell.vwStapper.isHidden = false
//                                self.webwerviceAddtoCart(strItemId: self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id, Section: indexPath.section, row: indexPath.row)
//                                cell.stackHide.isHidden = true
//                                self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 15, y: cell.vwStapper.frame.height/2)
//                                cell.vwStapper.addSubview(self.activityView)
//                                self.activityView.startAnimating()
//                            }else
//                            {
//                                Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized(), arguments: ["\(self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].name ?? "")",self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].quantity]), vc: self)
//                            }
//                        }
//                    }
//                }
//
//            }
//
//            cell.customize = {
//                if self.objRestaurant.isdiff == 0{
//                    let alert = UIAlertController(title: AppName, message: "If you are adding the item from this restaurant then your previously added items will be removed", preferredStyle: UIAlertController.Style.alert)
//                    let yesAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
//                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                        controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                        controller.selectedRestaurantId = self.objRestaurant.id
//                        controller.delegateAddVariant = self
//                        controller.AddVeriantQty = self.arrFoodMenu[indexPath.section - 1].subMenu[indexPath.row].cartQty
//                        self.strItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
//                    let NoAction = UIAlertAction(title: "No", style: .default, handler: nil)
//                    alert.addAction(yesAction)
//                    alert.addAction(NoAction)
//                    self.present(alert, animated: true, completion: nil)
//                }else{
//                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID) as! BffComboVC
//                    controller.selectedItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                    controller.selectedRestaurantId = self.objRestaurant.id
//                    controller.delegateAddVariant = self
//                    controller.AddVeriantQty = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].cartQty
//                    self.strItemId = self.arrFoodMenu[indexPath.section].subMenu[indexPath.row].id
//                    self.navigationController?.pushViewController(controller, animated: true)
//                }
//            }
////                cell.selectionStyle = .none
//            return cell
//        }
//    }else{
//        if responseStatus == .gotData{
//            if arrItemList.count != 0 {
//                let cell:RestaurantDetailsPopupCell = tblPopup.dequeueReusableCell(withIdentifier: RestaurantDetailsPopupCell.reuseIdentifier) as! RestaurantDetailsPopupCell
//                cell.lblItemName.text = arrItemList[indexPath.row].itemName
//                cell.lblPrice.text = "\(CurrencySymbol)" + "\(arrItemList[indexPath.row].subTotal ?? 0)"
//                cell.lblDesc.text = arrItemList[indexPath.row].descriptionField
//
//                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrItemList[indexPath.row].itemImg ?? "")"
//                cell.imgRestDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell.imgRestDetails.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
//                cell.lblNoOfItem.text = arrItemList[indexPath.row].qty
//                cell.stackHide.isHidden = false
//                self.strItemId = arrItemList[indexPath.row].id
//                if arrItemList[indexPath.row].qty == "0"{
//                    cell.btnAdd.isHidden = false
//                    cell.vwStapper.isHidden = true
//                }else{
//                    cell.btnAdd.isHidden = true
//                    cell.vwStapper.isHidden = false
//                }
//                cell.IncreseData = {
//                    self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "1",row: indexPath.row)
//                    cell.stackHide.isHidden = true
//                    self.activityView.center = cell.vwStapper.center
//                    cell.vwStapper.addSubview(self.activityView)
//                    self.activityView.startAnimating()
//                }
//                cell.decreaseData = {
//                    self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "0", row: indexPath.row)
//                    cell.stackHide.isHidden = true
//                    self.activityView.center = cell.vwStapper.center
//                    cell.vwStapper.addSubview(self.activityView)
//                    self.activityView.startAnimating()
//                }
//                cell.btnAddAction = {
//                    if self.arrItemList[indexPath.row].quantity.ToDouble() > 1 {
//                        cell.btnAdd.isHidden = true
//                        cell.vwStapper.isHidden = false
//                        self.webserviceUpdateCartQuantity(strItemid: self.arrItemList[indexPath.row].cartItemId, strQty: "1", strType: "1",row: indexPath.row)
//                        cell.stackHide.isHidden = true
//                        self.activityView.center = CGPoint(x: cell.vwStapper.frame.width / 2 + 10, y: cell.vwStapper.frame.height/2)
//                        cell.vwStapper.addSubview(self.activityView)
//                        self.activityView.startAnimating()
//                    }
//                }
////                    cell.selectionStyle = .none
//                return cell
//
//            }else{
//                let cell = tblPopup.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
////                    cell.selectionStyle = .none
//                return cell
//            }
//        }else{
//            let cell = tblPopup.dequeueReusableCell(withIdentifier: ShimmerCell.reuseIdentifier, for: indexPath) as! ShimmerCell
////                cell.selectionStyle = .none
//            return cell
//        }
//    }
//}
