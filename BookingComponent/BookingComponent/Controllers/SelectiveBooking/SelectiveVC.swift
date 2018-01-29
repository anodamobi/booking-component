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
    
    var bookings: [BookingModel] = []
    var businessTime = BusinessTime()
    var duration: TimeInterval!
    var preservationTime: TimeInterval!
    
    var procedureType: ProcedureType!
    var vendor: VendorModel!
    var currentUser: ClientModel!
    var selectedDate: Date!
    private var serviceProviderIndex: Int!
    
    var elementsForCollection: [[TimeCellVM]] = []
    var availableSectionHeaders: [SelectiveHeaderVM] = []
    
    private let eventHandler = EventHandler()
    
    init(_ model: BookViewModel) {
        
        super.init(nibName: nil, bundle: nil)
        
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        self.vendor = model.vendor
        self.procedureType = model.procedureType
        self.currentUser = model.client
        self.selectedDate = model.selectedDate
        self.serviceProviderIndex = model.serviceProviderIndex.rawValue
        
        preservationTime = vendor.bookingSettings.prereservationTimeGap
        duration = vendor.serviceProviders[serviceProviderIndex].availableProcedureTypes[procedureType]?.procedureDuration
        bookings = vendor.serviceProviders[serviceProviderIndex].bookings
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
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.cmpTextStyleFont() ?? UIFont.systemFont(ofSize: 17.0)]
        title = "select.time".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "date".localized,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(selectDate))
        
        eventHandler.selectiveDelegate = self
        
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
