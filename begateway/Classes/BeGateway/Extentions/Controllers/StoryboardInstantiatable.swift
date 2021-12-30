//
//  StoryboardInstantiatable.swift
//  oodymate
//
//  Created by admin on 13.10.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

//// UIViewController
//// case: same name (FooVC.swift / FooVC.storyboard)
//class FooVC: UIViewController,StoryboardInstantiatable  {
//}
//
//let fooVC = FooVC.instantiate()
//
//// UIViewController
//// case: different name (BarVC.swift / Sample.storyboard)
//class BarVC: UIViewController,StoryboardInstantiatable  {
//    static var StoryboardName = "Sample"
//}
//
//let barVC = BarVC.instantiate()

protocol StoryboardInstantiatable {
    static var StoryboardName: String { get }
}

extension StoryboardInstantiatable {
    
    static var StoryboardName: String { return String(describing: Self.self) }
    
    static func instantiate() -> Self {
        return instantiateWithName(name: StoryboardName)
    }
    
    static func instantiateWithName(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else{
            fatalError("failed to load \(name) storyboard file.")
        }
        return vc
    }
}
