//
//  StringExt.swift
//  ECContactsColl
//
//  Created by Ryerson Student on 2018-07-05.
//  Copyright © 2018 Ryerson Student. All rights reserved.
//

extension String{
    public func firstLetterToIdx() -> UInt32{
        let firstLetter = String( self[self.startIndex] as Character ).lowercased()
        return firstLetter.unicodeScalars.map { $0.value }.reduce(0, +)
    }
}
