//
//  Session.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 10/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import Foundation

import RealmSwift


struct CardsInfo {
    
    var factionsCards: [String]
    var APIKEYVALUE = ["X-Mashape-Key":"xd90O4gfMdmshyLxk5cBvl44PPHlp1ONA3kjsnFFOAtbQnoshp"]

}


class Session {
    
    static let shared = Session()
    
    var cards: Cards?
    var cardsInfo: CardsInfo?
    
    fileprivate init() {
        
        // Restore the previous session
        
        do {
            let realm = try Realm()

            let predicate = NSPredicate(format: "isMe = true")
            cards = realm.objects(Cards.self).filter(predicate).first
            
        } catch let error as NSError {
            // handle error
            print("Realm error: \(error.description)")
        }
    }
    
    }
