//
//  SelectiveView.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ANODA_Alister

class SelectiveView: UIView {
    
    var tableView: ANTableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = ANTableView(frame: frame, style: .plain)
        setupaLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupaLayout() {
        backgroundColor = .white
        
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.safeArea.edges)
            }
        }
    }
}
