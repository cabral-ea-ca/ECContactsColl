//
//  HCContact.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

import UIKit
import Contacts

class HCContact{
    static let keystoFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                              CNContactFamilyNameKey as CNKeyDescriptor,
                              CNContactOrganizationNameKey as CNKeyDescriptor,
                              CNContactImageDataKey as CNKeyDescriptor,
                              CNContactImageDataAvailableKey as CNKeyDescriptor]
    private var contact = CNContact()
    private var strKey = String()
    var contactImage: UIImage?
    
    
    init( contact:CNContact){
        self.contact = contact
        if( !contact.familyName.isEmpty ){
            strKey = contact.familyName
        }
        else if( !contact.givenName.isEmpty ){
            strKey = contact.givenName
        }
        else if( !contact.organizationName.isEmpty ){
            strKey = contact.organizationName
        }
    }
    
    public var name: String{
        get{
            if( contact.givenName != "" || contact.familyName != "" ){
                return "\(contact.givenName) \(contact.familyName)"
            }
            else{
                return contact.organizationName
            }
        }
    }
    
    public func fetchImageIfNeeded(){
        if let imageData = contact.imageData, contactImage == nil {
            contactImage = UIImage(data: imageData)
        }
    }
    
    public func startingLettertoIdx() -> Int{
        let lettersInAlphabet = 26
        var RtnValue:Int = 26 // 0..25 : "A".."Z", 26:"Unknown prefix"
        let smallA = "a"
        if( strKey != "" ){
            RtnValue = Int(strKey.firstLetterToIdx() - smallA.firstLetterToIdx())
            if( RtnValue < 0 || RtnValue >= lettersInAlphabet){
                RtnValue = 26
            }
        }
        return RtnValue
    }
}


