//
//  StartVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import Eureka

class StartVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section()
            <<< LabelRow() { row in
                row.title = "Calendar View"
                }.onCellSelection({ (cell, row) in
                self.navigationController?.pushViewController(BookingVC(TestDataGenerator.createVendor(),
                                                                        .haircut,
                                                                        TestDataGenerator.createClinet(id: 177)), animated: true)
            })
            <<< LabelRow() { row in
                row.title = "Selective View"
                }.onCellSelection({ (cell, row) in
                    self.navigationController?.pushViewController(SelectiveVC(TestDataGenerator.createVendor(),
                                                                              .haircut,
                                                                              TestDataGenerator.createClinet(id: 177), Date()), animated: true)
                })
        
    }
}
