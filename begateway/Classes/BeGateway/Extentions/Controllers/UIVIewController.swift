//
//  UIVIewController.swift
//  camping-car
//
//  Created by admin on 11.07.2018.
//  Copyright © 2018 admin. All rights reserved.
//
import UIKit

extension UIViewController {
    class func displaySpinner(_ onView : UIView, rect: CGRect? = nil) -> UIView {
        let spinnerView = UIView.init(frame: rect == nil ? onView.bounds : rect!)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init()
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    class func loadFromNib(_ bundle: Bundle? = nil) -> Self {
        func instanceFromNib<T: UIViewController>(_ bundle: Bundle? = nil) -> T {
            return T(nibName: String(describing: self), bundle: bundle)
        }
        
        return instanceFromNib(bundle)
    }
    
    class func loadFromStoryboard(storyboardName: String, withIdentifier: String? = nil,  bundle: Bundle? = nil) -> Self {
        func loadFromStoryboard<T: UIViewController>(storyboardName: String, withIdentifier: String,  bundle: Bundle? = nil) -> T {
            return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: withIdentifier) as! T
        }
        
        let identifier = withIdentifier == nil ? String(describing: self) : withIdentifier!
        
        return loadFromStoryboard(storyboardName: storyboardName, withIdentifier: identifier, bundle: bundle)
    }
}
