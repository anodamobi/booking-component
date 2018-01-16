//
//  MainVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class MainVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
            <<< LabelRow() { row in
                row.title = "User data model"
                }.onCellSelection({ (cell, row) in
                    self.navigationController?.pushViewController(UserDataForm(), animated: true)
                })
            <<< LabelRow() { row in
                row.title = "Vendor data"
        }
            <<< LabelRow() {row in
                row.title = "Check vendor table"
        }
    }

}

