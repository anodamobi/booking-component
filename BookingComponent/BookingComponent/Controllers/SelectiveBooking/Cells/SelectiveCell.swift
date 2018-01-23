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

class SelectiveCellVM {
    
    var storage: ANStorage = ANStorage()
    
    var selectionClosure: (()->())?
    
}

class SelectiveCell: ANBaseTableViewCell {
    
    var collectionView: UICollectionView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SelectiveCell.collectionLayout())
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withModel model: Any!) {
        
    }
    
    func setupLayout() {
        contentView.addSubview(collectionView)
        
    }
    
    static private func collectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(6, 5, 6, 5)
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 108, height: 48)
        
        return layout
    }
}
