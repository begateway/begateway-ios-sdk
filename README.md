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
* iOS 10.0+
* Xcode 10.3+
* Swift 5+

## Usage
### Import sdk
```swift
import begateway
```
### Setup
Initilize payment payment module:
```swift
let paymentModule = BGPaymentModule()
```
Set your payment provider url:
```swift
paymentModule.settings.endpoint = "https://checkout.begateway.com/ctp/api"
```
You must setup your return_url to process 3D SECURE:
```swift
paymentModule.settings.returnURL = "https://your_server_url"
```
You can setup your notification_url to become info about payment statys :
```swift
paymentModule.settings.notificationURL = "https://your_server_notifications_url"
```
### Implement BGPaymentModuleDelegate
```swift
extension YOURCLASS: BGPaymentModuleDelegate {
    func bgPaymentResult(status: BGPaymentModuleStatus) {
        switch status {
            case .success(let cardInfo):
                // Make some action for success state
                // you can save cardInfo, and than use cardInfo.token to make payment by card token
            case .canceled:
                // this status saying, that user canceled payment operation
            case .error(let error):
                // in payment process an error occurred
            case .failure(let message):
                // payment was failed, you can become more info from message, but somethimes it can be empty
        }
    }
}
```
### Start payment 
#### Start payment with `PUBLIC_STORE_KEY`

Create BGOrder object:
```swift
// sample order
let order = BGOrder(amount: 200, currency: "USD", description: "test", trackingId: "my_custom_variable")
```
Use your <b>PUBLIC_STORE_KEY</b> to start payment
```swift
paymentModule.makePay(publicKey: "your_public_key", order: order)
```
#### Start payment with `CHECKOUT`

Get <b>CHECKOUT</b> from <i>your_checkout_endpoint</i>/checkouts
Example checkout <b>json</b>:
```json
{
    "token": "efcbcdeb45cf6a625bbec66a92a55c1ad8d1872d53be8db881a39850b1333dcc",
    "redirect_url": "https://checkout.bepaid.by/checkout?token=4e67bfe907e52c1392a417b5e50b00d3cf92683af4743c127ea27612bd1faa75",
    "brands": [
    {
        "alternative": false,
        "name": "visa"
    },
    {
        "alternative": false,
        "name": "master"
    },
    {
        "alternative": false,
        "name": "belkart"
    },
    {
        "alternative": false,
        "name": "visa"
    },
    {
        "alternative": false,
        "name": "master"
    },
    {
        "alternative": false,
        "name": "maestro"
    }
    ],
    "company": {
        "name": "beGateway",
        "site": "https://begateway.com"
    },
    "description": "Payment description"
}
```
Convert json to BGCheckoutResponseObject, it support Codable protocol
```swift
public struct BGCheckoutResponseObject: Codable {
    var token: String
    var redirectUrl: String?
    var brands: [BGBrand]?
    var company: BGCompany?
    var description: String?

    enum CodingKeys: String, CodingKey {
    case token = "token"
    case redirectUrl = "redirect_url"
    case brands = "brands"
    case company = "company"
    case description = "description"
}
```
```swift
guard let checkoutData = your_checkout_json_string.data(using: .utf8) else {
    // Cannot convert checkout string to data
    return
}
do {
    let checkoutObject = try JSONDecoder().decode(BGCheckoutResponseObject.self, from: checkoutData)
} catch let error {
    //error while decoding
}
```
make payment:
```swift
paymentModule.makePay(checkout: checkoutObject)
```
#### Start payment  with  `Card_Token`

You can get card token from any success pay request, from BGCardInfo object, when user check "Save card" on card form.

Create BGTokenizedCard object
```swift
let card = BGTokenizedCard(token: cardToken)
```
Make payment with `PUBLIC_STORE_KEY`:
```swift
paymentModule.makePay(publicKey: "your_public_key", order: order, tokenizedCard: card)
```
Make payment with payment token:
```swift
module.makePay(paymentToken: paymentToken_from_checkout, card: card)
```

### Encryption
Use `encryptCardData` with your <b>PUBLIC_STORE_KEY</b> to get encrypted credit card data

For example:
```swift
let card = BGCard(
    number: "4200000000000000", 
    verificationValue: "123", 
    holder: "IVAN IVANOV", 
    expMonth: "01", 
    expYear: "2020")
let encryptedCardInfo = BGCard.ecnrypted(card, with: "your_public_key")
if let encryptionError = encryptedCardInfo.error {
    // an error occurred while encrypting
} else if let encryptedCard = encryptedCardInfo.card {
    // now you have encrypted card, congratulation
}
```

### Customization
You can customize card form view with `StyleSettings`

#### Update `StyleSettings`
```swift
// set pay button title
paymentModule.settings.styleSettings.customPayButtonLabel = "your pay label text"
// turn on/off card holder name field
paymentModule.settings.styleSettings.isRequiredCardHolderName = true 
// turn on/off card number field
paymentModule.settings.styleSettings.isRequiredCardNumber = true
// turn on/off card secret code field
paymentModule.settings.styleSettings.isRequiredCVV = true
// turn on/off card expired date field
paymentModule.settings.styleSettings.isRequiredExpDate = true
// turn on/off switch for saving card (if it false, or if user deselect it, you become nil BGCard object in success)
paymentModule.settings.styleSettings.isSaveCardCheckBoxVisible = true
// update securedBy vaale
paymentModule.settings.updateSecuredBy(with:  "YOUR_NEW_VALUE")
```
#### Cusomize colors
You can change color in Card form by assigning a color value to the corresponding value in cardViewColorsSettings of module
```swift
paymentModule.settings.cardViewColorsSettings.cancelTextColor = UIColor
``` 

## License

beGateway SDK is released under the MIT license. [See LICENSE](https://github.com/begateway/begateway-ios-sdk/blob/master/LICENSE) for details.
