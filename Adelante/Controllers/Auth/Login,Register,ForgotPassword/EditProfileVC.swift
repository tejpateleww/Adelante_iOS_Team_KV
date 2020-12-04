//
//  EditProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileVC: UIViewController {
    
    

    @IBOutlet weak var btnUpdatePicture: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!{ didSet{ imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2}}
    
    
    private var imagePicker: ImagePicker!
    var selectedImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing : false)
        
    }
    
    
    
    @IBAction func btnProfilePicTap(_ sender: UIButton)
    {
        self.imagePicker.present(from: self.imgProfile, viewPresented: self.view)
    }
}
extension EditProfileVC:ImagePickerDelegate{
    func didSelect(image: UIImage?, SelectedTag:Int) {
        
          
        }
    }


