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
    
    let urlEmoji: String = "https://emojipedia.org/"
    var descriptionString: String?
    var selectedEmoji: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    
    @IBOutlet weak var labelDescrp: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Title",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        
        guard let emoji = selectedEmoji else { return }
        labelSymbol.text = emoji.symbol
        //labelDescrp.text = parsHTML(title: title!)
        
        DispatchQueue.global(qos: .background).async {
            self.descriptionString = self.parsHTML(title: self.title!)
            DispatchQueue.main.async {
                guard self.descriptionString != "" else
                {   self.labelSymbol.text = "X"
                    self.labelDescrp.text = " "
                    return
                }
                self.labelDescrp.text = self.descriptionString
            }
        }
        
        
    }
    
    func rightButtonAction(sender: UIBarButtonItem){
        print("add to favorite")
    }

    
    func modifyURL(title: String) -> String
    {
        
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
                // delete empty line
                var linesArray: [String] = []
                showString?.enumerateLines { line, _ in linesArray.append(line) }
                showString = linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
                                }
            
        }
        if showString != nil{
            // delete text start with "Copy and paste this emoji"
           
            guard let range = showString?.range(of: "Copy and paste this emoji") else {
                return showString!
            }
            
            showString = showString?.substring(with:(showString?.startIndex)!..<range.lowerBound)
            return showString!
            }
        else {showString = ""
               return showString!}
    }
    
    

}




    
