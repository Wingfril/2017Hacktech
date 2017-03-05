//
//  ViewController.swift
//  Hacktech
//
//  Created by Ramya D. on 3/4/17.
//  Copyright © 2017 hacktech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var ocrText: UILabel!
    
    @IBAction func sendHttpRequest(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: "https://westus.api.cognitive.microsoft.com/vision/v1.0/analyze?visualFeatures=Categories&language=en")!)
        request.httpMethod = "POST"
        let path = "https://www.fda.gov/ucm/groups/fdagov-public/documents/image/ucm501515.png"
        request.httpBody = "{\"url\":\"\(path)\"}".data(using: String.Encoding.utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("9f6fd2c2da4b41dcb7cff000ac81776a", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        let task = URLSession.shared.dataTask(with:request){data, response, error in guard let data = data, error == nil else{
            print("error='(error)")
            return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                self.ocrText.text = "statusCode should be 200, but is \(httpStatus.statusCode)"
                self.ocrText.text = "response = \(response)"
            }
            else{
                
                let responseString = String(data: data, encoding: .utf8)
                self.ocrText.text = responseString
            }
        }
        task.resume()
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

