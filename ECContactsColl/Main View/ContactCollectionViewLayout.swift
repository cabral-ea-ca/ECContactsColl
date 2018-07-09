//
//  ContactCollectionViewLayout.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

class ContactsCollectionViewLayout: UICollectionViewLayout {
    private var numberOfItems = 0
    private var numRows = 0
    private var numColumns = 0
    private var itemSize = CGSize(width: 110, height: 90)
    private var itemSpacing: CGFloat = 10
    
    private var layoutAttributes:[UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize{
        let width = CGFloat(numColumns) * itemSize.width + CGFloat(numColumns - 1) * itemSpacing
        let height = CGFloat(numRows) * itemSize.height + CGFloat(numRows - 1) * itemSpacing
        
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        guard let collectionView = collectionView
            else { return }
        let availableHeight = Int(collectionView.bounds.height - itemSpacing)
        let itemHeightForCalculation = Int(itemSize.height + itemSpacing)
        
        numberOfItems = collectionView.numberOfItems(inSection: 0)
        numRows = availableHeight / itemHeightForCalculation
        numColumns = Int(ceil(CGFloat(numberOfItems) / CGFloat(numRows)))
        let heightRemainder = Int((CGFloat(availableHeight) / CGFloat(itemHeightForCalculation)).truncatingRemainder(dividingBy: CGFloat(itemHeightForCalculation))/2)
        print( "prepare called", heightRemainder, numberOfItems, numRows, numColumns)
        layoutAttributes.removeAll()
        
        for itemIndex in 0..<numberOfItems {
            let row = itemIndex % numRows
            let column = itemIndex / numRows
            
            var xPos = column * Int(itemSize.width + itemSpacing)
            if row % 2 == 1 {
                xPos += Int(itemSize.width / 2)
            }
            let yPos = heightRemainder + row * Int(itemSize.height + itemSpacing)
            
            print( "\(itemIndex) -> \(row):\(column) \(xPos):\(yPos)" )
            let index = IndexPath(row: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
            attributes.frame = CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: itemSize.width, height: itemSize.height)
            
            layoutAttributes.append(attributes)
        }
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        
        let availableHeight = newBounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        let possibleRows = Int(availableHeight + itemSpacing) / Int(itemSize.height + itemSpacing)
        
        print( "shouldInvalidateLayout called", newBounds.height, collectionView.contentInset.bottom-collectionView.contentInset.top, possibleRows, numRows )
        return possibleRows != numRows
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { attributes in
            attributes.frame.intersects(rect)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
}
