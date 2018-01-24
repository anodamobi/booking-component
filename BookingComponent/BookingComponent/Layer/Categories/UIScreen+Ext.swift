//
//  UIScreen+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/23/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    
    class var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}
