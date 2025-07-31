# Фреймворк beGateway для iOS
[![License](https://img.shields.io/github/license/begateway/begateway-ios-sdk?label=License)](https://github.com/begateway/begateway-ios-sdk/blob/master/LICENSE) [![Pod](https://img.shields.io/badge/pod-v1.1-blue)](https://github.com/begateway/begateway-ios-sdk) ![](https://img.shields.io/badge/platform-iOS-lightgrey) ![](https://img.shields.io/badge/Swift-5.0-green)

Компоненты beGateway для iOS позволяют интегрировать прием платежей в ваши iOS-приложения.

## Пример
Чтобы посмотреть пример использования SDK BeGateway в приложении, выполните следующие шаги:
1) Скачайте этот репозиторий.
2) В терминале перейдите в папку `Example`.
3) Запустите xCode версии 10.3 или выше и откройте файл begateway.xcworkspace  
4) Запустите проект в xCode, затем протестируйте приложение, используя специальные кнопки в интерфейсе.
5) Изучите исходный код.

## Установка
### CocoaPods
[CocoaPods](https://cocoapods.org) – это менеджер зависимостей для проектов разработки iOS приложений. Используйте инструкции по установке и использованию сервиса на сайте [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation). Для интеграции beGateway в проект xCode с помощью CocoaPods, добавьте зависимость в `Podfile`:

```ruby
pod 'begateway'
```
## Требования
* iOS 11.0+
* Xcode 10.3+
* Swift 5.0+

## Интеграция
### Импорт SDK
```swift
import begateway
```
### Установка
Инициализируйте модуль оплаты:
```swift
let paymentModule = BeGateway.instance.setup(with: BeGatewayOptions(clientPubKey: "PUBLIC_STORE_KEY"))
```
Добавьте публичный ключ своего магазина:
```swift
BeGateway.instance.options?.clientPubKey = "PUBLIC_STORE_KEY"
```

Для получения текущего экземпляра объекта, используйте команду: 
```swift
BeGateway.instance
```

### Получения токена платежа

Создайте объект BeGatewayRequest.
Для получения информации о статусе транзакции, добавьте notification_url:
```swift
let request BeGatewayRequest(
// сумма
amount: 100.0,
// валюта
currency: "USD",
// описание
requestDescription: "Test request",
// tracking_id
trackingID: "1000000-1"
)
```

#### Передача дополнительной информации о покупателе

```swift
let request = BeGatewayRequest(
    amount: 100.0,
    currency: "USD",
    requestDescription: "Apple Pay test transaction",
    trackingID: "1000000-1",
    card: nil,
    recipient: BeGatewayRequestRecipient(
        // идентификатора счета получателя платежа
        accountNumber: "123456789",
        // enum: card, iban, bic, other
        accountNumberType: "IBAN"
    ),
    customer: BeGatewayRequestCustomer(
        address: "123 Main St",
        country: "US",
        city: "New York",
        email: "john.doe@example.com",
        firstName: "John",
        lastName: "Doe",
        state: "NY",
        zip: "10001",
        phone: "+1234567890",
        //YYYY-MM-DD       
        birthDate: "1990-01-01"
    ),
    paymentCustomer: BeGatewayPaymentCustomer(
        ip: "192.168.1.1",
        deviceId: "device-abc-123"
    )
)
```

Запустите обработку ответа:
```swift
BeGateway.instance.getToken(request: request, completionHandler: {token in
// токен для последующих операций
}, failureHandler:{error in
// вывод ошибки
print(error)
})
```

### Оплата

#### Настройка оплаты с помощью  `CARD`

Создайте объект BeGatewayRequestCard:
```swift
let card =  BeGatewayRequestCard(
number: "2201382000000013",
verificationValue: "123",
expMonth: "02",
expYear: "27",
holder: "WRR",
cardToken: nil,
)
```

Оплата по карте без использования токена:
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

Оплата с помощью <b>токена карты</b>:
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

Оплата с помощью токена карты <b>в фоновом режиме</b>:
```swift
        if self.card?.cardToken != nil { // "YourCardToken"
            BeGateway.instance.payByCardTokenInBackground( rootController: self, request: BeGatewayRequest(
                amount: Double(self.valueTextField.text ?? "0.0") ?? 0.0,
                currency: self.currencyTextField.text ?? "USD",
                requestDescription: "Test request",
                trackingID: "1000000-1",
                card: self.card
            ), completionHandler: {
               //Обработчик успешных транзакций
            }, failureHandler: {error in
                //Обработчик ошибок
            })
        }


Если шлюз возвращает успешный ответ, вы можете использовать объект BeGatewayCard:

```swift
public struct BeGatewayCard {
public let createdAt: Date
public let first1, last4: String
public let brand: String?
}
```

#### Apple Pay

Сначала вам нужно настроить ваш проект с вашим идентификатором продавца (merchant ID), затем этот идентификатор нужно передать в BegatewayOptions.
Пример:
```swift
        options.merchantID = "merchant.org.cocoapods.demo.begateway-Example"
        options.merchantName = "Your Company, OOO" // Название компании, будет отображено в платежном документе покупателя

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
Пример с <b>TOKEN</b> Apple:
```swift
            BeGateway.instance.payWithAppleByToken(token: token, rootController: self) {
                self.showSuccessAlert()
                print("payment success with token")
            } failureHandler: { error in
                self.showFailureAlert(error: error)
                print("---> error \(error)")
            }
```
Пример с <b>TOKEN</b> карты:
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
Где PAYMENTTOKEN это значение в формате строки.
CARD -  объект экземпляра BeGatewayRequestCard.

Может быть инициирован с помощью параметров:
self.number = number - Номер карты
self.verificationValue = verificationValue - Код CVC
self.expYear = expYear - Год окончания срока действия карты
self.expMonth = expMonth - Месяц окончания срока действия карты
self.holder = holder - Имя владельца карты
ИЛИ
self.cardToken = cardToken - Токен карты

Если нет ранее сохраненных карт, можно использовать пустой объект BeGatewayRequestCard().

### Дополнительные возможности

#### Удалить ранее сохраненные карты:

```swift
BeGateway.instance.removeAllCards()
```

### Кастомизация стилей

Вы можете кастомизировать внешний вид формы ввода карточных данных двумя способами: 

#### 1) Создать новый объект `BeGatewayOptions` в экземпляре BeGateway:

```swift
let options = BeGatewayOptions();
BeGateway.instance.options = options
```

#### 2) Обновить существующий объект `BeGatewayOptions`:
```swift
// текст заголовка 
BeGateway.instance.options?.title: String?
// шрифт заголовка
BeGateway.instance.options?.fontTitle: UIFont?
// цвет заголовка
BeGateway.instance.options?.colorTitle: UIColor?

// текст названия поля для ввода номера карты
BeGateway.instance.options?.titleCardNumber: String = LocalizeString.localizeString(value:"Card number")
// текст подсказки для поля ввода номера карты
BeGateway.instance.options?.hintCardNumber: String = LocalizeString.localizeString(value:"Card number")
// текст содержимого поля для ввода номера карты
BeGateway.instance.options?.cardNumber: String = LocalizeString.localizeString(value:"Card number")

// шрифт названия поля ввода карточных данных
BeGateway.instance.options?.fontTitleCardNumber: UIFont?
// цвет названия поля ввода карточных данных
BeGateway.instance.options?.colorTitleCardNumber: UIColor?
// шрифт подсказки для поля ввода карточных данных
BeGateway.instance.options?.fontHintCardNumber: UIFont?
// цвет подсказки для поля ввода карточных данных
BeGateway.instance.options?.colorHintCardNumber: UIColor?
// цвет фона для поля ввода карточных данных
BeGateway.instance.options?.textFieldBackgroundColor: UIColor?



// текст заголовка поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.titleExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
// текст подсказки для поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.hintExpiryDate: String = LocalizeString.localizeString(value:"Expiration date")
// текст содержимого поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.expiryDate: String = LocalizeString.localizeString(value:"Expiration date")

// шрифт заголовка поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.fontTitleExpiryDate: UIFont?
// цвет заголовка поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.colorTitleExpiryDate: UIColor?
// шрифт подсказки для поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.fontHintExpiryDate: UIFont?
// цвет подсказки для поля для ввода даты окончания срока действия карты
BeGateway.instance.options?.colorHintExpiryDate: UIColor?


// текст заголовка для поля CVC
BeGateway.instance.options?.titleCVC: String = LocalizeString.localizeString(value:"CVC")
// текст подсказки для поля CVC
BeGateway.instance.options?.hintCVC: String = LocalizeString.localizeString(value:"CVC")
// текст содержимого поля CVC
BeGateway.instance.options?.cvc: String = LocalizeString.localizeString(value:"CVC")
// маскируются ли данные, введенные в поле CVC
BeGateway.instance.options?.isSecureCVC: Bool = false

// шрифт заголовка поля CVC
BeGateway.instance.options?.fontTitleCVC: UIFont?
// цвет заголовка поля CVC
BeGateway.instance.options?.colorTitleCVC: UIColor?
// шрифт подсказки для поля CVC
BeGateway.instance.options?.fontHintCVC: UIFont?
// цвет подсказки для поля CVC
BeGateway.instance.options?.colorHintCVC: UIColor?


// текст заголовка для поля Имя держателя
BeGateway.instance.options?.titleCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
// текст подсказки для поля Имя держателя
BeGateway.instance.options?.hintCardHolderName: String = LocalizeString.localizeString(value:"Name on card")
// текст содержимого поля Имя держателя
BeGateway.instance.options?.cardHolderName: String = LocalizeString.localizeString(value:"Name on card")

// шрифт названия поля Имя держателя
BeGateway.instance.options?.fontTitleCardHolderName: UIFont?
// текст названия поля Имя держателя
BeGateway.instance.options?.colorTitleCardHolderName: UIColor?
// шрифт текста подсказки для поля Имя держателя
BeGateway.instance.options?.fontHintCardHolderName: UIFont?
// цвет текста подсказки для поля Имя держателя
BeGateway.instance.options?.colorHintCardHolderName: UIColor?


// текст на кнопке оплаты
BeGateway.instance.options?.titleButton: String = LocalizeString.localizeString(value: "Pay")
// цвет текста на кнопке оплаты
BeGateway.instance.options?.colorButton: UIColor?
// шрифт текста на кнопке оплаты
BeGateway.instance.options?.fontButton: UIFont?
// цвет фона кнопки оплаты
BeGateway.instance.options?.backgroundColorButton: UIColor?

// название переключателя сохранения данных карты
BeGateway.instance.options?.titleToggle: String = LocalizeString.localizeString(value:"Save card")
// текст ошибки о неверно введенных карточных данных
BeGateway.instance.options?.errorTitle: String = LocalizeString.localizeString(value:"Sorry, incorrect data")


// общий шрифт текста
BeGateway.instance.options?.textFont: UIFont?
// общий шрифт подсказок
BeGateway.instance.options?.hintFont: UIFont?
// общий цвет текста
BeGateway.instance.options?.textColor: UIColor?
// общий цвет текста подсказок
BeGateway.instance.options?.hintColor: UIColor?
// общий цвет фона
BeGateway.instance.options?.backgroundColor: UIColor = UIColor.clear


// отобразить/скрыть поле номера карты
BeGateway.instance.options?.isToogleCardNumber: Bool = false
// отобразить/скрыть поле с датой окончания срока действия карты
BeGateway.instance.options?.isToogleExpiryDate: Bool = false
// отобразить/скрыть поле CVC
BeGateway.instance.options?.isToogleCVC: Bool = false
// отобразить/скрыть поле с именем держателя карты
BeGateway.instance.options?.isToogleCardHolderName: Bool = false
// отобразить/скрыть переключатель сохранения данных карты
BeGateway.instance.options?.isToogleSaveCard: Bool = false
```
```
//Вы можете установить обработчик для кнопки "Отмена" на экране оплаты

BeGateway.instance.options?.cancelButtonHandler

Пример:
    public override func viewWillAppear(_ animated: Bool) {
        self.cancelButtonPressHandler()
    }
    private func cancelButtonPressHandler() {
        let options = BeGateway.instance.options ?? BeGatewayOptions(clientPubKey: "")
        options.cancelButtonHandler = {
            // Код с логикой обработки
             print("The \"Cancel\" button was pressed")
        }
    }
```
#### Кастомизация основных параметров
Вы можете выключить тестовый режим (по умолчанию, true):
```swift
BeGateway.instance.options?.test = false
```

Вы можете изменить тип транзакции (по умолчанию, "payment"):
```swift
BeGateway.instance.options?.transaction_type = "authorization"
```


Для получения уведомления о статусе транзакции, задайте значение свойства **notificationURL**: 
```swift
BeGateway.instance.options?.notificationURL = "https://yourdomain.com/payment/notification"
```

Вы можете изменить язык платежной страницы:
```swift
BeGateway.instance.options?.language = "en"
```

Вы можете изменить интервал между запросами: статуса от шлюза:
```swift
BeGateway.instance.options?.delayCheckingSec = 5
```

Вы можете изменить максимальное количество попыток запроса статуса от шлюза:
```swift
BeGateway.instance.options?.maxCheckingAttempts = 30
```

Вы можете использовать шифрование карточных данных:
```swift
BeGateway.instance.options?.isEncryptedCreditCard = true
```

#### Использование камеры

Если вы хотите использовать камеру для сканирования карты, переопределите следующий метод: 

```swift
onDetachFromCamera: ((_ onSelected: ((BeGatewayRequestCard?) -> Void)?) -> Void)?
```

## Лицензия

beGateway SDK доступна под лицензией MIT. Подробнее в [файле LICENSE](https://github.com/begateway/begateway-ios-sdk/blob/master/LICENSE).
