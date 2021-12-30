//
//  ViewController.swift
//  begateway.example
//
//  Created by admin on 29.10.2021.
//

import UIKit
import begateway
//import FlexColorPicker

class ViewController: UIViewController {
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
    
    var textColor: UIColor?
    var backgroundColor: UIColor?
    var currentColorView: UIView?
    
    var currentPaymentToken: String?
    var card: BeGatewayRequestCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        default init
        self.valueTextField.text = String(100)
        self.currencyTextField.text = "USD"
        self.smsSwcureSwitch.isOn = false
        self.payByTokenButton.isHidden = true
        
        self.tokenTextView.layer.cornerRadius = 5.0
        self.tokenTextView.layer.borderWidth = 1
        self.tokenTextView.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.backgroundColorView.layer.cornerRadius = 5.0
        self.backgroundColorView.layer.borderWidth = 1
        self.backgroundColorView.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.textColorView.layer.cornerRadius = 5.0
        self.textColorView.layer.borderWidth = 1
        self.textColorView.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        _ = BeGateway.instance.setup(with: BeGatewayOptions(clientPubKey: ""))
        self.changePubKey(is3DSecure: self.smsSwcureSwitch.isOn)
        
//        for test photo
        BeGateway.instance.options?.onDetachFromCamera = {onSelect in
            print("Open camera ........")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                onSelect?(
                    BeGatewayRequestCard(
                        number: "2201382000000013",
                        verificationValue: "123",
                        expMonth: "02",
                        expYear: "23",
                        holder: "WRR"
                    )
                )
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.testPayForm()
//        }
    }
    
    // MARK:: UITextField Delegates
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.titleTextField {
            BeGateway.instance.options?.title = textField.text
        }
    }
    
    @IBAction func touchSelectBackgroundColor(_ sender: Any) {
//        self.currentColorView = self.backgroundColorView
//
//        let colorPickerController = DefaultColorPickerViewController()
//        colorPickerController.delegate = self
//        self.present(colorPickerController, animated: true)
        
        BeGateway.instance.options?.backgroundColor = BeGateway.instance.options?.backgroundColor == UIColor.blue ? UIColor.white: UIColor.blue
        
        self.backgroundColorView.backgroundColor = BeGateway.instance.options?.backgroundColor
    }
    
    @IBAction func touchSelectTextColor(_ sender: Any) {
//        self.currentColorView = self.textColorView
//
//        let colorPickerController = DefaultColorPickerViewController()
//        colorPickerController.delegate = self
//        self.present(colorPickerController, animated: true)
        
        BeGateway.instance.options?.textColor = BeGateway.instance.options?.textColor == UIColor.red ? UIColor.white : UIColor.red
        self.textColorView.backgroundColor = BeGateway.instance.options?.textColor
    }
    
    @IBAction func payTouch(_ sender: Any) {
        self.testPayForm()
    }
    
    @IBAction func touchGetToken(_ sender: Any) {
        BeGateway.instance.getToken(request: BeGatewayRequest(
            amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
            currency: self.currencyTextField.text ?? "USD",
            requestDescription: "Test request",
            trackingID: "1000000-1"

        ), completionHandler: {token in
            print(token)
            self.tokenTextView.text = token
            self.payByTokenButton.isHidden = false
        }, failureHandler:{error in
            print(error)
        })
    }
    
    @IBAction func touchPayWithToken(_ sender: Any) {
        BeGateway.instance.payByToken(
            token: self.tokenTextView.text,
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
                print(card)
                
                self.tokenTextView.text = ""
                self.payByTokenButton.isHidden = true
                
//                let alert = UIAlertController(title: "Success", message: card.first1+"********"+card.last4, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
                
            }, failureHandler: {error in
                print(error)
            })
    }
    
    @IBAction func touchRemoveAll(_ sender: Any) {
        BeGateway.instance.removeAllCards()
    }
    
    @IBAction func saveCardChanged(_ sender: Any) {
        BeGateway.instance.options?.isToogleSaveCard = !self.saveCardSwitch.isOn
    }
    
    @IBAction func cardNumberChanged(_ sender: Any) {
        BeGateway.instance.options?.isToogleCardNumber = !self.cardNumberSwitch.isOn
    }
    
    @IBAction func cardHolderCHanged(_ sender: Any) {
        BeGateway.instance.options?.isToogleCardHolderName = !self.cardHolderSwitch.isOn
    }
    
    @IBAction func cardExpDateChanged(_ sender: Any) {
        BeGateway.instance.options?.isToogleExpiryDate = !self.cardExpDateSwitch.isOn
    }
    
    @IBAction func cardCvvChanged(_ sender: Any) {
        BeGateway.instance.options?.isToogleCVC = !self.cardCvvSwitch.isOn
    }
    
    @IBAction func smsChanged(_ sender: Any) {
        self.changePubKey(is3DSecure: self.smsSwcureSwitch.isOn)
    }
    
    func changePubKey(is3DSecure: Bool) {
        if is3DSecure {
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxiq93sRjfWUiS/OE2ZPfMSAeRZFGpVVetqkwQveG0reIiGnCl4RPJGMH1ng3y3ekhTxO1Ze+ln3sCK0LJ/MPrR1lzKN9QbY4F3l/gmj/XLUseOPFtayxvQaC+lrYcnZbTFhqxB6I1MSF/3oeTqbjJvUE9KEDmGsZ57y0+ivbRo9QJs63zoKaUDpQSKexibSMu07nm78DOORvd0AJa/b5ZF+6zWFolVBmzuIgGDpCWG+Gt4+LSw9yiH0/43gieFr2rDKbb7e7JQpnyGEDT+IRP9uKCmlRoV1kHcVyHoNbC0Q9kV8jPW2K5rKuj80auV3I2dgjJEsvxMuHQOr4aoMAgQIDAQAB"
            
            self.card = BeGatewayRequestCard(
                number: "2201382000000013",
                verificationValue: "123",
                expMonth: "02",
                expYear: "23",
                holder: "WRR"
            )
            
            //        for test 3d secure with password: "1qwezxc"
//            BeGateway.instance.request.card = BeGatewayRequestCard(
//                number: "2201382000000047",
//                verificationValue: "123",
//                expMonth: "02",
//                expYear: "2023",
//                holder: "WRR"
//            )
            
        } else {
            BeGateway.instance.options?.clientPubKey =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvextn45qf3NiNzqBYXMvcaSFlgoYE/LDuDDHtNNM4iWJP7BvjBkPcZu9zAfo5IiMxl660r+1E4PYWwr0iKSQ8+7C/WcSYwP8WlQVZH+2KtPmJgkPcBovz3/aZrQpj6krcKLklihg3Vs++TtXAbpCCbhIq0DJ3T+khttBqTGD+2x2vOC68xPgMwvnwQinfhaHEQNbtEcWWXPw9LYuOTuCwKlqijAEds4LgKSisubqrkRw/HbAKVfa659l5DJ8QuXctjp3Ic+7P2TC+d+rcfylxKw9c61ykHS1ggI/N+/KmEDVJv1wHvdy7dnT0D/PhArnCB37ZDAYErv/NMADz2/LuQIDAQAB"
            
            self.card = BeGatewayRequestCard(
                number: "4200000000000000",
                verificationValue: "123",
                expMonth: "02",
                expYear: "23",
                holder: "WRR"
            )
        }
    }
    
    func testPayForm() {
//        examples
        
//        let options = BeGateway.instance.options
        
//        options.title = "Test title for label"
//        options.titleCardNumber = "titleCardNumber test"
//        options.hintCardNumber = "hintCardNumber test"
//        options.titleExpiryDate = "titleExpiryDate"
//        options.hintExpiryDate = "hintExpiryDate"
//        options.titleCVC = "titleCVC"
//        options.hintCVC = "hintCVC"
//        options.titleCardHolderName = "titleCardHolderName"
//        options.hintCardHolderName = "hintCardHolderName"
//        options.titleToggle = "titleToggle"
//
//        options.textFont = UIFont.italicSystemFont(ofSize: 20.0)
//        options.hintFont = UIFont.italicSystemFont(ofSize: 20.0)
//        options.textColor = UIColor.red
//        options.hintColor = UIColor.orange
//        options.backgroundColor = UIColor.gray
//
//        options.colorTitle = UIColor.black
//        options.fontTitle = UIFont.systemFont(ofSize: 34.0)
//        options.fontTitleCardNumber = UIFont.systemFont(ofSize: 14.0)
//        options.colorTitleCardNumber = UIColor.green
//        options.fontHintCardNumber = UIFont.italicSystemFont(ofSize: 12.0)
//        options.colorHintCardNumber = UIColor.blue
//
//        options.colorButton = UIColor.green
//        options.fontButton = UIFont.systemFont(ofSize: 10.0)
//        options.backgroundColorButton = UIColor.red
//
//        options.isToggleCVC = true
        
        
//        list of saved cards
//        print(begateway.cards)
        
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
                print(card)
            }, failureHandler: {error in
                print(error)
            })
    }
    
}


//extension ViewController: ColorPickerDelegate {
//
//    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
//        // code to handle that user selected a color without confirmed it yet (may change selected color)
////        print("Selected color: \(selectedColor)")
//    }
//
//    func colorPicker(_ colorPicker: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
//        // code to handle that user has confirmed selected color
//        print("Confirmed color: \(confirmedColor)")
//        self.dismiss(animated: true, completion: nil)
//
//        if let view = self.currentColorView {
//            view.backgroundColor = confirmedColor
//
//            if self.currentColorView == self.backgroundColorView {
//                BeGateway.instance.options?.backgroundColor = confirmedColor
//            } else if self.currentColorView == self.textColorView {
//                BeGateway.instance.options?.textColor = confirmedColor
//            }
//        }
//    }
//}
