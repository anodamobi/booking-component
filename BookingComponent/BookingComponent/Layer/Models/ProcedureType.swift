//
//  ProcedureType.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation

public enum ProcedureType: String, Equatable {
    
    case none = "None"
    case haircut = "Haircut"
    case manicure = "Manicure"
}

struct Procedure {
    
    var procedureName: String = ""
    var details: String = ""
    var durationPrice: Float = 0
    var procedureDuration: TimeInterval = 0
}

extension ProcedureType {
    
    func allProcedureTypes() -> [ProcedureType] {
        return [ProcedureType.haircut, .manicure]
    }
}
