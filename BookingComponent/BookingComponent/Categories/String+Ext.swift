//
//  String+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/19/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
