//
//  Note.swift
//  memo
//
//  Created by Eric Giannini on 6/18/17.
//  Copyright © 2017 Unicorn Mobile, LLC. All rights reserved.
//

import Foundation

class Note: NSObject, NSCoding {
    
    var body: String
    var title: String
    let timeCreated: Date
    var timeLastEdited: Date
    
    init (body: String, title: String, timeCreated: Date = Date(), timeLastEdited: Date)
    
    
}

