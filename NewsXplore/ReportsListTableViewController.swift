//
//  ReportListTableViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 3/23/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportListTableViewController: UITableViewController {
    
    var trackingArray = [Tracking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        trackingArray = CoreDataStack.sharedInstance.fetchTrackings()
        
        _ = 5
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trackingArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsListTableViewCell", for: indexPath) as! ReportsListTableViewCell
        
        // Configure the cell...
        let text = trackingArray[indexPath.row].text
        cell.titleLabel.text = (text?.isEmpty)! ? "-" : text
        cell.dateLabel.text = NXUtil.dateToReadableString(date: trackingArray[indexPath.row].postDate as Date?)
        cell.statusLabel.text = trackingArray[indexPath.row].analysisState
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tracking = trackingArray[indexPath.row]
        
        if tracking.analysisState != "Ready" {
            let alert = UIAlertController(title: "In Progress", message: "This request is still being processed. Please try again when the status is \"Ready\"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showReportDetails", sender: self)
        }
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "showReportDetails" {
            
        }
     }
 
    
}
