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
                    cell.datePicker.minimumDate = Date()
                    cell.datePicker.datePickerMode = .date
                    cell.datePicker.timeZone = TimeZone(abbreviation: "UTC") //TODO: pavel - should be able to change timezone
                    self.user.reservedDate = cell.datePicker.date
                    row.value = cell.datePicker.date
                })
            <<< NameRow() { row in
                row.title = "Booking price"
        }
    }
}
