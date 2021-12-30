//
//  PaymentBasicViewController.swift
//  begateway.framework
//
//  Created by admin on 06.11.2021.
//

import UIKit

class PaymentBasicViewController: UIViewController {
    var didDisappear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        self.didDisappear = true
        super.viewDidDisappear(animated)
    }
}
