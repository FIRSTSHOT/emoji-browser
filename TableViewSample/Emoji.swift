//
//  Emoji.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import Foundation

struct Emoji {
    
    let title: String?
    let description: String?
    let symbol: String?
    
    init(title: String?, description: String?, symbol: String?) {
        self.title = title
        self.description = description
        self.symbol = symbol
    }
    
    init(dictionory: Dictionary<String, String>) {
        self.title = dictionory["title"]
        self.symbol = dictionory["symbol"]
        self.description = dictionory["description"]

    }
    
    func toDictionary() -> [String:String] {
        return ["title" : title!, "description" : description!, "symbol": symbol!]
    }
    
}
