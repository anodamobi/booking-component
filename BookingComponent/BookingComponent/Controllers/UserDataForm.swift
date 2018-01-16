//
//  UserDataForm.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import Eureka

class UserDataForm: FormViewController {
    
    let user = CustomerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
            <<< NameRow() { row in
                row.title = "First Name"
                }.cellSetup({ (cell, row) in
                    self.user.firstName = cell.textField.text ?? ""
                })
            <<< NameRow() { row in
                row.title = "Last Name"
                }.cellSetup({ (cell, row) in
                    self.user.lastName = cell.textField.text ?? ""
                })
            <<< DateRow() { row in
               row.title = "Reservation Date"
                }.cellSetup({ (cell, row) in
                    self.user.reservedDate = cell.datePicker.date
                })
            <<< NameRow() { row in
                row.title = "Booking price"
        }
    }
}
