//
//  Note.swift
//  memo
//
//  Created by Eric Giannini on 6/18/17.
//  Copyright © 2017 Unicorn Mobile, LLC. All rights reserved.
//

import Foundation

// a class for a note
class Note: NSObject, NSCoding {
    
    // the properties of a note
    var body: String
    var title: String
    let timeCreated: Date
    var timeLastEdited: Date
    
    // initializer for a note
    init (body: String, title: String, timeCreated: Date = Date(), timeLastEdited: Date) {
        
        self.body = body
        self.title = title
        self.timeCreated = timeCreated
        self.timeLastEdited = timeLastEdited
        
    }
    
    // a convenient initializer for a note
    convenience init(body: String, title: String) {
        let now = Date()
        self.init(body: body, title: title, timeCreated: now, timeLastEdited: now)
    }
    
    // a convenient initializer for a note
    convenience init(body: String) {
        let title: String
        if body.characters.count <= 10 {
            title = body
        } else {
            let endIndex = body.index(body.startIndex, offsetBy: 10)
            title = body.substring(to: endIndex)
        }
        
        self.init(body: body, title: title)
        
    }
    
    // req. implementation for NSCoding's init(coder:)
    required init?(coder unarchiver: NSCoder) {
        
        guard let body = unarchiver.decodeObject(forKey: "body") as? String,
            let title = unarchiver.decodeObject(forKey: "title") as? String,
            let timeCreated = unarchiver.decodeObject(forKey: "timeCreated") as? Date,
            let timeLastEdited = unarchiver.decodeObject(forKey: "timeLastEdited") as? Date
            else { return nil } // otherwise
        
        self.body = body
        self.title = title
        self.timeCreated = timeCreated
        self.timeLastEdited = timeLastEdited
    }
    
    //req. implementation for NSCoding's encode(with:)
    func encode(with coder: NSCoder) {
        
        coder.encode(self.body, forKey: "body")
        
        coder.encode(self.title, forKey: "title")
        
        coder.encode(self.timeCreated, forKey: "timeCreated")
        
        coder.encode(self.timeLastEdited, forKey: "timeLastEdited")
        
    }
    
    var asData: Data {
        return NSKeyedArchiver.archivedData(withRootObject:self)
    }
    
    // decode data into note
    static func fromData(data: Data) -> Note? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Note
    }
    
    
}

// auxilliary functionality
extension Note {
    
    func createdAtTheSameTime(as note: Note) -> Bool {
        return note.timeCreated == self.timeCreated
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.body == rhs.body &&
            lhs.title == rhs.title &&
            lhs.timeCreated == rhs.timeCreated &&
            lhs.timeLastEdited == rhs.timeLastEdited
    }
    
    
}

// auxilliary functionality (i.e., saving & loading)
extension Note {
    
    private static var notesKey: String {
        return "memo"
    }
    
    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    // save notes in an inst. of NSArray
    static func save(notes: [Note]) {
        
        let nsArray = notes as NSArray
        let data = NSKeyedArchiver.archivedData(withRootObject: nsArray)
        
        userDefaults.set(data, forKey: notesKey)
        
    }
    
    // load notes from inst. of NSArray
    static func loadNotes() -> [Note] {
        // check whether notes in u. def.
        guard let data = userDefaults.data(forKey: notesKey) else {
            print ("Notes are missing from User Defaults.")
            return []
        }
        
        // if in u. def., decode as inst. of NSArray
        guard let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray else {
            print("Could not decode data from User Defaults as an Array")
            return []
        }
        // if decoded, return inst. of NSArray w/ notes
        if let notes = array as? [Note] {
            notes.forEach({print( $0.body, $0.title)})
            
            return notes
        } else {
            print("Could not note decode array as type Note")
            return []
        }
    }
    
}

