//
//  FavoritesViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/19/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?

    var sourceArray: [[String:String]]?
    var selectedEmojiFavo: Emoji?

    override func viewDidLoad() {
        self.title = "Favorites"
        sourceArray = SecondViewController().loadData()
        tableView?.tableFooterView = UIView()
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sourceArray = SecondViewController().loadData()
        self.tableView?.reloadData()

    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sourceArray?.count)!
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowID", for: indexPath)
        
        if let emojiFavoDict = sourceArray?[indexPath.row] {
            let emoji = Emoji(dictionory: emojiFavoDict as! Dictionary<String, String>)
            if (emoji.title?.characters.count)! > 30 {
                cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:15)
            }
            if (emoji.title?.characters.count)! > 40 {
                cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:13)
            }

            cell.textLabel?.text = emoji.title
            cell.detailTextLabel?.text = emoji.symbol
                return cell
            
        }
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let emojiFavoDict = sourceArray?[indexPath.row] {
            selectedEmojiFavo = Emoji(dictionory: emojiFavoDict as! Dictionary<String, String>)
        }
        performSegue(withIdentifier: "segueFavoDetail", sender: self)
    }
    
   
    //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let emoji = selectedEmojiFavo else {
            return
        }
        
        var secondViewController = segue.destination as! SecondViewController
        secondViewController.flag = 2
        secondViewController.selectedEmojiFavo = emoji
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let selectedEmoji = sourceArray?[indexPath.row]  else {
                return
            }
            if let index = sourceArray?.index(where: { $0 == selectedEmoji }) {
            sourceArray?.remove(at: index)
            SecondViewController().saveDataArray(array: sourceArray)
    
            //Reload tableView
            self.tableView?.reloadData()
        }
        }
    }
    
     func tableView(_ tableView: UITableView, MoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   }
