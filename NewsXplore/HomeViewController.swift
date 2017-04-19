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
import UserNotifications

protocol TrackingDelegate: class {
    func trackingReceiveSuccess(tracking: Tracking?)
    func trackingReceiveFailed(error: String)
}

protocol StatusPollDelegate: class {
    func statusPollPending(tracking: Tracking?)
    func statusPollSuccess(statusPoll: StatusPoll?)
    func statusPollReceiveFailed(error: String)
}

protocol EntityExtractDelegate: class {
    func entityExtractAPISuccess(inputEntityTrackingId: String?)
    func entityExtractAPIFailed(error: String)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    let coreDataStack = CoreDataStack.sharedInstance
    var placeholderLabel: UILabel!
    var success = false
    
    weak var trackingDelegate: TrackingDelegate?
    weak var statusPollDelegate: StatusPollDelegate?
    weak var entityExtractDelegate: EntityExtractDelegate?
    
    // Sample URL.
    // TODO: Change to dev.newsxplore.com
    let baseUrl = "http://localhost:8084"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analyzeButton.layer.cornerRadius = 7
        trackingDelegate = self
        statusPollDelegate = self
        entityExtractDelegate = self
        
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
            let alert = UIAlertController(title: "Sending for analysis", message: "The text is being sent for analysis.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in
                self.entityExtractAnalyze()
                self.textView.endEditing(true)
                self.textView.resignFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
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
    
    func entityExtractAnalyze() {
        let parameters: Parameters = [
            "text": textView.text
        ]
        
        Alamofire.request(baseUrl.appending("/gnlp_proxy/entities"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let error = response.error {
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPIFailed(error: error.localizedDescription)
                }
                
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                let inputEntityTrackingId = json["data"] as? String
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPISuccess(inputEntityTrackingId: inputEntityTrackingId)
                }
            }
        }
    }
    
    func httpPostAnalyze(inputEntityTrackingId: String) {
        
        var tracking: Tracking?
        
        let parameters: Parameters = [
            //            "stmt": "H-1B program will be continued and they cannot take off the whole program out of the scope. But there can be some changes in the application process and application fees.",
            //            "tags": "H1B-visa",
            "stmt": textView.text,
            "tags": tagsTextField.text ?? "",
            "limit": "src|most_likely"
        ]
        
        Alamofire.request(baseUrl.appending("/analyze"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let error = response.error {
                DispatchQueue.main.async {
                    self.trackingDelegate?.trackingReceiveFailed(error: error.localizedDescription)
                }
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                tracking = self.coreDataStack.updateOrInsertTracking(json: json, text: self.textView.text, inputEntityTrackingId: inputEntityTrackingId)
                // TODO: Need better handling
                DispatchQueue.main.async {
                    self.trackingDelegate?.trackingReceiveSuccess(tracking: tracking)
                }
            } else {
                DispatchQueue.main.async {
                    self.trackingDelegate?.trackingReceiveFailed(error: "Tracking JSON response parsing failure")
                }
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
            
            if let json = response.result.value as? [String: Any] {
                
                let statusPoll = self.coreDataStack.updateOrInsertStatusPoll(json: json, tracking: tracking)
                
                if statusCode == 202 {
                    DispatchQueue.main.async {
                        self.statusPollDelegate?.statusPollPending(tracking: tracking)
                    }
                } else if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.statusPollDelegate?.statusPollSuccess(statusPoll: statusPoll)
                    }
                } else {
                    if let error = response.error {
                        DispatchQueue.main.async {
                            self.statusPollDelegate?.statusPollReceiveFailed(error: error.localizedDescription)
                        }
                    }
                }
                
            }
        }
    }
    
}

extension HomeViewController: EntityExtractDelegate {
    func entityExtractAPISuccess(inputEntityTrackingId: String?) {
        if let inputEntityTrackingId = inputEntityTrackingId {
            httpPostAnalyze(inputEntityTrackingId: inputEntityTrackingId)
        }
    }
    
    func entityExtractAPIFailed(error: String) {
        debugPrint("EntityExtract error: \(error)")
    }
    
    
}

extension HomeViewController: TrackingDelegate {
    func trackingReceiveSuccess(tracking: Tracking?) {
        if let tracking = tracking {
            self.httpGetAnalyzedData(tracking: tracking)
        }
    }
    
    func trackingReceiveFailed(error: String) {
        // ToDo
        debugPrint("Tracking Error: \(error)")
    }
    
}

extension HomeViewController: StatusPollDelegate {
    func statusPollPending(tracking: Tracking?) {
        httpGetAnalyzedData(tracking: tracking)
    }
    
    func statusPollSuccess(statusPoll: StatusPoll?) {
        // ToDo
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                }
            }
            
            let localNotif = UNMutableNotificationContent()
            localNotif.title = NSString.localizedUserNotificationString(forKey: "NewsXplore:", arguments: nil)
            localNotif.body = NSString.localizedUserNotificationString(forKey: "A report is ready for you!", arguments: nil)
            localNotif.sound = UNNotificationSound.default()
            localNotif.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
            localNotif.categoryIdentifier = "edu.missouri.nx"
            // Deliver the notification instantly
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest.init(identifier: "Content Ready", content: localNotif, trigger: trigger)
            
            // Schedule the notification.
            center.add(request)
        } else {
            // Older version support
        }
    }
    
    func statusPollReceiveFailed(error: String) {
        // ToDo
        debugPrint("StatusPoll Error: \(error)")
    }
    
}

extension HomeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

