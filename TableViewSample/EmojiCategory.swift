//
//  EmojiCategory.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/14/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import Foundation

struct EmojiCategory {
    var category: String?
    var items: [Emoji]?
    
    init(category: String, items: [Emoji]? ) {
        self.category = category
        self.items = items
    }
}
