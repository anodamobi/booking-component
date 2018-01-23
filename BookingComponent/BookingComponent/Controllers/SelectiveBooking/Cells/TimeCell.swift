//
//  TimeCell.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/23/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import ANODA_Alister
import SnapKit

class TimeCellVM: NSObject {
    
    var item: Date
    
    init(_ model: Date) {
        item = model
    }
    
    func updateTimeLabel() -> String {
        return item.hourMinuteFormat()
    }
    
    
    
}

class TimeCell: ANCollectionViewCell {
    
    let timeLabel = UILabel()
    var bgColor = UIColor.cmpPaleGreyThree
    var borderColor = UIColor.cmpSilver
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withModel model: Any!) {
        if let viewModel = model as? TimeCellVM {
            timeLabel.text = viewModel.updateTimeLabel()
        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        contentView.layer.borderColor = UIColor.cmpShamrock.cgColor
//        contentView.backgroundColor = .cmpMidGreen75
//        timeLabel.textColor = .white
//    }
    
    
    func setupLayout() {
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.cmpSilver.cgColor
        contentView.backgroundColor = .cmpPaleGreyThree
        
        contentView.addSubview(timeLabel)
        timeLabel.text = "0:00 AM"
        timeLabel.textAlignment = .center
        timeLabel.textColor = .cmpGunmetal
        timeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(14, 0, 14, 0))
        }
    }
}
