//
//  UITableViewCell.swift
//  oodymate
//
//  Created by admin on 27/08/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UITableViewCell {
    var parentTableView: UITableView? {
        return parentView(of: UITableView.self)
    }
}
