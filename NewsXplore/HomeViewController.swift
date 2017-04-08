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
    @IBOutlet weak var textView: UITextView!
    var placeholderLabel: UILabel!
    
    // Sample URL.
    // TODO: Change to dev.newsxplore.com
    //    let baseUrl = "https://jsonplaceholder.typicode.com/posts/1"
    let baseUrl = "localhost:8084"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analyzeButton.layer.cornerRadius = 7
        
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter text here..."
//        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // Hide keyboard on tapping any empty space on the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func pasteButton(_ sender: Any) {
        if let clipboardContent = UIPasteboard.general.string {
            textView.insertText(clipboardContent)
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        textView.text = ""
        textViewDidChange(textView)
    }
    
    @IBAction func analyzeButton(_ sender: UIButton) {
        
        
        //        Alamofire.request().responseJSON { response in
        
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
        
        //            if let json = response.result.value as? [String : Any] {
        //                let title = json["title"] as? String
        //                let userId = json["userId"] as? Int
        //                let id = json["id"] as? Int
        //                let body = json["body"] as? String
        //
        //                print("Title: \(title!)")
        //                print("UserID: \(userId!)")
        //                print("ID: \(id!)")
        //                print("Body: \(body!)")
        //            }
        //        }
        
//        var statusPoll = StatusPoll()
//        //        var newsCategories = [NewsCategory]()
//        if let path = Bundle.main.path(forResource: "results_mod", ofType: "json"),
//            let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                statusPoll = StatusPoll(json: json!)!
//            }
//        }
//        
//        let _ = 5
    }
}

extension HomeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
}

