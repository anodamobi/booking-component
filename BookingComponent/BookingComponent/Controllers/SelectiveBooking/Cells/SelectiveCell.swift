//
//  SelectiveCell.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/22/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import ANODA_Alister
import SnapKit

enum CellType: String, Equatable {
    
    case morning = "Morning"
    case day = "Day"
    case evening = "Evening"
    
}

protocol SelectiveCellVMDelegate {
    func remove(_ cellVM: SelectiveCellVM)
}

class SelectiveCellVM : NSObject {
    
    var storage: ANStorage = ANStorage()
    var title: String!
    var selectionClosure: (()->())!
    var delegate: SelectiveCellVMDelegate?
    var models: [TimeCellVM] = []
    var type: CellType = CellType.morning
    
    init(_ data: [Date], _ selectionClosure: @escaping ()->(), _ type: CellType, delegate: SelectiveCellVMDelegate?) {
 
        super.init()
        self.delegate = delegate
        self.selectionClosure = selectionClosure

        self.type = type
        switch type {
            case .morning: self.title = CellType.morning.rawValue
            case .day: self.title = CellType.day.rawValue
            case .evening: self.title = CellType.evening.rawValue
        }

        models = sortByTime(data: data).map { (element) -> TimeCellVM in
            return TimeCellVM(element)
        }
        
        setupStorage(models: models)
    }
    
    private func sortByTime(data: [Date]) -> [Date] {
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
    
    func removeIfNeeded() {
        
        guard models.count > 0 else {
            delegate?.remove(self)
            return
        }
    }
    
    func setupStorage(models: [TimeCellVM]) {
        
        storage.updateWithoutAnimationChange { (update) in
            update?.addItems(models)
        }
    }
    
}

class SelectiveCell: ANBaseTableViewCell {
    
    var collectionView: UICollectionView
    var controller: ANCollectionController
    weak var viewModel: SelectiveCellVM?
    let dayTimeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SelectiveCell.collectionLayout())
        controller = ANCollectionController(collectionView: collectionView)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        controller.configureCells { (configurator) in
            configurator?.registerCellClass(TimeCell.self, forModelClass: TimeCellVM.self)
        }
        
        controller.configureItemSelectionBlock { (viewModel, indexPath) in
            if let vm = viewModel as? TimeCellVM {
                vm.isSelected = true
                self.viewModel?.selectionClosure()
            }
        }
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withModel model: Any!) {
        if let viewModel = model as? SelectiveCellVM {
            self.viewModel = viewModel
            controller.attachStorage(viewModel.storage)
            dayTimeLabel.text = viewModel.title
            viewModel.removeIfNeeded()
        }
    }
    
    func setupLayout() {
        
        contentView.addSubview(dayTimeLabel)
        
        dayTimeLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).inset(UIEdgeInsetsMake(25, 16, 0, 0))
        }
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 11, 5, 10))
            make.top.equalTo(dayTimeLabel.snp.bottom).offset(-6)
        }
    }
    
    static private func collectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(6, 5, 6, 5)
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: UIScreen.width * 0.28, height: 48)
        
        return layout
    }
}
