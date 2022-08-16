# beGateway framework for iOS
[![License](https://img.shields.io/github/license/begateway/begateway-ios-sdk?label=License)](https://github.com/begateway/begateway-ios-sdk/blob/master/LICENSE) [![Pod](https://img.shields.io/badge/pod-v1.1-blue)](https://github.com/begateway/begateway-ios-sdk) ![](https://img.shields.io/badge/platform-iOS-lightgrey) ![](https://img.shields.io/badge/Swift-5.0-green)

beGateway components for iOS allows you to accept in-app payments

## Example
To easy find out how it works:
1) Checkout this repository
2) Open terminal in `Example` folder
3) Open begateway.xcworkspace  in xCode 10.3 and higher
4) Run project and make some action by predefined buttons
5) Examine the source code

## Installation
### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate beGateway into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'begateway'
```
## Requirements
* iOS 11.0+
* Xcode 10.3+
* Swift 5.0+

## Usage
### Import sdk
```swift
import begateway
```
### Setup
Initilize payment module:
```swift
let paymentModule = BeGateway.instance.setup(with: BeGatewayOptions(clientPubKey: "PUBLIC_STORE_KEY"))
```
You can change public key:
```swift
BeGateway.instance.options?.clientPubKey = "PUBLIC_STORE_KEY"
```

If you want to get current instance of object:
```swift
BeGateway.instance
```

### Get token

Create BeGatewayRequest object:
You can setup your notification_url to become info about payment status:
```swift
let request BeGatewayRequest(
// amount
amount: 100.0,
// currency
currency: "USD",
// description
requestDescription: "Test request",
// tracling id
trackingID: "1000000-1"
)
```

Execute response:
```swift
BeGateway.instance.getToken(request: request, completionHandler: {token in
// token for other operation
}, failureHandler:{error in
// out error
print(error)
})
```

### Payment

#### Start payment with `CARD`

Create BeGatewayRequestCard object:
```swift
let card =  BeGatewayRequestCard(
number: "2201382000000013",
verificationValue: "123",
expMonth: "02",
expYear: "23",
holder: "WRR",
cardToken: nil,
)
```

Pay by card without token
```swift
BeGateway.instance.pay(
rootController: self,
request: BeGatewayRequest(
amount: 100.0,
currency: "USD",
requestDescription: "Test request",
trackingID: "1000000-1",
card: card
),
completionHandler: {
card in
// BeGatewayCard
print(card)
}, failureHandler: {error in
print(error)
})
```

Pay by <b>card token</b>
```swift
self.card = BeGatewayRequestCard(
number: nil,
verificationValue: nil,
expMonth: nil,
expYear: nil,
holder: nil,
cardToken: "YourCardToken"
)
```

Payment by card token in <b>background</b>
```swift
        if self.card?.cardToken != nil { // "YourCardToken"
            BeGateway.instance.payByCardTokenInBackground( rootController: self, request: BeGatewayRequest(
                amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
                currency: self.currencyTextField.text ?? "USD",
                requestDescription: "Test request",
                trackingID: "1000000-1",
                card: self.card
            ), completionHandler: {
               //Success handler
            }, failureHandler: {error in
                //Failure handler
            })
        }


If gateway return success you can use object BeGatewayCard

```swift
public struct BeGatewayCard {
public let createdAt: Date
public let first1, last4: String
public let brand: String?
}
```

#### Apple pay

First you need to setup your project with your merhchant ID.
After it you should pass merchant id to BegatewayOptions.
Default <b>Apple Pay</b> with input:
```swift
        options.merchantID = "merchant.org.cocoapods.demo.begateway-Example"
        
        let _ = BeGateway.instance.setup(with: options)
        
        let request = BeGatewayRequest(amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
                                       currency: self.currencyTextField.text?.uppercased() ?? "USD",
                                       requestDescription: "Apple Pay test transaction",
                                       trackingID: "1000000-1",
                                       card: nil)
                                       
        BeGateway.instance.payWithApplePay(requestBE: request, rootController: self) {
            self.showSuccessAlert()
            print("payment success without token")
        } failureHandler: { error in
            self.showFailureAlert(error: error)
            print("---> error \(error)")
        }    
```
<b>Apple Pay</b>  with <b>TOKEN</b>:
```swift
            BeGateway.instance.payWithAppleByToken(token: token, rootController: self) {
                self.showSuccessAlert()
                print("payment success with token")
            } failureHandler: { error in
                self.showFailureAlert(error: error)
                print("---> error \(error)")
            }
```
You can pay with  <b>TOKEN</b>
```swift
BeGateway.instance.payByToken(
    token: PAYMENTTOKEN,
    card : CARD , rootController: self,
    completionHandler: {
        card in
        print(card)
    }, failureHandler: { error in
        print(error)
    })
```

### Other functions

#### Clear all saved `CARDS`

```swift
BeGateway.instance.removeAllCards()
```

### Customization

You can customize card form view with `BeGatewayOptions` in instance or create new object for BeGatewayOptions and set

```swift
let options = BeGatewayOptions();
BeGateway.instance.options = options
```

#### Update `BeGatewayOptions`
```swift
// title 
BeGateway.instance.options?.title: String?
// font title
BeGateway.instance.options?.fontTitle: UIFont?
// color title
BeGateway.instance.options?.colorTitle: UIColor?

// title card number field
BeGateway.instance.options?.titleCardNumber: String = LocalizeString.localizeString(value:"Card number")
// hint card number field
BeGateway.instance.options?.hintCardNumber: String = LocalizeString.localizeString(value:"Card number")
// title card number field
BeGateway.instance.options?.cardNumber: String = LocalizeString.localizeString(value:"Card number")

// font for title card number
BeGateway.instance.options?.fontTitleCardNumber: UIFont?
// color for title card number
BeGateway.instance.options?.colorTitleCardNumber: UIColor?
// font for hint card number
BeGateway.instance.options?.fontHintCardNumber: UIFont?
// color for title card number
BeGateway.instance.options?.colorHintCardNumber: UIColor?


// label expire date
BeGateway.instance.options?.titleExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
// hint expire date
BeGateway.instance.options?.hintExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
// title expire date
BeGateway.instance.options?.expiryDate: String = LocalizeString.localizeString(value:"Expiration date")

// font for title expire date
BeGateway.instance.options?.fontTitleExpiryDate: UIFont?
// color for title expire date
BeGateway.instance.options?.colorTitleExpiryDate: UIColor?
// hint for hint expire date
BeGateway.instance.options?.fontHintExpiryDate: UIFont?
// color for hint of expire date
BeGateway.instance.options?.colorHintExpiryDate: UIColor?


// label CVC
BeGateway.instance.options?.titleCVC: String = LocalizeString.localizeString(value:"CVC")
// hint CVC
BeGateway.instance.options?.hintCVC: String = LocalizeString.localizeString(value:"CVC")
// title CVC
BeGateway.instance.options?.cvc: String = LocalizeString.localizeString(value:"CVC")
// is secure mode for CVC field
BeGateway.instance.options?.isSecureCVC: Bool = false

// font fot title CVC
BeGateway.instance.options?.fontTitleCVC: UIFont?
// color for title CVC
BeGateway.instance.options?.colorTitleCVC: UIColor?
// font fot hint CVC
BeGateway.instance.options?.fontHintCVC: UIFont?
// color for hint CVC
BeGateway.instance.options?.colorHintCVC: UIColor?


// label for Card Holder Name
BeGateway.instance.options?.titleCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
// hint for Card Holder Name
BeGateway.instance.options?.hintCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
// title for Card Holder Name
BeGateway.instance.options?.cardHolderName: String = LocalizeString.localizeString(value:"Name on card")

// font title for Card Holder Name
BeGateway.instance.options?.fontTitleCardHolderName: UIFont?
// color title for for Card Holder Name
BeGateway.instance.options?.colorTitleCardHolderName: UIColor?
// font hint for Card Holder Name
BeGateway.instance.options?.fontHintCardHolderName: UIFont?
// color hint for Card Holder Name
BeGateway.instance.options?.colorHintCardHolderName: UIColor?


// button title
BeGateway.instance.options?.titleButton: String = LocalizeString.localizeString(value: "Pay")
// button text color
BeGateway.instance.options?.colorButton: UIColor?
// button font
BeGateway.instance.options?.fontButton: UIFont?
// button background color
BeGateway.instance.options?.backgroundColorButton: UIColor?

// toggle title
BeGateway.instance.options?.titleToggle: String = LocalizeString.localizeString(value:"Save card")
// error title
BeGateway.instance.options?.errorTitle: String = LocalizeString.localizeString(value:"Sorry, incorrect data")


// common text font
BeGateway.instance.options?.textFont: UIFont?
// common hint font
BeGateway.instance.options?.hintFont: UIFont?
// common text color
BeGateway.instance.options?.textColor: UIColor?
// common hint color
BeGateway.instance.options?.hintColor: UIColor?
// common background color
BeGateway.instance.options?.backgroundColor: UIColor = UIColor.clear


// turn on/off card number field
BeGateway.instance.options?.isToogleCardNumber: Bool = false
// turn on/off card exprire date field
BeGateway.instance.options?.isToogleExpiryDate: Bool = false
// turn on/off card CVC field
BeGateway.instance.options?.isToogleCVC: Bool = false
// turn on/off card holder name field
BeGateway.instance.options?.isToogleCardHolderName: Bool = false
// turn on/off card saved field
BeGateway.instance.options?.isToogleSaveCard: Bool = false

```
#### Customize main options

You can change mode from test to production
```swift
BeGateway.instance.options?.test = true
```

You can change language
```swift
BeGateway.instance.options?.language = "en"
```

You can change delay between responses
```swift
BeGateway.instance.options?.delayCheckingSec = 5
```

You can change max attempths when wainting response payment gateway
```swift
BeGateway.instance.options?.maxCheckingAttempts = 30
```

If you want use Encrypted mode for card
```swift
BeGateway.instance.options?.isEncryptedCreditCard = false
```

#### Use Camera button

If you want to implement image capture you need to override method

```swift
onDetachFromCamera: ((_ onSelected: ((BeGatewayRequestCard?) -> Void)?) -> Void)?
```

## License

beGateway SDK is released under the MIT license. [See LICENSE](https://github.com/begateway/begateway-ios-sdk/blob/master/LICENSE) for details.
