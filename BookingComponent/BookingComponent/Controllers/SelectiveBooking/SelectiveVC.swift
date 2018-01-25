//
//  SelectiveVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class SelectiveVC: UIViewController {
    
    let contentView = SelectiveView()
    
    internal var bookings: [Booking] = []
    internal var businessTime = BusinessTime()
    internal var procedureLength: TimeInterval!
    internal var preservationTime: TimeInterval!
    
    var procedureType: ProcedureType!
    var vendor: VendorModel!
    var currentUser: ClientModel!
    var selectedDate: Date!
    
    var elementsForCollection: [[TimeCellVM]] = []
    var availableSectionHeaders: [SelectiveHeaderVM] = []
    
    private let eventHandler = EventHandler()
    
    init(_ vendor: VendorModel, _ procedureType: ProcedureType, _ client: ClientModel, _ selectedDate: Date) {
        super.init(nibName: nil, bundle: nil)
        
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        self.vendor = vendor
        self.procedureType = procedureType
        self.currentUser = client
        self.selectedDate = selectedDate
        
        preservationTime = vendor.bookingSettings.prereservationTimeGap
        procedureLength = vendor.serviceProviders[0].availableProcedureTypes[procedureType]?.procedureDuration
        bookings = vendor.serviceProviders[0].bookings
        availableSectionHeaders = [SelectiveHeaderVM(type: .morning), SelectiveHeaderVM(type: .day), SelectiveHeaderVM(type: .evening)]
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Date".localized,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(selectDate))
        
        eventHandler.delegate = self
        
        contentView.collectionView.register(TimeCell.self, forCellWithReuseIdentifier: TimeCellVM.reuseIdentifier)
        contentView.collectionView.register(SelectiveHeader.self,
                                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                            withReuseIdentifier: SelectiveHeaderVM.reuseIdentifier)

        setupBusinessHours(vendor)
        
        eventHandler.receiveCurrent(bookings: bookings,
                                    businessTime: businessTime,
                                    preservationTime: preservationTime,
                                    selectedDate: selectedDate)
    }
    
    private func setupBusinessHours(_ vendor: VendorModel) {
        businessTime.startDate = vendor.startTime
        businessTime.endDate = vendor.endTime
    }
    
    @objc private func selectDate() {
        navigationController?.pushViewController(DatePickerVC.init(callBack: { (result) in
            
            self.selectedDate = result
            self.availableSectionHeaders = [SelectiveHeaderVM(type: .morning),
                                            SelectiveHeaderVM(type: .day),
                                            SelectiveHeaderVM(type: .evening)]
            
            self.eventHandler.receiveCurrent(bookings: self.bookings,
                                        businessTime: self.businessTime,
                                        preservationTime: self.preservationTime,
                                        selectedDate: self.selectedDate)
        }), animated: true)
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
                if date.compare(Date().addingTimeInterval(vendor.bookingSettings.prereservationTimeGap))  == .orderedDescending {
                    currentDates += [date]
                }
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
        
        elementsForCollection = [morning, day, evening]
        contentView.collectionView.reloadData()
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

extension SelectiveVC: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCellVM.reuseIdentifier, for: indexPath) as? TimeCell
        cell?.update(elementsForCollection[indexPath.section][indexPath.row])
        return cell ?? TimeCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = elementsForCollection[indexPath.section][indexPath.row]
            
            var isExist = false
            let book = Booking()
            
            book.client = self.currentUser
            book.when = viewModel.item
            book.procedure.startDate = viewModel.item
            book.procedure.endDate = viewModel.item.addingTimeInterval(self.vendor.bookingSettings.prereservationTimeGap)
            
            for single in self.bookings {
                if (single.procedure.startDate.compare(viewModel.item) == .orderedSame) {
                    isExist = true
                }
            }
            if !isExist {
                viewModel.isSelected = true
                self.bookings += [book]
                contentView.collectionView.reloadData()
            }
        }
}

extension SelectiveVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementsForCollection[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        var index = elementsForCollection.count - 1
        while (elementsForCollection.count - 1) >= 0 {
            
            if index == -1 {
                break
            }
            
            if elementsForCollection[index].count < 1 {
                elementsForCollection.remove(at: index)
                availableSectionHeaders.remove(at: index)
            }
            
            index -= 1
        }

        return availableSectionHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SelectiveHeaderVM.reuseIdentifier, for: indexPath) as? SelectiveHeader

        cell?.update(model: availableSectionHeaders[indexPath.section])

        return cell ?? SelectiveHeader()
    }
}
