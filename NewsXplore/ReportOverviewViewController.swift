//
//  ReportOverviewViewController.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/14/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import UIKit

class ReportOverviewViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ReportOverviewViewController: EntityWebDelegate {
    func entityWebReceiveSuccess(entityHtmlContent: String) {
        let body = NXUtil.htmlHead + entityHtmlContent + NXUtil.htmlEnd
        self.webView.loadHTMLString(body, baseURL: nil)
    }
    
    func entityWebRecieveFailed(error: String) {
        debugPrint("EntityWeb Error: \(error)")
    }
}

extension ReportOverviewViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}
