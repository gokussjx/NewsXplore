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
import Toast_Swift


protocol EntityTrackingDelegate: class {
    func entityTrackingAPISuccess(inputEntityTrackingId: String?)
    func entityTrackingAPIFailed(error: String)
}

protocol EntityExtractDelegate: class {
    func entityExtractAPISuccess(inputEntityTrackingId: String?, extractedEntities: [EntityExtracted])
    func entityExtractAPIFailed(inputEntityTrackingId: String?)
}

protocol TrackingDelegate: class {
    func trackingReceiveSuccess(tracking: Tracking?)
    func trackingReceiveFailed(error: String)
}

protocol StatusPollDelegate: class {
    func statusPollPending(tracking: Tracking?)
    func statusPollSuccess(statusPoll: StatusPoll?)
    func statusPollReceiveFailed(error: String)
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
    weak var entityTrackingDelegate: EntityTrackingDelegate?
    weak var entityExtractDelegate: EntityExtractDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analyzeButton.layer.cornerRadius = 7
        trackingDelegate = self
        statusPollDelegate = self
        entityTrackingDelegate = self
        entityExtractDelegate = self
        
        textView.delegate = self
        
        textView.text = "If you were a Muslim you could come in, but if you were a Christian, it was almost impossible."
        tagsTextField.text = "Muslim"
        
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
                self.httpEntityExtractTracking()
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
    
    // 1 - POST request to get entity tracking Id
    func httpEntityExtractTracking() {
        let parameters: Parameters = [
            "text": textView.text
        ]
        
        Alamofire.request(NXUtil.baseUrl.appending("/gnlp_proxy/entities"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let error = response.error {
                DispatchQueue.main.async {
                    self.entityTrackingDelegate?.entityTrackingAPIFailed(error: error.localizedDescription)
                }
                
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                let inputEntityTrackingId = json["data"] as? String
                DispatchQueue.main.async {
                    self.entityTrackingDelegate?.entityTrackingAPISuccess(inputEntityTrackingId: inputEntityTrackingId)
                }
            }
        }
    }
    
    // 2 - GET request to get entity from the entity tracking Id
    func httpGetEntities(entityTrackingId: String?) {
        guard let entityTrackingId = entityTrackingId else {
            // CAUTION: TODO: Better handling. This is BAD!
            return
        }
        
        Alamofire.request(NXUtil.baseUrl.appending("/r/\(entityTrackingId)")).responseJSON { response in
            guard let json = response.result.value as? [String: Any] else {
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPIFailed(inputEntityTrackingId: entityTrackingId)
                }
                return
            }
            guard let data = json["data"] as? [String: Any] else {
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPIFailed(inputEntityTrackingId: entityTrackingId)
                }
                return
            }
            if let resultEntities = data["result"] as? [[String: Any]] {
                var extractedEntities = [EntityExtracted]()
                for resultEntity in resultEntities {
                    if let entity = EntityExtracted(json: resultEntity) {
                        extractedEntities.append(entity)
                    }
                }
                
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPISuccess(inputEntityTrackingId: entityTrackingId, extractedEntities: extractedEntities)
                }
            } else {
                DispatchQueue.main.async {
                    self.entityExtractDelegate?.entityExtractAPIFailed(inputEntityTrackingId: entityTrackingId)
                }
            }
        }
    }
    
    // 3 - POST request to get analysis tracking info
    func httpPostAnalyze(inputEntityTrackingId: String, extractedEntities: [EntityExtracted?]?) {
        
        var tracking: Tracking?
        
        let parameters: Parameters = [
            "stmt": textView.text,
            "tags": tagsTextField.text ?? ""
        ]
//        "limit": "src|most_likely"
        
        Alamofire.request(NXUtil.baseUrl.appending("/analyze"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let error = response.error {
                DispatchQueue.main.async {
                    self.trackingDelegate?.trackingReceiveFailed(error: error.localizedDescription)
                }
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                tracking = self.coreDataStack.updateOrInsertTracking(json: json, text: self.textView.text, inputEntityTrackingId: inputEntityTrackingId, extractedEntities: extractedEntities)
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
    
    // 4 - GET request to get statuspoll, resultdict, results, from tracking
    func httpGetAnalyzedData(tracking: Tracking?) {
        guard let trackingID = tracking?.trackingId else {
            // CAUTION: TODO: Better handling. This is BAD!
            return
        }
        
        Alamofire.request(NXUtil.baseUrl.appending("/r/\(trackingID)")).responseJSON { response in
            
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

extension HomeViewController: EntityTrackingDelegate {
    func entityTrackingAPISuccess(inputEntityTrackingId: String?) {
        httpGetEntities(entityTrackingId: inputEntityTrackingId)
    }
    
    func entityTrackingAPIFailed(error: String) {
        debugPrint("EntityTracking error: \(error)")
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension HomeViewController: EntityExtractDelegate {
    func entityExtractAPISuccess(inputEntityTrackingId: String?, extractedEntities: [EntityExtracted]) {
        if let inputEntityTrackingId = inputEntityTrackingId {
            // ToDo: Don't assume uniqueness b/w user input tags and extracted entities
            let uniqueEntities = extractedEntities.unique
            if (self.tagsTextField.text?.isEmpty)! {
                self.tagsTextField.text = uniqueEntities[0].name
                for entity in uniqueEntities {
                    if entity == uniqueEntities[0] {
                        continue
                    }
                    self.tagsTextField.text?.append(", \(entity.name ?? "")")
                }
            } else {
                for entity in uniqueEntities {
                    self.tagsTextField.text?.append(", \(entity.name ?? "")")
                }
            }
            
            httpPostAnalyze(inputEntityTrackingId: inputEntityTrackingId, extractedEntities: extractedEntities)
        }
    }
    
    func entityExtractAPIFailed(inputEntityTrackingId: String?) {
        if let inputEntityTrackingId = inputEntityTrackingId {
            httpPostAnalyze(inputEntityTrackingId: inputEntityTrackingId, extractedEntities: nil)
        }
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
        
        view.makeToast("A report is ready for you!", duration: 2.0, position: .center)
        
        if #available(iOS 10.0, *) {
            
            //            center.getNotificationSettings { (settings) in
            //                if settings.authorizationStatus != .authorized {
            //                    // Notifications not allowed
            //                }
            //            }
            
            let localNotif = UNMutableNotificationContent()
            localNotif.title = NSString.localizedUserNotificationString(forKey: "NewsXplore:", arguments: nil)
            localNotif.body = NSString.localizedUserNotificationString(forKey: "A report is ready for you!", arguments: nil)
            localNotif.sound = UNNotificationSound.default()
            localNotif.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
            localNotif.categoryIdentifier = "edu.missouri.nx"
            // Deliver the notification instantly
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2, repeats: false)
            let request = UNNotificationRequest.init(identifier: "TwoSec", content: localNotif, trigger: trigger)
            
            // Schedule the notification.
            let center = UNUserNotificationCenter.current()
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

