//
//  OAuthViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/4/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    //MARK:- UI objects
    @IBOutlet weak var oauthNavItem: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        loadPage()
    }

}


//MARK:- set up UI
extension OAuthViewController {
    private func setupNavigationBar() {        oauthNavItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(OAuthViewController.closeButtonClick))
    }
    
    private func loadPage() {
        let urlString: String = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&redirect_uri=\(Redirect_URL)"
        guard let url: NSURL = NSURL(string: urlString) else {
            return
        }
        webView.loadRequest(NSURLRequest(URL: url))
    }
}

//MARK:- event listeners
extension OAuthViewController {
    @objc private func closeButtonClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- web view delegate
extension OAuthViewController: UIWebViewDelegate{
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    
    //method called for every request
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.URL else {
            return true
        }
        
        let urlString = url.absoluteString
        
        guard urlString.containsString("code=") else {
            return true
        }
        
        let code = urlString.componentsSeparatedByString("code=").last!
        
        UserAccountViewModel.shareInstance.loadAccessToken(code) { (isSuccess) in
            if isSuccess {
                print(UserAccountViewModel.shareInstance.account)
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    //show welcome page
                    UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
                })

            }
        }
        
        return false
    }
}
