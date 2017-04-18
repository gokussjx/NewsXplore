//
//  ReportListTableViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 3/23/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive = false
    var filtered = [Tracking]()
    var trackingArray = [Tracking]()
    var currentTracking: Tracking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trackingArray = CoreDataStack.sharedInstance.fetchTrackings()
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
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
        if searchActive {
            return filtered.count
        }
        return trackingArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsListTableViewCell", for: indexPath) as! ReportsListTableViewCell
        
        // Configure the cell...
        let trackingArr: [Tracking]
        if searchActive {
            trackingArr = filtered
        } else {
            trackingArr = trackingArray
        }
        
        let text = trackingArr[indexPath.row].text
        cell.titleLabel.text = (text?.isEmpty)! ? "-" : text
        cell.dateLabel.text = NXUtil.dateToReadableString(date: trackingArr[indexPath.row].postDate as Date?)
        cell.statusLabel.text = trackingArr[indexPath.row].analysisState
        
        return cell
        
//
//            let text = trackingArray[indexPath.row].text
//            cell.titleLabel.text = (text?.isEmpty)! ? "-" : text
//            cell.dateLabel.text = NXUtil.dateToReadableString(date: trackingArray[indexPath.row].postDate as Date?)
//            cell.statusLabel.text = trackingArray[indexPath.row].analysisState
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentTracking = trackingArray[indexPath.row]
        
        if currentTracking?.analysisState != "Ready" {
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
            if let destReportDetailVC = segue.destination as? ReportDetailViewController {
                destReportDetailVC.tracking = currentTracking
            }
        }
     }

}

extension ReportListTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = trackingArray.filter({ tracking -> Bool in
            let tmp = tracking.text
            if let _ = tmp?.range(of: searchText, options: .caseInsensitive) {
                return true
            }
            return false
        })
        
        if filtered.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        
        self.tableView.reloadData()
    }
}
