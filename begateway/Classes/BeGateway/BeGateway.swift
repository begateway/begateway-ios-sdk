//
//  BegetWayApi.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

import UIKit

public class BeGateway {
    public static let instance = BeGateway()
    
    public var options: BeGatewayOptions?
    public var request: BeGatewayRequest?
    var completionHandler: ((BeGatewayCard) -> Void)?
    var failureHandler:((String) -> Void)?
    
    private var storeCards: Array<StoreCard> = []
    
    public var cards: Array<BeGatewayCard> {
        get {
            return StoreCard.to(items: self.storeCards)
        }
    }
    
    private init() {
        //
    }
    
    public func setup(with settings: BeGatewayOptions) -> BeGateway {
        self.options = settings
        self.loadSavedCard()
        return self
    }

    public func setup(pubKey: String) -> BeGateway {
        self.options = BeGatewayOptions(clientPubKey: pubKey)
        self.loadSavedCard()
        return self
    }
    
    private func loadSavedCard() {
        if let items = StoreCard.readFromUserDefaults(){
            self.storeCards = items
        }
        
        //        StoreCard.clearUserDefaults()
    }
    
    private func initRequest(request: BeGatewayRequest, completionHandler: ((BeGatewayCard) -> Void)?, failureHandler:((String) -> Void)?)
    {
        self.request = request
        self.completionHandler = completionHandler
        self.failureHandler = failureHandler
        
        guard let _ = self.options else {
            fatalError("Error - Options is nll")
        }
        
        guard let _ = self.request else {
            fatalError("Error - Request is nll")
        }
    }
    
    public func removeAllCards() {
        _ = StoreCard.clearUserDefaults()
        self.storeCards.removeAll()
    }
    
    public func pay(rootController: UIViewController, request: BeGatewayRequest, completionHandler: ((BeGatewayCard) -> Void)?, failureHandler:((String) -> Void)?) {

        self.initRequest(request: request, completionHandler: completionHandler, failureHandler: failureHandler)
        
        let bundle = Bundle(for: type(of: self))

//                for test
//        let controller = WebViewController.loadFromNib(bundle)
//        controller.url = "https://gateway.bepaid.by/process/114115979-61f987f750"
//        rootController.present(controller, animated: true, completion: nil)
//        return
        
//        for test
//        let controller = InitialViewController.loadFromNib(bundle)
//        self.presentController(controller, rootController: rootController, sizes: [.fullscreen])
//        return
        
//        clear all saved cards for test
//        self.removeAllCards()
        
        if let card = StoreCard.getActiveCard() {
            print("Active card is \(card.first1)**********\(card.last4)")
            
            let controller = InitialViewController.loadFromNib(bundle)
            self.presentController(controller, rootController: rootController, sizes: [.fixed(300.0)])
        } else {
            let controller = PaymentViewController.loadFromNib(bundle)
            self.presentController(controller, rootController: rootController, sizes: [.fullscreen])
        }
    }
    
    private func presentController(_ controller: UIViewController, rootController: UIViewController, sizes: [SheetSize] = [.intrinsic]) {
        let options = SheetOptions(
            useInlineMode: false
        )
        
        let sheetController = SheetViewController(
            controller: UINavigationController(rootViewController: controller),
            sizes: sizes,
            options: options)
        
        //            sheetController.animateIn(to: rootController.view, in: rootController)
        rootController.present(sheetController, animated: true, completion: nil)
    }
    
    public func getToken(request: BeGatewayRequest, completionHandler: ((String) -> Void)?, failureHandler:((String) -> Void)?)
    {
        if let options = BeGateway.instance.options, !request.isEmpty {
            BeGatewaySourceApi(options: options).checkout(request: request, completionHandler: {result in
                if let token = result?.checkout?.token {
                    print("Token for operation is \"\(token)\"")
                    completionHandler?(token)
                } else {
                    failureHandler?("Error: token is null")
                }
            }, failureHandler: {error in
                failureHandler?(error)
            })
        }
    }
    
    public func payByToken(token: String, rootController: UIViewController, request: BeGatewayRequest, completionHandler: ((BeGatewayCard) -> Void)?, failureHandler:((String) -> Void)?) {
        
        self.initRequest(request: request, completionHandler: completionHandler, failureHandler: failureHandler)
        let bundle = Bundle(for: type(of: self))
        
        let controller = PaymentViewController.loadFromNib(bundle)
        controller.tokenForRequest = token
        self.presentController(controller, rootController: rootController, sizes: [.fullscreen])
    }
}

extension BeGateway {
    public static func test() {
        print("Test from API")
    }
}
