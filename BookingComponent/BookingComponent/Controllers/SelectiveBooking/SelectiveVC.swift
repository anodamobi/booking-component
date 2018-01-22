//
//  SelectiveVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import ANODA_Alister

class SelectiveVC: UIViewController {
    
    let contentView = SelectiveView()
    let controller: ANTableController
    var bookings: [Booking] = []
    var businessTime = BusinessTime()
    var procedureLength: TimeInterval!
    var procedureType: ProcedureType!
    var vendor: VendorModel!
    var currentUser: ClientModel!
    
    var testVendor = TestDataGenerator.createVendor()
    
    private let eventHandler = EventHandler()
    
    init(_ vendor: VendorModel, _ procedureType: ProcedureType, _ client: ClientModel) {
        
        controller = ANTableController(tableView: contentView.tableView)
        super.init(nibName: nil, bundle: nil)
        self.vendor = vendor
        self.procedureType = procedureType
        self.currentUser = client
        procedureLength = vendor.serviceProviders[0].availableProcedureTypes[procedureType]?.procedureDuration
        bookings = vendor.serviceProviders[0].bookings
        setupBusinessHours(vendor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
    
    func setupBusinessHours(_ vendor: VendorModel) {
        businessTime.startDate = vendor.startTime
        businessTime.endDate = vendor.endTime
    }
}
