//
//  BGWebView.swift
//  begateway
//
//  Created by FEDAR TRUKHAN on 9/9/19.
//

import Foundation
import UIKit
import WebKit

protocol BGWebViewControllerDelegate: class {
    func dismissWebViewTouch()
    func threeDSecDone()
}

class BGWebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let dissmissButton = UIButton()
    weak var delegate: BGWebViewControllerDelegate?
    var colors: BGCardViewColorsSettings = BGCardViewColorsSettings.standart {
        didSet {
            DispatchQueue.main.async {
                self.updateWithColorSettings()
            }
        }
    }
    
    var callbackURL: String = ""
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.lowercased().contains(callbackURL.lowercased()) {
                decisionHandler(.cancel)
                self.delegate?.threeDSecDone()
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    func load3DSec(url: URL, callbackURL: String) {
        self.callbackURL = callbackURL
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.webView.navigationDelegate = self
            self.setupViews()
            self.arrangeSubviews()
            self.disableAutoresizingMask()
            self.makeConstraints()
            self.makeActions()
            self.updateWithColorSettings()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        dissmissButton.setTitle("Cancel", for: .normal)
    }
    private func arrangeSubviews() {
        view.addSubview(webView)
        view.addSubview(dissmissButton)
    }
    private func disableAutoresizingMask() {
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func makeConstraints() {
        var dismissButtonTopConstraint = dissmissButton.topAnchor.constraint(equalTo: view.topAnchor)
        if #available(iOS 11.0, *) {
            dismissButtonTopConstraint = dissmissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        }
        NSLayoutConstraint.activate([
            dismissButtonTopConstraint,
            dissmissButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 70)
            ])
        var mainWebTopConstraint = webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        var mainWebBottomConstraint = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            mainWebTopConstraint = webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
            mainWebBottomConstraint = webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
        NSLayoutConstraint.activate([
            mainWebTopConstraint,
            mainWebBottomConstraint,
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    private func makeActions() {
        dissmissButton.addTarget(self, action: #selector(BGWebViewController.dismissTouch), for: .touchUpInside)
    }
    @objc private func dismissTouch() {
        delegate?.dismissWebViewTouch()
    }
    private func updateWithColorSettings() {
        dissmissButton.setTitleColor(colors.cancelTextColor, for: .normal)
    }
}
