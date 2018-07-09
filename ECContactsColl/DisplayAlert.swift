//
//  DisplayAlert.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit
class DisplayAlert{
    private func openURL( urlStr: URL){
        if #available(iOS 10.0, *){
            DispatchQueue.main.async {
                UIApplication.shared.open(urlStr, options: [:], completionHandler: nil )
            }
        }
        else{
            DispatchQueue.main.async {
                UIApplication.shared.openURL(urlStr)
            }
        }
    }
    private func settingContactHandler(alert: UIAlertAction!) {
        print( "DisplayAlert: settingContactHandler called" )
        let urlStr = URL( string: "App-Prefs:root=Privacy&path=CONTACTS" )
        openURL(urlStr: urlStr!)
        justClose(alert: alert)
    }
    
    private func justClose(alert: UIAlertAction!){
        print( "DisplayAlert: justClose called" )
    }
    
    public func showAlertContact( title:String, message:String, viewController : UIViewController){
        print( "DisplayAlert: showAlertContact called" )
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Setting action"), style: .cancel, handler: settingContactHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"), style: .default, handler: justClose ))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    public func showDeleteConfirm( title:String, message:String, tappedIndexPath: IndexPath, tappedCell:UICollectionViewCell, viewController : UIViewController){
        print( "DisplayAlert: showDeleteConfirm called" )
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes"), style: .destructive) { alert in
            let currentVC = viewController as! ViewController
            currentVC.contactList.remove(at: tappedIndexPath.row)
            currentVC.collectionView.deleteItems(at: [tappedIndexPath])
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No"), style: .cancel, handler: justClose ))
        if let popOver = alertController.popoverPresentationController{
            popOver.sourceView = tappedCell
            popOver.sourceRect = CGRect(x: 0, y: 0, width: tappedCell.frame.width/2, height: tappedCell.frame.height)
        }
        viewController.present(alertController, animated: true, completion: nil)
        alertController.view.layoutIfNeeded()
    }
}

