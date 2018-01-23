//
//  SelectiveHeader.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/23/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import SnapKit
import ANODA_Alister

class SelectiveHeaderVM: NSObject {
    
    var title = ""
    init(type: SectionType) {
        switch type {

        case .morning:
            title = type.rawValue
        case .day:
            title = type.rawValue
        case .evening:
            title = type.rawValue
        }
    }
}

class SelectiveHeader: ANCollectionReusableView {
    
    let label = UILabel()
    
    override func update(withModel model: Any!) {
        if let vm = model as? SelectiveHeaderVM {
            label.text = vm.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(26)
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(25)
        }
    }
}
