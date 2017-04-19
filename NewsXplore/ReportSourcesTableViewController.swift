//
//  ReportOverviewTableViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/14/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportSourcesTableViewController: UITableViewController {

    var resultsDict: [ServerResultDictionary]? = [ServerResultDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return resultsDict?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportSourceTableViewCell", for: indexPath) as! ReportSourceTableViewCell

        // Configure the cell...
        
        cell.sourceTitle.text = resultsDict?[indexPath.row].dataSource
        cell.sourceDetail.text = resultsDict?[indexPath.row].srcUrl
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let srcUrl = resultsDict?[indexPath.row].srcUrl {
            UIApplication.shared.open(URL(string: srcUrl)!, options: [:], completionHandler: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
