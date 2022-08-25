//
//  ViewController.swift
//  begateway.example
//
//  Created by admin on 29.10.2021.
//

import UIKit

import PassKit
import begateway

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    func processPayment(isActive: Bool) {
    }
    
    func processPaymentSuccess() {
        self.showSuccessAlert()
    }
    
    func outError(error: String) {
        self.showFailureAlert(error: error)
    }
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var currencyTextField: UITextField!
    
    @IBOutlet weak var saveCardSwitch: UISwitch!
    @IBOutlet weak var smsSwcureSwitch: UISwitch!
    @IBOutlet weak var cardCvvSwitch: UISwitch!
    @IBOutlet weak var cardExpDateSwitch: UISwitch!
    @IBOutlet weak var cardHolderSwitch: UISwitch!
    @IBOutlet weak var cardNumberSwitch: UISwitch!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var textColorView: UIView!
    
    @IBOutlet weak var tokenTextView: UITextView!
    @IBOutlet weak var payByTokenButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var appleButton: UIButton!
    
    var textColor: UIColor?
    var backgroundColor: UIColor?
    var currentColorView: UIView?
    
    var currentPaymentToken: String?
    var card: BeGatewayRequestCard?
    
    var applepaybutton = PKPaymentButton(paymentButtonType: .inStore, paymentButtonStyle: .whiteOutline)
    var screenWidth = UIScreen.main.bounds.width
    var spacing = 15
    
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.regeneratePubKey()
        self.setupApplePayButton()
    }
    
    private func regeneratePubKey() {
        let options = BeGateway.instance.options ?? BeGatewayOptions(clientPubKey: "")
        
        options.clientPubKey = ""
        options.isToogleSaveCard = !self.saveCardSwitch.isOn
        options.isToogleCardNumber = !self.cardNumberSwitch.isOn
        options.isToogleCardHolderName = !self.cardHolderSwitch.isOn
        options.isToogleExpiryDate = !self.cardExpDateSwitch.isOn
        options.isToogleCVC = !self.cardCvvSwitch.isOn
        
        let _ = BeGateway.instance.setup(with: options)
        
        self.changePubKey(is3DSecure: self.smsSwcureSwitch.isOn)
    }
    
    private func setupApplePayButton() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.applepaybutton = PKPaymentButton(paymentButtonType: .inStore, paymentButtonStyle: .black)
            } else {
                self.applepaybutton = PKPaymentButton(paymentButtonType: .inStore, paymentButtonStyle: .whiteOutline)
            }
        }
        applepaybutton.frame = CGRect.init(x: 15, y: Int(valueTextField.frame.height) + 95, width: Int(screenWidth) - (spacing * 2), height: 34)
        scrollView.addSubview(applepaybutton)
        applepaybutton.addTarget(self, action: #selector(applePayAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        
        //        default init
        self.valueTextField.text = String(100)
        
        self.currencyTextField.text = "USD"
        self.smsSwcureSwitch.isOn = false
        self.payByTokenButton.isHidden = true
        
        self.tokenTextView.layer.cornerRadius = 5.0
        self.tokenTextView.layer.borderWidth = 1
        self.tokenTextView.layer.borderColor = UIColor.systemBlue.cgColor
        //    self.appleButton.layer.cornerRadius = 5.0
        
        
        self.backgroundColorView.layer.cornerRadius = 5.0
        self.backgroundColorView.layer.borderWidth = 1
        self.backgroundColorView.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.textColorView.layer.cornerRadius = 5.0
        self.textColorView.layer.borderWidth = 1
        self.textColorView.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.valueTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.currencyTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        //        for test photo
        BeGateway.instance.options?.onDetachFromCamera = {onSelect in
            print("Open camera ........")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                onSelect?(
                    BeGatewayRequestCard(
                        number: "2201382000000013",
                        verificationValue: "123",
                        expMonth: "02",
                        expYear: "25",
                        holder: "Ivan Ivanov",
                        cardToken: nil
                    )
                )
            }
        }
        
        self.titleTextField.delegate = self
        self.tokenTextView.delegate = self
        self.valueTextField.delegate = self
        self.currencyTextField.delegate = self
        
    }
    
    private func showSuccessAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let alert = UIAlertController(title: "Success from SDK", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default))
            if #available(iOS 13.0, *) {
                if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(alert, animated: true, completion: nil)
                }
            } else {
                alert.show()
            }
        }
    }
    
    private func showFailureAlert(error : String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let alert = UIAlertController(title: "Failure from SDK", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default))
            if #available(iOS 13.0, *) {
                if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(alert, animated: true, completion: nil)
                }
            } else {
                alert.show()
            }
        }
        
    }
    
    
    // MARK:: UITextField Delegates
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.titleTextField {
            BeGateway.instance.options?.title = textField.text
        }
        if textField == self.currencyTextField || textField == self.valueTextField {
            self.dropToken()
        }
    }
    
    @IBAction func touchSelectBackgroundColor(_ sender: Any) {
        BeGateway.instance.options?.backgroundColor = BeGateway.instance.options?.backgroundColor == UIColor.blue ? UIColor.white: UIColor.blue
        
        self.backgroundColorView.backgroundColor = BeGateway.instance.options?.backgroundColor
    }
    
    @IBAction func touchSelectTextColor(_ sender: Any) {
        BeGateway.instance.options?.textColor = BeGateway.instance.options?.textColor == UIColor.red ? UIColor.white : UIColor.red
        self.textColorView.backgroundColor = BeGateway.instance.options?.textColor
    }
    
    @IBAction func payTouch(_ sender: Any) {
        self.testPayForm()
    }
    
    @IBAction func touchGetToken(_ sender: Any) {
        self.regeneratePubKey()
        BeGateway.instance.getToken(request: BeGatewayRequest(
            amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
            currency: self.currencyTextField.text ?? "USD",
            requestDescription: "Test request",
            trackingID: "1000000-1"
            
        ), completionHandler: {token in
            self.tokenTextView.text = token
            self.payByTokenButton.isHidden = false
        }, failureHandler:{error in
            print(error)
        })
    }
    
    @objc func applePayAction() {
        let options = BeGateway.instance.options ?? BeGatewayOptions(clientPubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw8XoKldxIqeAcP59p5oVJefQNKK8GIvWQBlnn08tA9KhK0NUe4LFvVfETXHDMKg/cmSpjTysVbOi+rOm5VQJdZU1GGVHJvkbGuuTXkZW9JBlzhmx4ikTYHhcSqtFNTgQlOSpQGI06NF7Iribapch+aLApilOlLoA9+IWQc79Q3/yYl5vV3b2Ub7O7AR5yCECOLa583uhA7NxnV+d2+f5pSKeDJRjML71LXKkS7q7Zj6ag45hzILdxMW8CElWliPKFesJZrXRHW/8E9pQ49bG3LZFkFnTyc6DDyydWB6y9jbYLS9pi5LSXAw+rvde23UnaReTRwaWbZgTL/I34IjHcwIDAQAB")
        
        setupApplePubkey()
        options.merchantID = "merchant.org.cocoapods.demo.begateway-Example"
        
        let _ = BeGateway.instance.setup(with: options)
        
        let request = BeGatewayRequest(amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
                                       currency: self.currencyTextField.text?.uppercased() ?? "USD",
                                       requestDescription: "Apple Pay test transaction",
                                       trackingID: "1000000-1",
                                       card: nil)
        
        if let token = self.tokenTextView.text, token.count >= 64 {
            BeGateway.instance.payWithAppleByToken(token: token, rootController: self) {
                self.showSuccessAlert()
                print("payment success with token")
            } failureHandler: { error in
                self.showFailureAlert(error: error)
                print("---> error \(error)")
            }
        } else {
            BeGateway.instance.payWithApplePay(requestBE: request, rootController: self) {
                self.showSuccessAlert()
                print("payment success without token")
            } failureHandler: { error in
                self.showFailureAlert(error: error)
                print("---> error \(error)")
            }
        }
        self.setupApplePubkey()
        
    }
    
    //text view/field delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        payByTokenButton.isHidden = self.tokenTextView.text.count < 64
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func dropToken() {
        self.tokenTextView.text = ""
        self.payByTokenButton.isHidden = true
    }
    
    private func setupApplePubkey() {
        BeGateway.instance.options?.clientPubKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw8XoKldxIqeAcP59p5oVJefQNKK8GIvWQBlnn08tA9KhK0NUe4LFvVfETXHDMKg/cmSpjTysVbOi+rOm5VQJdZU1GGVHJvkbGuuTXkZW9JBlzhmx4ikTYHhcSqtFNTgQlOSpQGI06NF7Iribapch+aLApilOlLoA9+IWQc79Q3/yYl5vV3b2Ub7O7AR5yCECOLa583uhA7NxnV+d2+f5pSKeDJRjML71LXKkS7q7Zj6ag45hzILdxMW8CElWliPKFesJZrXRHW/8E9pQ49bG3LZFkFnTyc6DDyydWB6y9jbYLS9pi5LSXAw+rvde23UnaReTRwaWbZgTL/I34IjHcwIDAQAB"
    }
    
    @IBAction func touchPayWithToken(_ sender: Any) {
        self.regeneratePubKey()
        BeGateway.instance.getStatus(token: self.tokenTextView.text, completionHandler: { token in
            
            if let language = token?.checkout?.settings?.language {
                BeGateway.instance.options?.language = language
            }
            
            let toggle = token?.checkout?.settings?.saveCardToggle?.customerContract ?? false
            BeGateway.instance.options?.isToogleSaveCard = !toggle
        
            if let currentCard = self.card {
                BeGateway.instance.payByToken(
                    token: self.tokenTextView.text,
                    card : currentCard , rootController: self,
                    completionHandler: {
                        card in
                        print(card)
                        self.showSuccessAlert()
                        self.dropToken()
                    }, failureHandler: {error in
                        self.showFailureAlert(error: error)
                        self.dropToken()
                        print(error)
                    })
            }
            
        }) { error in
            self.showFailureAlert(error: error)
            print(error)
        }
    }
    
    @IBAction func touchRemoveAll(_ sender: Any) {
        BeGateway.instance.removeAllCards()
    }
    
    @IBAction func saveCardChanged(_ sender: Any) {
        self.dropToken()
        BeGateway.instance.options?.isToogleSaveCard = !self.saveCardSwitch.isOn
    }
    
    @IBAction func cardNumberChanged(_ sender: Any) {
        dropToken()
        BeGateway.instance.options?.isToogleCardNumber = !self.cardNumberSwitch.isOn
    }
    
    @IBAction func cardHolderCHanged(_ sender: Any) {
        dropToken()
        BeGateway.instance.options?.isToogleCardHolderName = !self.cardHolderSwitch.isOn
    }
    
    @IBAction func cardExpDateChanged(_ sender: Any) {
        dropToken()
        BeGateway.instance.options?.isToogleExpiryDate = !self.cardExpDateSwitch.isOn
    }
    
    @IBAction func cardCvvChanged(_ sender: Any) {
        dropToken()
        BeGateway.instance.options?.isToogleCVC = !self.cardCvvSwitch.isOn
    }
    
    @IBAction func smsChanged(_ sender: Any) {
        self.dropToken()
        self.changePubKey(is3DSecure: self.smsSwcureSwitch.isOn)
    }
    
    func changePubKey(is3DSecure: Bool) {
        if is3DSecure {
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxiq93sRjfWUiS/OE2ZPfMSAeRZFGpVVetqkwQveG0reIiGnCl4RPJGMH1ng3y3ekhTxO1Ze+ln3sCK0LJ/MPrR1lzKN9QbY4F3l/gmj/XLUseOPFtayxvQaC+lrYcnZbTFhqxB6I1MSF/3oeTqbjJvUE9KEDmGsZ57y0+ivbRo9QJs63zoKaUDpQSKexibSMu07nm78DOORvd0AJa/b5ZF+6zWFolVBmzuIgGDpCWG+Gt4+LSw9yiH0/43gieFr2rDKbb7e7JQpnyGEDT+IRP9uKCmlRoV1kHcVyHoNbC0Q9kV8jPW2K5rKuj80auV3I2dgjJEsvxMuHQOr4aoMAgQIDAQAB"
            
            self.card = BeGatewayRequestCard(
                number: "2201382000000013",
                verificationValue: "123",
                expMonth: "02",
                expYear: "25",
                holder: "Ivan Ivanov",
                cardToken: nil
            )
        } else {
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvextn45qf3NiNzqBYXMvcaSFlgoYE/LDuDDHtNNM4iWJP7BvjBkPcZu9zAfo5IiMxl660r+1E4PYWwr0iKSQ8+7C/WcSYwP8WlQVZH+2KtPmJgkPcBovz3/aZrQpj6krcKLklihg3Vs++TtXAbpCCbhIq0DJ3T+khttBqTGD+2x2vOC68xPgMwvnwQinfhaHEQNbtEcWWXPw9LYuOTuCwKlqijAEds4LgKSisubqrkRw/HbAKVfa659l5DJ8QuXctjp3Ic+7P2TC+d+rcfylxKw9c61ykHS1ggI/N+/KmEDVJv1wHvdy7dnT0D/PhArnCB37ZDAYErv/NMADz2/LuQIDAQAB"
            
//            self.card = BeGatewayRequestCard( //Pay by card token
//                number: nil,
//                verificationValue: nil,
//                expMonth: nil,
//                expYear: nil,
//                holder: nil,
//                cardToken: "YourCardToken"
//            )
            
            self.card = BeGatewayRequestCard(
                number: "4200000000000000",
                verificationValue: "123",
                expMonth: "02",
                expYear: "23",
                holder: "WRR",
                cardToken: nil
            )
        }
    }
    
    func testPayForm() {
        self.regeneratePubKey()
        BeGateway.instance.pay(
            rootController: self,
            request: BeGatewayRequest(
                amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
                currency: self.currencyTextField.text ?? "USD",
                requestDescription: "Test request",
                trackingID: "1000000-1",
                card: self.card
            ),
            completionHandler: {
                card in
                self.showSuccessAlert()
                print(card)
            }, failureHandler: {error in
                self.showFailureAlert(error: error)
                print(error)
            })
    }
    
}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}

extension ViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
