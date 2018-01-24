//
//  SelectiveHeader.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/23/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import SnapKit

class SelectiveHeaderVM: NSObject {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(SelectiveHeaderVM.self)
    }
    
    var title = ""
    init(type: SectionType) {
        title = type.rawValue
    }
}

class SelectiveHeader: UICollectionReusableView {
    
    let label = UILabel()
    
    func update(model: SelectiveHeaderVM) {
        label.text = model.title
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
