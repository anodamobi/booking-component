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
    var storage = ANStorage()
    
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
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        eventHandler.delegate = self
        eventHandler.receiveCurrent(bookings: bookings, businessTime: businessTime)
        
    }
    
    func setupBusinessHours(_ vendor: VendorModel) {
        businessTime.startDate = vendor.startTime
        businessTime.endDate = vendor.endTime
    }
}

extension SelectiveVC: EventHandlerDelegate {
    
    func add(booking: Booking) {
        //Stub
    }
    
    func resetPanGesture() {
        //Stub
    }
    
    func availableTimeChunks(_ intervals: [TimeInterval]) {
        //TODO: pavel - update cell view models with calculated time
    }
}
