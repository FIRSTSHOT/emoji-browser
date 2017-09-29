//
//  SecondViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit
import Kanna

var filePath: String {
    // creates a directory to where we are saving it
    let manager = FileManager.default
    //this returns an array of urls from our documentDirectory and we take the first path
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    //creates a new path component and creates a new file called "Data" which is where we will store our Data array.
    return (url!.appendingPathComponent("dataEmojiFavo").path)
}

class SecondViewController: UIViewController {
    
    let urlEmoji: String = "https://emojipedia.org/"
    var descriptionString: String?
    
    var selectedEmoji: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    var selectedEmojiFavo: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    var sourceArray: [[String:String]]?
    var sourceArray2: [[String:String]]?

    
    var flag: Int?
    
    @IBOutlet weak var labelDescrp: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    @IBOutlet weak var buttonAddFAvo: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceArray = loadData()
        
       
        if sourceArray != nil {
            if (sourceArray?.contains(where: { $0["symbol"] == selectedEmoji?.symbol }))!{
                buttonAddFAvo.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            }
        }
        guard let emoji = selectedEmoji else { return }
       
        labelSymbol.text = emoji.symbol
        if flag == 1 {
            
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
        } else if flag == 2 {
            self.labelDescrp.text = emoji.description
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

extension UIViewController {
    func loadData() -> [[String : String]]? {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [[String : String]] {
            return ourData
        }
        return nil
    }
    func saveDataArray(array: [[String:String]]?){
        NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
    }
}

extension SecondViewController {
    
    
    @IBAction func addToFavorites(sender: UIBarButtonItem) {

        if sourceArray != nil {
        if (sourceArray?.contains(where: { $0["symbol"] == selectedEmoji?.symbol }))! {
            sourceArray?.remove(at: (sourceArray?.index(where: { $0["symbol"] == selectedEmoji?.symbol }))!)
            saveDataArray(array: sourceArray)
            sender.tintColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        } else {
            if !(self.labelDescrp.text?.isEmpty)!{
                sender.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                let emojiFavo = Emoji(title: title!, description: descriptionString!, symbol: labelSymbol.text!)
                saveData(item: emojiFavo)
        }
        }
      }else if !(self.labelDescrp.text?.isEmpty)!{
            sender.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            let emojiFavo = Emoji(title: title!, description: descriptionString!, symbol: labelSymbol.text!)
            saveData(item: emojiFavo)
        }
    }
    
    
    func saveData(item: Emoji) {
        let dict = item.toDictionary()
        if sourceArray != nil {
            if !(sourceArray?.contains(where: { $0 == dict }))!{
                sourceArray?.append(dict)
                NSKeyedArchiver.archiveRootObject(sourceArray, toFile: filePath)
            }
            
        }else if sourceArray?.append(dict) == nil
        {   sourceArray = [dict]
            NSKeyedArchiver.archiveRootObject(sourceArray, toFile: filePath)
            
        }
        
        }
}


    
