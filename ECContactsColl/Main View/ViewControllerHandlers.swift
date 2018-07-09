//
//  ViewControllerHandlers.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit

extension ViewController{
    func requestAccessHandler(authorized: Bool, error:Error?){
        print( "requestAccessHandler called", authorized, error ?? "No error" )
        if authorized {
            retrieveContacts( contactStore: contactStore )
        }
        else{
            DispatchQueue.main.async {
                let displayAlert = DisplayAlert()
                displayAlert.showAlertContact(title: "Contacts Settings", message: "Please allow the app to use it", viewController: self)
            }
        }
    }
    
    @IBAction func longPressedHandler(gestureRecognizer:UILongPressGestureRecognizer ){
        print( "longPressedHandler called", gestureRecognizer )
        if isEditing{
            let tappedPt = gestureRecognizer.location(in: collectionView)
            
            guard let  tappedIndexPath = collectionView.indexPathForItem(at: tappedPt),
                let tappedCell =  collectionView.cellForItem(at: tappedIndexPath) else { return }
            
            switch(gestureRecognizer.state) {
            case .began:
                collectionView.beginInteractiveMovementForItem(at: tappedIndexPath)
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                    tappedCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)

            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.location(in: collectionView))
    
            case .ended:
                collectionView.endInteractiveMovement()

            default:
                collectionView.cancelInteractiveMovement()
            }
        }
    }
    
    @IBAction func doubleTappedHandler(gestureRecognizer:UITapGestureRecognizer ){
        print( "doubleTappedHandler called", gestureRecognizer )
        if isEditing && gestureRecognizer.state == .ended{
            let tappedPt = gestureRecognizer.location(in: collectionView)
            
            guard let  tappedIndexPath = collectionView.indexPathForItem(at: tappedPt),
                let tappedCell =  collectionView.cellForItem(at: tappedIndexPath) else { return }
            
            let displayAlert = DisplayAlert()
            displayAlert.showDeleteConfirm(title: "Delete this contact?", message: "Are you sure you want to delete this contact?", tappedIndexPath: tappedIndexPath, tappedCell: tappedCell, viewController: self)
        }
    }
}
