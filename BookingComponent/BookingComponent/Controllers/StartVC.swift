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
                    
                    let model = BookViewModel()
                    model.vendor = TestDataGenerator.createVendor()
                    model.client = TestDataGenerator.createClinet(id: 177)
                    model.procedureType = .haircut
                    model.serviceProviderIndex = .haircut
                    
                self.navigationController?.pushViewController(BookingVC(model), animated: true)
            })
            <<< LabelRow() { row in
                row.title = "Selective View"
                }.onCellSelection({ (cell, row) in
                    
                    let model = BookViewModel()
                    model.vendor = TestDataGenerator.createVendor()
                    model.client = TestDataGenerator.createClinet(id: 177)
                    model.procedureType = .haircut
                    model.serviceProviderIndex = .haircut
                    model.selectedDate = Date()
                    
                    self.navigationController?.pushViewController(SelectiveVC(model), animated: true)
                })
        
    }
}
