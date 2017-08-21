//
//  UIViewController+Navigation.swift
//  PilotPlantSwift
//
//  Created by lingostar on 2014. 10. 28..
//  Copyright (c) 2014년 lingostar. All rights reserved.
//

import UIKit

private var backButtonHidden : Bool = false
private var tapKBDismiss : Bool = false

private let ImageViewTag = 100

class ImagePickerDelegate : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var imageView: UIImageView?
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView?.image = editedImage ?? originalImage
        picker.dismiss(animated: true, completion: nil)
        imagePickerDelegate = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerDelegate = nil
    }
}

var imagePickerDelegate: ImagePickerDelegate?


public extension UIViewController {
    
    @IBAction func modalDismiss(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modalDismissPush(_ sender : Any){
        var destVC : UIViewController! = nil
        if let presentingVC = self.presentingViewController as? UITabBarController {
            if let tempVC = presentingVC.selectedViewController as? UINavigationController {
                destVC = tempVC.topViewController
            } else {
                destVC = self.presentingViewController
            }
        } else if let presentingVC = self.presentingViewController as? UINavigationController {
            destVC = presentingVC.topViewController
        } else {
            destVC = self.presentingViewController
        }
        
        destVC.performSegue(withIdentifier: "ModalDismissPush", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigationBack(_ sender : Any){
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        }
    }
    
    @IBAction func navigationBackToRoot(_ sender : Any){
        if let navi = self.navigationController {
            navi.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
    }
    
    
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        imagePickerDelegate = ImagePickerDelegate()
        imagePickerDelegate?.imageView = self.view.viewWithTag(ImageViewTag) as? UIImageView
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = imagePickerDelegate!
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: { imageP in
            
        })
    }
    
    @IBInspectable var backHidden : Bool {
        get {
            return self.navigationItem.hidesBackButton
        }
        set (newValue){
            self.navigationItem.hidesBackButton = newValue
        }
    }
    
}

