//
//  ViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 2/7/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    let coreDataStack = CoreDataStack.sharedInstance
    var placeholderLabel: UILabel!
    var success = false
    
    // Sample URL.
    // TODO: Change to dev.newsxplore.com
    let baseUrl = "http://localhost:8084"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analyzeButton.layer.cornerRadius = 7
        
        textView.delegate = self
        
        setPlaceholder()
        
        // Hide keyboard on tapping any empty space on the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter text here..."
        //        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
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
        let reachability = Reachability()!
        if reachability.isReachable && textView.text.characters.count > 10 {
            httpPostAnalyze()
        } else {
            if textView.text.isEmpty {
                let alert = UIAlertController(title: "Empty", message: "Please enter or paste text to analyze.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if textView.text.characters.count < 10 {
                let alert = UIAlertController(title: "Too few characters", message: "Please enter or paste more text to analyze.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            } else { // Offline
                // TODO: Implement Queue
                
                // Currently, displaying an alert
                let alert = UIAlertController(title: "Offline", message: "Unable to connect to internet! Please connect and retry.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func httpPostAnalyze() {
        
        var tracking: Tracking?
        
        let parameters: Parameters = [
//            "stmt": "H-1B program will be continued and they cannot take off the whole program out of the scope. But there can be some changes in the application process and application fees.",
//            "tags": "H1B-visa",
            "stmt": textView.text,
            "tags": tagsTextField.text ?? "",
            "limit": "src|most_likely"
        ]
        
        Alamofire.request(baseUrl.appending("/analyze"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                
                tracking = self.coreDataStack.updateOrInsertTracking(json: json, text: self.textView.text)
                // TODO: Need better handling
                self.httpGetAnalyzedData(tracking: tracking)
            }
        }
    }
    
    func httpGetAnalyzedData(tracking: Tracking?) {
        guard let trackingID = tracking?.trackingId else {
            // CAUTION: TODO: Better handling. This is BAD!
            return
        }
        
        Alamofire.request(baseUrl.appending("/r/\(trackingID)")).responseJSON { response in
            
            guard let statusCode = response.response?.statusCode else {
                return
            }
            
            if statusCode == 202 {
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                self.coreDataStack.updateOrInsertStatusPoll(json: json, tracking: tracking)
            }
        }
    }
    
}

extension HomeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

