//
//  Extensions.swift
//  memo
//
//  Created by Eric Giannini on 6/19/17.
//  Copyright © 2017 Unicorn Mobile, LLC. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func prepend(value: Element) {
        
        self.insert(value, at: 0)
    }
}
