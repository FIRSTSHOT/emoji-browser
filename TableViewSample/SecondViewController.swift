//
//  SecondViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit
import Kanna

class SecondViewController: UIViewController {
    
    var selectedEmoji: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    
    @IBOutlet weak var labelDescrp: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let emoji = selectedEmoji else { return }
        labelSymbol.text = emoji.symbol
        labelDescrp.text = parsHTML(title: title!)
                }
    }
    
    func modifyURL(title: String) -> String
    {
        let urlEmoji: String = "https://emojipedia.org/"
        var titleNoEspace = title.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        titleNoEspace = titleNoEspace.replacingOccurrences(of: "&", with: "and", options: .literal, range: nil)
        return urlEmoji + titleNoEspace
    }
    
    func parsHTML(title : String) -> String {
        var showString: String?
        let newUrl = modifyURL(title: title)
        print(newUrl)
        let url = NSURL (string: newUrl);
        
        if let doc = HTML(url: url! as URL, encoding: .utf8)
            
            
        {
            for show in doc.css("section[class^='description']") {
                // Strip the string of surrounding whitespace.
                showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                var linesArray: [String] = []
                showString?.enumerateLines { line, _ in linesArray.append(line) }
                
                showString = linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
            }
            
        }
        
        return showString!
        
}
