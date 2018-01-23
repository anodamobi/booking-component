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
        
        navigationController?.navigationBar.tintColor = .cmpMidGreen
        
        eventHandler.delegate = self
        
        controller.configureCells { (configurator) in
            configurator?.registerCellClass(SelectiveCell.self,
                                            forModelClass: SelectiveCellVM.self)
        }
        
        controller.attachStorage(storage)
        
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
    
    func availableTimeChunks(_ intervals: [Date: TimeInterval]) {
        
        var dates: [Date] = []
        
        for interval in intervals {
            let possibleSessions = Int(interval.value / procedureLength)
            for session in 0..<possibleSessions {
                let sessionStart = TimeInterval(Int(procedureLength) * session)
                dates += [interval.key.addingTimeInterval(sessionStart)]
            }
        }
        
        var currentDates: [Date] = []
        
        for date in dates {
//            if date.dateFormat() == Date().dateFormat() {
//                if date.compare(Date().addingTimeInterval(vendor.bookingSettings.prereservationTimeGap))  == .orderedDescending {
                    currentDates += [date]
//                }
//            }
        }
        
        let morningModel = SelectiveCellVM(currentDates, {
            print("selected from morning")
        }, .morning, delegate: self)
        
        let dayModel = SelectiveCellVM(currentDates, {
            print("selected from day")
        }, .day, delegate: self)
        
        let eveningModel = SelectiveCellVM(currentDates, {
            print("selected from evening")
        }, .evening, delegate: self)
        
        storage.updateWithoutAnimationChange { (update) in
            update?.addItems([morningModel, dayModel, eveningModel])
        }
    }
}

extension SelectiveVC: SelectiveCellVMDelegate {
    
    func remove(_ cellVM: SelectiveCellVM) {
        storage.updateWithoutAnimationChange { (update) in
            update?.removeItem(cellVM)
        }
    }
}
