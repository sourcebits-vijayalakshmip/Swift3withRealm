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
    
}


class Session {
    
    static let shared = Session()
    
    var faction: Faction?
    var quality: Quality?

    
    fileprivate init() {
        
        // Restore the previous session
        
        do {
            let realm = try Realm()

            let predicate = NSPredicate(format: "isMe = true")
            faction = realm.objects(Faction.self).filter(predicate).first
            
        } catch let error as NSError {
            // handle error
            print("Realm error: \(error.description)")
        }
    }
    
    }
