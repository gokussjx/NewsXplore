//
//  ReportDetailViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/14/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit
import Alamofire

protocol EntityWebDelegate: class {
    func entityWebReceiveSuccess(entityHtmlContent: String)
    func entityWebRecieveFailed(error: String)
}

class ReportDetailViewController: UIViewController {
    
    @IBOutlet weak var overviewContainer: UIView!
    @IBOutlet weak var sourcesContainer: UIView!
    
    var tracking: Tracking? = nil
    let baseUrl = "http://localhost:8084"
    var entityHtmlContent = "<br /><h2>Oops! Something went wrong!</h2>"
    
    weak var delegate: EntityWebDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Report Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share-7.png"), style: .plain, target: self, action: nil)
        
        if let inputEntityTrackingId = tracking?.inputEntityTrackingId {
            getEntityOverview(inputEntityTrackingId: inputEntityTrackingId)
        }
    }
    
    func getEntityOverview(inputEntityTrackingId: String) {
        
        Alamofire.request(baseUrl.appending("/r/\(inputEntityTrackingId)/gnlp::as_overview")).responseString {response in
            
            if let error = response.error {
                DispatchQueue.main.async {
                    self.delegate?.entityWebRecieveFailed(error: error.localizedDescription)
                }
                return
            }
            
            if let entityHtmlContent = response.result.value {
                DispatchQueue.main.async {
                    self.delegate?.entityWebReceiveSuccess(entityHtmlContent: entityHtmlContent)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.overviewContainer.alpha = 1
                self.sourcesContainer.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.overviewContainer.alpha = 0
                self.sourcesContainer.alpha = 1
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let reportOverviewWebVC = segue.destination as? ReportOverviewViewController {
            self.delegate = reportOverviewWebVC
            
        } else if let reportSourcesTableVC = segue.destination as? ReportSourcesTableViewController {
            reportSourcesTableVC.resultsDict = tracking?.statusPoll?.resultsDictionaryArray
        }
    }
    
}
