//
//  ViewControllerExt .swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("collectionView: didSelectRowAt called" )
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell, !isEditing
            else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            cell.contactImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                cell.contactImage.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let contactData = contactList.remove(at: sourceIndexPath.row)
        contactList.insert(contactData, at: destinationIndexPath.row)
        print( "\(sourceIndexPath.section):\(sourceIndexPath.row) -> \(destinationIndexPath.section):\(destinationIndexPath.row)" )
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contactCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath) as! ContactCollectionViewCell
        
        let contactData = contactList[indexPath.row]
        contactCell.nameLabel.text = contactData.name
        contactData.fetchImageIfNeeded()
        contactCell.contactImage.image = contactData.contactImage
        
        return contactCell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print( "UICollectionViewDataSourcePrefetching::tableView called" )
        for indexPath in indexPaths {
            let contactData = contactList[indexPath.row]
            contactData.fetchImageIfNeeded()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor((collectionView.bounds.width-2)/3), height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellsPerRow: CGFloat = 3
        
        var varwidthRemainder = collectionView.bounds.width - (cellsPerRow-1)
        print( "collectionView.bounds.width - (cellsPerRow-1)",  varwidthRemainder )
        varwidthRemainder = varwidthRemainder.truncatingRemainder(dividingBy: cellsPerRow)
        print( "truncatingRemainder", varwidthRemainder )
        varwidthRemainder /= (cellsPerRow-1)
        print( "/=", varwidthRemainder )
        
        let widthRemainder = (collectionView.bounds.width -
            (cellsPerRow-1)).truncatingRemainder(dividingBy: cellsPerRow)
            / (cellsPerRow-1)
        print( "widthRemainder", widthRemainder )
        
        return 1 + widthRemainder
    }
}
