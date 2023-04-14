//
//  UIViewController+StoryboardInstance.swift
//  FlightSearch
//
//  Created by Husein Huseinau on 18.04.2023.
//

import Foundation
import class UIKit.UIViewController
import class UIKit.UIStoryboard

extension UIKit.UIViewController {

    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard,
                                                                              identifier: String) -> T {
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("""
                Cannot instantiate controller
                with identifier \(identifier) of \(T.nameOfClass) in storyboard \(storyboard.self)
                """)
        }
        return controller
    }

    class func fromStoryboard(_ storyboard: UIStoryboard? = nil) -> Self {
        let storyboard = storyboard ?? UIStoryboard(name: nameOfClass, bundle: nil)
        return instantiateControllerInStoryboard(storyboard, identifier: nameOfClass)
    }
}

private extension NSObject {

    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
