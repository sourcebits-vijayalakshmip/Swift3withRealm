//
//  Cards.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 12/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper




class Cards: Object, Mappable {
    
    
     var factionsArray = List<Cards>()

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
       // var factionsArray = NSArray(obj)
        factionsArray <- map["factions"]
    }
    
       // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}



