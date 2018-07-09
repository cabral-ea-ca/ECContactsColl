//
//  ViewController.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal let contactStore = CNContactStore()
    internal var contactList:[HCContact] = []
    
    internal func retrieveContacts( contactStore: CNContactStore ){
        let containerID = contactStore.defaultContainerIdentifier()
        let predicate   = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        
        do {
            contactList = try contactStore.unifiedContacts(matching: predicate, keysToFetch: HCContact.keystoFetch).map { contact in
                return HCContact(contact: contact)
            }
        }
        catch {
            print( error )
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for visibleCell in collectionView.visibleCells {
            guard let contactCell = visibleCell as? ContactCollectionViewCell
                else { continue }
            
            if editing {
                UIView.animate(withDuration: 0.2, delay: 0, options:
                    [.curveEaseOut], animations: {
                        contactCell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options:
                    [.curveEaseOut], animations: {
                        contactCell.backgroundColor = .clear
                }, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            retrieveContacts( contactStore: contactStore )
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        case .denied,
             .notDetermined,
             .restricted:
            contactStore.requestAccess(for: .contacts, completionHandler: requestAccessHandler)
        }
        let doubleTapped = UITapGestureRecognizer(target: self, action: #selector(doubleTappedHandler))
        doubleTapped.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTapped)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
