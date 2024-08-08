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
    
//    class func createAlertInfo(_ title: String?, message: String?)
//    {
//        let alert = UIAlertController(title: NSLocalizedString(DataHelper.getValue(value: title, defaultValue: ""), comment: ""), message: NSLocalizedString(DataHelper.getValue(value: message, defaultValue: ""), comment: ""), preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: {(alertAction) in
//            //
//        }))
//        
//        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    
//    class func createAlertError(message: String?)
//    {
//        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(DataHelper.getValue(value: message, defaultValue: "Oops!"), comment: ""), preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: {(alertAction) in
//            //
//        }))
//        
//        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    
//    class func createAlertSuccess(message: String?, completion: (() -> Void)?)
//    {
//        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString(DataHelper.getValue(value: message, defaultValue: "Success"), comment: ""), preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertAction.Style.default, handler: {(alertAction) in
//            completion?()
//        }))
//        
//        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    
//    class func createAlert(_ title: String, message: String) {
//        let alert = UIAlertController(title: title, message: NSLocalizedString(DataHelper.getValue(value: message, defaultValue: ""), comment: ""), preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    
//    func outAlert(title: String?, message: String?, compliteHandler: (() -> Void)? = nil) {
//        let alertController = UIAlertController(title: NSLocalizedString(DataHelper.getValue(value: title, defaultValue: ""), comment: ""), message: NSLocalizedString(DataHelper.getValue(value: message, defaultValue: ""), comment: ""), preferredStyle: .alert)
//        
//        alertController.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default) { (action:UIAlertAction) in
//            compliteHandler?()
//        })
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
//    func outAlertError(message: String?, compliteHandler: (() -> Void)? = nil) {
//        self.outAlert(title: NSLocalizedString("Error", comment: ""), message: message != nil && !message!.isEmpty ? NSLocalizedString(DataHelper.getValue(value: message, defaultValue: "Oops!"), comment: "") : NSLocalizedString("Sorry, something went wrong", comment: ""), compliteHandler: compliteHandler)
//    }
    
//    func outAlertOops(message: String?, compliteHandler: (() -> Void)? = nil) {
//        self.outAlert(title: NSLocalizedString("Oops!", comment: ""), message: message != nil && !message!.isEmpty ? NSLocalizedString(message!, comment: "") : NSLocalizedString("Sorry, something went wrong", comment: ""), compliteHandler: compliteHandler)
//    }
    
//    func outAlertSuccess(message: String?, compliteHandler: (() -> Void)?) {
//        self.outAlert(title: NSLocalizedString("Success", comment: ""), message: DataHelper.getLocalizeValue(value: message), compliteHandler: compliteHandler)
//    }
    
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

////MARK: - Observers
//extension UIViewController {
//    
//    func addObserverForNotification(_ notificationName: Notification.Name, actionBlock: @escaping (Notification) -> Void) {
//        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main, using: actionBlock)
//    }
//    
//    func removeObserver(_ observer: AnyObject, notificationName: Notification.Name) {
//        NotificationCenter.default.removeObserver(observer, name: notificationName, object: nil)
//    }
//}

////MARK: - Keyboard handling
//extension UIViewController {
//
//    typealias KeyboardHeightClosure = (CGFloat) -> ()
//
//    func addKeyboardChangeFrameObserver(willShow willShowClosure: KeyboardHeightClosure?,
//                                        willHide willHideClosure: KeyboardHeightClosure?) {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame,
//                                               object: nil, queue: OperationQueue.main, using: { [weak self](notification) in
//                                                if let userInfo = notification.userInfo,
//                                                    let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
//                                                    let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
//                                                    let c = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
//                                                    let kFrame = self?.view.convert(frame, from: nil),
//                                                    let kBounds = self?.view.bounds {
//
//                                                    let animationType = UIViewAnimationOptions(rawValue: c)
//                                                    let kHeight = kFrame.size.height
//                                                    UIView.animate(withDuration: duration, delay: 0, options: animationType, animations: {
//                                                        if kBounds.intersects(kFrame) { // keyboard will be shown
//                                                            willShowClosure?(kHeight)
//                                                        } else { // keyboard will be hidden
//                                                            willHideClosure?(kHeight)
//                                                        }
//                                                    }, completion: nil)
//                                                } else {
//                                                    print("Invalid conditions for UIKeyboardWillChangeFrameNotification")
//                                                }
//        })
//    }
//
//    func removeKeyboardObserver() {
//        removeObserver(self, notificationName: NSNotification.Name.UIKeyboardWillChangeFrame)
//    }
//}
