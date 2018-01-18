//
//  MainVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/16/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    let startDate: Date
    let endDate: Date
    let controller: BookingController
    let booked1 = Booking()
    let booked2 = Booking()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        booked1.procedure.startDate = Date.date(from: "2018-01-17T9:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        booked1.procedure.endDate = Date.date(from: "2018-01-17T10:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        booked1.procedure.endDate = booked1.procedure.endDate.addingTimeInterval(15*60)
        booked2.procedure.startDate = Date.date(from: "2018-01-17T11:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        booked2.procedure.endDate = Date.date(from: "2018-01-17T13:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        booked2.procedure.endDate = booked2.procedure.endDate.addingTimeInterval(15*60)
        startDate = Date.date(from: "2018-01-17T8:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        endDate = Date.date(from: "2018-01-17T18:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        controller = BookingController(booked: [booked1, booked2],
                                       startDate: startDate,
                                       endDate: endDate)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newBook = Booking()
        newBook.procedure.startDate = Date.date(from: "2018-01-15T10:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        newBook.procedure.endDate = Date.date(from: "2018-01-15T11:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
        newBook.procedure.endDate = newBook.procedure.endDate.addingTimeInterval(15*60)
        let intervals = controller.isPossibleToBook(newBook: newBook)
        debugPrint("new book 1: Could be booked")
        
//        let newBook1 = Booking()
//        newBook1.procedure.startDate = Date.date(from: "2018-01-17T14:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
//        newBook1.procedure.endDate = Date.date(from: "2018-01-17T15:00", timeFormat: "yyyy-mm-dd'T'HH:mm")!
//        let bool1 = controller.isPossibleToBook(newBook: newBook1)
//        debugPrint("new book 2: Could be booked \(bool1)")
    }
}

