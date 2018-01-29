//
//  ProcedureType.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public enum ProcedureType: String {
    
    case none = "None"
    case haircut = "Haircut"
    case manicure = "Manicure"
}

enum ServiceProviderType: Int {
    case haircut = 0
    case manicure = 1
}

extension ProcedureType {
    
    func allProcedureTypes() -> [ProcedureType] {
        return [ProcedureType.haircut, .manicure]
    }
}
