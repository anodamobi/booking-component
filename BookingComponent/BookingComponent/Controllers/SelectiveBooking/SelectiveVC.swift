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
    let controller: ANCollectionController
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
        
        controller = ANCollectionController(collectionView: contentView.collectionView)
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
        title = "Select Time".localized
        
        eventHandler.delegate = self
        
        controller.configureCells { (configurator) in
            configurator?.registerCellClass(TimeCell.self,
                                            forModelClass: TimeCellVM.self)
            configurator?.registerHeaderClass(SelectiveHeader.self,
                                              forModelClass: SelectiveHeaderVM.self)
        }

        controller.configureItemSelectionBlock { (viewModel, indexPath) in
            
            if let vm = viewModel as? TimeCellVM {
                var isExist = false
                let book = Booking()
                book.client = self.currentUser
                book.when = vm.item
                book.procedure.startDate = vm.item
                book.procedure.endDate = vm.item.addingTimeInterval(self.vendor.bookingSettings.prereservationTimeGap)
                for single in self.bookings {
                    if (single.procedure.startDate.compare(vm.item) == .orderedSame) {
                        isExist = true
                    }
                }
                if !isExist {
                    vm.isSelected = true
                    self.bookings += [book]
                    self.storage.reload(withAnimation: false)
                }

            }
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
        
        let morning = sortByTime(data: currentDates, .morning).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        let day = sortByTime(data: currentDates, .day).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        let evening = sortByTime(data: currentDates, .evening).map { (day) -> TimeCellVM in
            return TimeCellVM(day)
        }
        
        storage.updateWithoutAnimationChange { (update) in
            
            if (morning.count > 0) {
                update?.updateSectionHeaderModel(SelectiveHeaderVM(type: .morning), forSectionIndex: 0)
                update?.addItems(morning, toSection: 0)
            }
            if (day.count > 0) {
                update?.updateSectionHeaderModel(SelectiveHeaderVM(type: .day), forSectionIndex: 1)
                update?.addItems(day, toSection: 1)
            }
            if (evening.count > 0) {
                update?.updateSectionHeaderModel(SelectiveHeaderVM(type: .evening), forSectionIndex: 2)
                update?.addItems(evening, toSection: 2)
            }
        }
    }
    
//    MARK: Helpers
    
    private func sortByTime(data: [Date], _ type: SectionType) -> [Date] {
        var dateArray: [Date] = []
        for day in data {
            if checkDayHour(day, 6, 13) && type == .morning {
                dateArray += [day]
            }
            if checkDayHour(day, 13, 18) && type == .day {
                dateArray += [day]
            }
            if checkDayHour(day, 18, 22) && type == .evening {
                dateArray += [day]
            }
        }
        return dateArray
    }
    
    private func checkDayHour(_ day: Date, _ minVal: Int, _ maxVal: Int) -> Bool {
        return day.component(.hour) >= minVal && day.component(.hour) < maxVal
    }
}

