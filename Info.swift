//
//  Info.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 13/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class Info: Object, Mappable  {
    
    
    dynamic var factionArray: [String] = []
    dynamic var qualityArray: [String] = []

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        
        factionArray <- map["factions"]
        qualityArray <- map["qualities"]

    }

    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
