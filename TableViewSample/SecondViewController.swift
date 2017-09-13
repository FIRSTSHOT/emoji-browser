//
//  SecondViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var selectedEmoji: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    
       
    @IBOutlet weak var labelSymbol: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let emoji = selectedEmoji else { return }
        labelSymbol.text = emoji.symbol
        labelDescription.text = emoji.description
    }
    
}
