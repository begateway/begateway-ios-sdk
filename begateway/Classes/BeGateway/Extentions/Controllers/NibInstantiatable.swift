//
//  NibInstantiatable.swift
//  oodymate
//
//  Created by admin on 13.10.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

// UIView
// case: same name (FooView.swift / FooView.xib)
//class FooView: UIView, NibInstantiatable  {
//}
//let fooView = FooView.instantiate()
//
//// UIView
//// case: different name (BarView.swift / Sample.xib)
//class BarView: UIView, NibInstantiatable  {
//    static var NibName = "Sample"
//}
//let barView = BarView.instantiate()

protocol NibInstantiatable {
    static var NibName: String { get }
}

extension NibInstantiatable {
    
    static var NibName: String { return String(describing: Self.self)}
    
    static func instantiate() -> Self {
        return instantiateWithName(name: NibName)
    }
    
    static func instantiateWithOwner(owner: AnyObject?) -> Self {
        return instantiateWithName(name: NibName, owner: owner)
    }
    
    static func instantiateWithName(name: String, owner: AnyObject? = nil) -> Self {
        let nib = UINib(nibName: name, bundle: nil)
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? Self else {
            fatalError("failed to load \(name) nib file")
        }
        return view
    }
}
