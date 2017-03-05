import UIKit

class PDF:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let finalText: AnyObject? = UserDefaults.standard.object(forKey: "finalText") as AnyObject?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print(finalText)

    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

}
