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
    var sourceArray: [[String:String]]?
    
    @IBOutlet weak var labelDescrp: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    @IBOutlet weak var buttonAddFAvo: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceArray = loadData()
        if (sourceArray?.contains(where: { $0 == (selectedEmoji?.toDictionary())! }))!{
            buttonAddFAvo.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        guard let emoji = selectedEmoji else { return }
        labelSymbol.text = emoji.symbol
        // background thread
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

extension SecondViewController {
    
    
    @IBAction func addToFavorites(sender: UIBarButtonItem) {
        print("add to favo")
        if sender.tintColor == #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) {
           sourceArray?.remove(at: selectedEmoji?.toDictionary())
        }
        sender.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        let emojiFavo = Emoji(title: title!, description: labelDescrp.text!, symbol: labelSymbol.text!)
        saveData(item: emojiFavo)
        
    }
    
    var filePath: String {
        // creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        //print("this is the url path in the documentDirectory \(url)")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("dataEmojiFavo").path)
    }
    
    func saveData(item: Emoji) {
        let dict = selectedEmoji?.toDictionary()
        if !(sourceArray?.contains(where: { $0 == dict! }))!{
        sourceArray?.append(dict!)
        NSKeyedArchiver.archiveRootObject(sourceArray, toFile: filePath)
        print("data save \(sourceArray?.count) ")
        }
        
    }
    
    func loadData() -> [[String : String]]? {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String : String]] {
            return ourData
        }
        return nil
    }

}


    
