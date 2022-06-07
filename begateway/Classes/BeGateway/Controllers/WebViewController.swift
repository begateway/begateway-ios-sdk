//
//  WebViewController.swift
//  begateway.framework
//
//  Created by admin on 02.11.2021.
//

import UIKit
import  WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var mainWebView: WKWebView!
    
    var url: String?
    var resultUrl: String?
    var onBack: (() -> Void)?
    var onSuccess: (() -> Void)?
    
    var isSuccessed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainWebView.navigationDelegate = self

        // Do any additional setup after loading the view.
        if let link = URL(string:self.url ?? "") {
            //init
            
            self.mainWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            
            let request = URLRequest(url: link)
            self.mainWebView.load(request)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !self.isSuccessed {
            self.onBack?()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            // Whenever URL changes, it can be accessed via WKWebView instance
            
            if let url = mainWebView.url {
                print("Current url is: \(url.absoluteURL)")
                
                if let returnUrl = self.resultUrl {
                    if url.absoluteString.contains(returnUrl) {
                        self.isSuccessed = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.onSuccess?()
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == .linkActivated  {
//            if let url = navigationAction.request.url,
//               let host = url.host, !host.hasPrefix("www.google.com"),
//               UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//                print(url)
//                print("Redirected to browser. No need to open it locally")
//                decisionHandler(.cancel)
//            } else {
//                print("Open it locally")
//                decisionHandler(.allow)
//            }
//        } else {
//            print("not a user click")
//            decisionHandler(.allow)
//        }
        
        decisionHandler(.allow)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
