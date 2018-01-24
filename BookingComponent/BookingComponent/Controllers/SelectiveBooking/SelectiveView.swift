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

enum SectionType: String, Equatable {
    
    case other = "other"
    case morning = "Morning"
    case day = "Day"
    case evening = "Evening"
    
}

class SelectiveView: UIView {
    
    var collectionView: UICollectionView
    
    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: SelectiveView.collectionLayout())
        super.init(frame: frame)
        setupaLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupaLayout() {
        addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    static private func collectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(6, 16, 10, 15)
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: UIScreen.width * 0.28, height: 48)
        layout.headerReferenceSize = CGSize(width: UIScreen.width, height: 50)
        return layout
    }
}
