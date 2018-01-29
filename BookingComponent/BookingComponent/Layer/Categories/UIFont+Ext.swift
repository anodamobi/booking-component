//
//  UIFont+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/29/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func cmpTextStyle4Font() -> UIFont? {
        return UIFont(name: "SFProDisplay-Semibold", size: 22.0)!
    }
    
    class func cmpTextStyleFont() -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: 17.0)!
    }
    
    class func cmpTextStyle3Font() -> UIFont {
        return UIFont(name: "SFProText-Medium", size: 17.0)!
    }
    
    class func cmpTextStyle2Font() -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: 15.0)!
    }
}
