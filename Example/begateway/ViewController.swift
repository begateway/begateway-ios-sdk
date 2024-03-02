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
        self.cancelButtonPressHandler()
    }
     private func cancelButtonPressHandler() {
            let options = BeGateway.instance.options ?? BeGatewayOptions(clientPubKey: "")
            options.cancelButtonHandler = {
                // Ваша логика здесь
                 print("The \"Cancel\" button was pressed")
            }
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
        if #available(iOS 13.0, *) {
            BeGateway.instance.options?.backgroundColor = BeGateway.instance.options?.backgroundColor == UIColor.blue ? UIColor.systemBackground: UIColor.blue
        } else {
            BeGateway.instance.options?.backgroundColor = BeGateway.instance.options?.backgroundColor == UIColor.blue ? UIColor.white : UIColor.blue
        }

        self.backgroundColorView.backgroundColor = BeGateway.instance.options?.backgroundColor
    }

    @IBAction func touchSelectTextColor(_ sender: Any) {
        BeGateway.instance.options?.textColor = BeGateway.instance.options?.textColor == UIColor.red ? UIColor.white : UIColor.red
        self.textColorView.backgroundColor = BeGateway.instance.options?.textColor
    }

    @IBAction func payTouch(_ sender: Any) {
        self.touchGetToken("")
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
        // Shop 99
        let options = BeGateway.instance.options ?? BeGatewayOptions(clientPubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmv2F2L5YQfdjAXCPQ7p1FB9FGq00NSCaAFq9cyRlOW8jEo9JZbOaCZ56Eg0kip3fsZNYEXiAWmtKPY1EYk36wsK2hGivDQzMQG0cLqT0WALrBfTboWeYUIj7dJytcJvrw1MQzvjlFppiDQqnA2jlt1ZGnCdgmTWhpOG1Sn+Q+wiLmtdIO1frx9bLjJLMjIEO+0PAeEqwd02ZRUkcTzWZeJhlapdI7OvDUsbuqAN107zI5myI7dW6f4NwcHFQYsLIpw6X50SnMV2HaAe5g1FGYgj8cynzmB5vgI6ogSBeXBwXtVWsyV+sF0y4yFcxtNN7aYNfQKYJ7Yt11LC2/V6okwIDAQAB")

        setupApplePubkey()
        options.merchantID = "merchant.com.begateway.sdk.demo"

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
        // shop 99
        BeGateway.instance.options?.clientPubKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0M//IG/wkyiIv7gUhPS8QScvz6AK0z1l4K1RspuAznVyeSil0WO0ZdhihvRKNw2QYf/92cvBMDCjntqsvx+BERzCqIl/g5MKjI7k2DPG7rtte6W7OkWv1x728pSxkV92oAkKjvqN5Obtmeb69A1m+C2HSYATV1e4smPwc1Fxf0NOoKxM4Ffi+49WjRoUdy3AYoxGbpRnKuI9Lh82116wiFTcM0oMubRLpV4FqnzBYHJqCvICFtm1WznqL3lKzJgF4yK8Gx+1JmCTU3P/58GBhwTyRTHouGZjpNY7tKUhNxlHz/imvKk4vSwgGqtqxNEn044sbgh1bQcuw5cc1/DNGwIDAQAB"
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
            // shop 198
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAors6xudtD30e4eCQNXwgRi7PsjNTfC7srjx1ej9HVnr1sZqsKlM0hUPlkvHGFu5IYHcxBisATE3PXOKLPu9YSiY7ffzg2FIEJbPKs8Jun15O+f5EEjt3RKtrLOz5Nb8r2j92RonWHwXhWTMlFT6SIvElkmd15GPbUiHAZ4firgLuswuzOgmz6v5i4FVWgbh2+E8Am+6+ptbZdcdu6uPKlb7jOY48H57cjDPrP2sycCVCfWQBZj7h6g9c89F8M0sUHCGWE6Xh79xclz3oHz/e/+H3Aj9HjqIE29WsLrJYrb30QLrnpQ0/lUnVbc8nfPfwoq5cESEV6UoP1hbtiBSoFQIDAQAB"

            self.card = BeGatewayRequestCard(
                number: "4012000000001097",
                verificationValue: "123",
                expMonth: "02",
                expYear: "30",
                holder: "JOHN DOE",
                cardToken: nil
            )
        } else {
            // shop 26129
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0P67WdeRQcrl6K59pZ0g5Gr0wGc24NC+H+YK2AJgwTfMNOBZEw00TQqjR7R+rH9JtRvxRdLgqNGZSEpTcXE5bZbzuBHEua+3MFU/8OX+p3s2BjQ4HXxLLmtkLIfe9y2IrTzR18fYvxjGRwBOjcsMHS1J0r+UYCzRSWxY4ogIVHxDdzzFaacFJhKYOx+QQLzRHgDcGOh1f6tAHgSHa80iTxdW1rCnFd3/gssOFt5N6BayhLKgolZvoKKKtGQeIzVYw7Gg+aEKcJVFaJEsI+a8W23iqRJUrgOi6jwfS8S4tSNfd3eJBV0XengVF+yNhr0jwCKzzRH+oGDF/fHNSHOdYwIDAQAB"

//            self.card = BeGatewayRequestCard( //Pay by card token
//                number: nil,
//                verificationValue: nil,
//                expMonth: nil,
//                expYear: nil,
//                holder: nil,
//                cardToken: "YourCardToken"
//            )

            self.card = BeGatewayRequestCard(
                number: "4200 0000 0000 0000",
                verificationValue: "123",
                expMonth: "02",
                expYear: "30",
                holder: "MR DOE",
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
