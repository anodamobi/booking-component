//
//  DatePickerVC.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/25/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias callBackClosure = (Date) -> ()

class DatePickerVC: UIViewController {
    
    let contentView: DatePickerView = DatePickerView()
    var callBackClosure: callBackClosure = { _ in }
    
    init(callBack: @escaping (Date) -> ()) {
        super.init(nibName: nil, bundle: nil)
        callBackClosure = callBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        
        title = "selective.title".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save".localized, style: .done, target: self, action: #selector(back))
        
    }
    
    @objc private func back() {
        callBackClosure(contentView.datePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
}

class DatePickerView: UIView {
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        backgroundColor = .white
        
        addSubview(datePicker)
        
        datePicker.date = Date()
        datePicker.locale = NSLocale.current
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date

        datePicker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
