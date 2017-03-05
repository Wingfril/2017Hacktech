//
//  OCRViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 5/13/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class OCRViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imagev: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
   // @interface OCRViewController : UIViewController <UIImagePickerControllerDelegate;UINavigationControllerDelegate>
    let ocr = CognitiveServices.sharedInstance.ocr

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func loadPDF(filename: String, webView: UIWebView) {
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = NSURL(fileURLWithPath: filename)
        let urlRequest = NSURLRequest(url: url as URL)
        print("Hey we're still alive")
        webView.loadRequest(urlRequest as URLRequest)
        //UIWebView.loadRequest(UIWebViewInstance)(NSURLRequest(URL: NSURL(string: "google.ca")!))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        
        //imagev.image = selectedImage
        
        print(selectedImage.size.width*selectedImage.scale)
        print(selectedImage.size.height*selectedImage.scale)
        
        var resizedIm:UIImage
        
        if selectedImage.size.width*selectedImage.scale>1480 || selectedImage.size.height*selectedImage.scale>1480
        {
            resizedIm = resizeImage(image: selectedImage, targetSize: CGSize(width: 1480, height: 1480))
        }
        else
        {
            resizedIm = selectedImage
        }
        
        print("imageresized")
        imagev.image = resizedIm
        
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((resizedIm
), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var imageSize: Int = imgData.length
        print("size of image in KB: " + String(imageSize/1024))
        
        print(resizedIm.size.width*resizedIm.scale)
        print(resizedIm.size.height*resizedIm.scale)
        dismiss(animated: true, completion: nil)
        let requestObject: OCRRequestObject = (resource: UIImagePNGRepresentation(resizedIm)!, language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            print("printing response")
            //print(response!)
            
            let text = self.ocr.extractStringFromDictionary(response!)

            //self.resultTextView.text = text
            
            print(1111111111)
            var temp = ""
            self.ocr.summarize(text) {(final, error) -> Void in
                print("GAHHH")
                if let final = final{
                    
                    
                    //print(final)
                    temp = "" + final
                    //self.resultTextView.text = final
                    //self.resultTextView.text = temp
                    let html = temp
                    print("before")
                    DispatchQueue.main.sync(execute: {
                    let fmt = UIMarkupTextPrintFormatter(markupText: html)
                    print("got html")
                    // 2. Assign print formatter to UIPrintPageRenderer
                    let render = UIPrintPageRenderer()
                    render.addPrintFormatter(fmt, startingAtPageAt: 0)
                    
                    // 3. Assign paperRect and printableRect
                    let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
                    let printable = page.insetBy(dx: 0, dy: 0)
                    
                    render.setValue(NSValue(cgRect: page), forKey: "paperRect")
                    render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
                    
                    // 4. Create PDF context and draw
                    let pdfData = NSMutableData()
                    UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
                    print("got pdfData")
                    for i in 1...render.numberOfPages {
                        
                        UIGraphicsBeginPDFPage();
                        let bounds = UIGraphicsGetPDFContextBounds()
                        render.drawPage(at: i - 1, in: bounds)
                    }
                    
                    UIGraphicsEndPDFContext();
                    
                    // 5. Save PDF file
                    let path = "\(NSTemporaryDirectory())file.pdf"
                    print(path)
                    pdfData.write(toFile: path, atomically: true)
                    
                    self.loadPDF(filename: path, webView: self.webView)
                    print("loaded path")
                    print("open \(path)") // command to open the generated file
                
                    })
                
                    
                } else{
                    print(error as Any)
                }
                
                
                
            }
            print("fuu")
            print(temp)
            
        })
    }

    
    @IBAction func textFromUrlDidPush(_ sender: UIButton) {
        let requestObject: OCRRequestObject = (resource: urlTextField.text!, language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            
        })

    }
    
     
    @IBAction func textFromImageDidPush(_ sender: UIButton) {
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

   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PDF"{
            let PDF = segue.destination
    }*/
    
    func textFromCameraRoll(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    

}

