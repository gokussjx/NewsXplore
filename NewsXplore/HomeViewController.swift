//
//  ViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 2/7/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    // Sample URL. 
    // TODO: Change to dev.newsxplore.com
    let baseUrl = "https://jsonplaceholder.typicode.com/posts/1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analyzeButton.layer.cornerRadius = 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func analyzeButton(_ sender: UIButton) {
        Alamofire.request(baseUrl).responseJSON { response in
            
//            print("Request: ", terminator: "")
//            print(response.request ?? "Request not found")  // original URL request
//            
//            print("Response: ", terminator: "")
//            print(response.response ?? "Response not found")// HTTP URL response
//            
//            print("Data: ", terminator: "")
//            print(response.data ?? "Data not found")        // server data
//            
//            print("Result: ", terminator: "")
//            print(response.result)    // result of response serialization
            
            if let json = response.result.value as? [String : Any] {
                let title = json["title"] as? String
                let userId = json["userId"] as? Int
                let id = json["id"] as? Int
                let body = json["body"] as? String
                
                print("Title: \(title!)")
                print("UserID: \(userId!)")
                print("ID: \(id!)")
                print("Body: \(body!)")
            }
        }
    }
}

