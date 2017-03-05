//
//  ViewController.swift
//  Hacktech2017
//
//  Created by Ziyan Mo on 3/4/17.
//  Copyright © 2017 Ziyan Mo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
//Mark: hi
    @IBOutlet weak var existingPic: UIButton!
    @IBOutlet weak var takeImage: UIButton!
    
    @IBOutlet weak var photoURL: UILabel!
    @IBOutlet weak var selectImageFromPhotoLib: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        //selected image is the one that you gott//
        
        // Set photoImageView to display the selected image.
        selectImageFromPhotoLib.image = selectedImage
        
        //get path of image
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.photoURL.text = imageURL.absoluteString

        
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

//MARK: Actions
    @IBAction func selectImageFromPhotolibrary(_ sender: UITapGestureRecognizer) {
            // Hide the keyboard.
            //nameTextField.resignFirstResponder()
            
            // UIImagePickerController is a view controller that lets a user pick media from their photo library.
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .photoLibrary
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    
    @IBAction func TakePhotoFromCamera(_ sender: UITapGestureRecognizer) {
        
        let imagePicker =  UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    

}

