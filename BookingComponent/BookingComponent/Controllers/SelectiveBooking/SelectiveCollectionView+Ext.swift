//
//  SelectiveCollectionView+Ext.swift
//  BookingComponent
//
//  Created by Pavel Mosunov on 1/29/18.
//  Copyright © 2018 Anoda. All rights reserved.
//

import Foundation
import UIKit

extension SelectiveVC: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCellVM.reuseIdentifier, for: indexPath) as? TimeCell
        cell?.update(elementsForCollection[indexPath.section][indexPath.row])
        return cell ?? TimeCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = elementsForCollection[indexPath.section][indexPath.row]
        
        var isExist = false
        let book = BookingModel()
        
        book.client = self.currentUser
        book.eventDate = viewModel.item
        book.procedure.startDate = viewModel.item
        book.procedure.endDate = viewModel.item.addingTimeInterval(self.vendor.bookingSettings.prereservationTimeGap)
        
        for single in self.bookings {
            if (single.procedure.startDate.compare(viewModel.item) == .orderedSame) {
                isExist = true
            }
        }
        if !isExist {
            viewModel.isSelected = true
            self.bookings += [book]
            contentView.collectionView.reloadData()
        }
    }
}

extension SelectiveVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elementsForCollection[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        var index = elementsForCollection.count - 1
        while (elementsForCollection.count - 1) >= 0 {
            
            if index == -1 {
                break
            }
            
            if elementsForCollection[index].count < 1 {
                elementsForCollection.remove(at: index)
                availableSectionHeaders.remove(at: index)
            }
            
            index -= 1
        }
        
        return availableSectionHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SelectiveHeaderVM.reuseIdentifier, for: indexPath) as? SelectiveHeader
        
        cell?.update(model: availableSectionHeaders[indexPath.section])
        
        return cell ?? SelectiveHeader()
    }
}
