//
//  UITableView.swift
//  oodymate
//
//  Created by admin on 21/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCellByNib(with nibName: String, identifier: String? = nil, bundle: Bundle? = nil) {
        self.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: (identifier == nil ? nibName : identifier!))
    }
    
    func dequeueReusableCellByNib<T>(with type: T) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}
