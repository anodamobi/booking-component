//
//  ProcedureType.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public enum ProcedureType: String, Equatable {
    
    case none = "None"
    case haircut = "Haircut"
    case manicure = "Manicure"
}

extension ProcedureType {
    
    func allProcedureTypes() -> [ProcedureType] {
        return [ProcedureType.haircut, .manicure]
    }
}
