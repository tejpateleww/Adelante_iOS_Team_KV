//
//  ImagePicker.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 13/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import SDWebImage

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, SelectedTag:Int)
}

open class ImagePicker: NSObject {

    private lazy var pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var SelectedTag:Int = 0
   
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, allowsEditing : Bool) {
//        self.pickerController = UIImagePickerController()

        super.init()
        
        self.pickerController.navigationController?.isNavigationBarHidden = false
        self.presentationController = presentationController
        self.delegate = delegate
       
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowsEditing

        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String, tag : Int) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera {
               // checkCameraAccess()//self.checkCamera()
            } else {
                self.pickerController.sourceType = type
//                self.pickerController.modalPresentationStyle = .overCurrentContext
                self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }
   
    public func present(from sourceView: UIView , viewPresented : UIView, isRemove:Bool) {
        self.SelectedTag = sourceView.tag
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo", tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll", tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library", tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        let api_vector = UIImageView()
        api_vector.sd_setImage(with: URL(string: "http://qwnched.excellentwebworld.in/assets/images/default_user.png"))
//        http://qwnched.excellentwebworld.in/assets/images/default_user.png
        if let sourceImage = (sourceView as! UIImageView).image {
            if let defaultImage = UIImage(named: "dummy_User") {
                let isDefaultImage = sourceImage.isEqualToImage(defaultImage)
                if (!isDefaultImage) && !(sourceImage.isEqualToImage(api_vector.image ?? UIImage())) && isRemove == true{
                    alertController.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler:
                    { (action) in
                        self.delegate?.didSelect(image: nil, SelectedTag:101)
                    }))
                }
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
//       alertController.modalPresentationStyle = .overCurrentContext
        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        self.delegate?.didSelect(image: image, SelectedTag: self.SelectedTag)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
        self.pickerController(picker, didSelect: chosenImage)
    }
}

extension ImagePicker {
    
    func callCamera(){
        self.pickerController.sourceType = .camera
//        self.pickerController.modalPresentationStyle = .overCurrentContext
        self.presentationController?.present(self.pickerController, animated: true)
    }
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: callCamera()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            alertToEncourageCameraAccessInitially()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            self.callCamera()
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    DispatchQueue.main.async {
                        self.callCamera()
                        print("Permission granted, proceed")
                    }
                  
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            print("Dafaukt casr < Image Picker class")
        }
    }
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        self.presentationController?.present(alert, animated: true)
    }
}



