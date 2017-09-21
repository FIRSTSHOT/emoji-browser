//
//  FavoritesViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/19/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var flagEditButtton = false
    @IBOutlet weak var tableView: UITableView?

    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
    
    @IBAction func edit(_ sender: Any)
    {
        self.tableView?.isEditing = !(tableView?.isEditing)!
        
        switch tableView?.isEditing {
        case true?:
            editButton.title = "Done"
        case false?:
            editButton.title = "Edit"
        
        case .none:
            break
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayEmoji = sourceArray else { return 0 }
        
        return arrayEmoji.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowID", for: indexPath)
        
        if let emojiFavoDict = sourceArray?[indexPath.row] {
            let emoji = Emoji(dictionory: emojiFavoDict )
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
        selectedEmojiFavo = Emoji(dictionory: emojiFavoDict )
        }
        performSegue(withIdentifier: "segueFavoDetail", sender: self)
    }
    // edit Row
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        guard let emojiToMove = sourceArray?[sourceIndexPath.row] else { return }
        sourceArray?.remove(at: sourceIndexPath.row)
        sourceArray?.insert(emojiToMove, at: destinationIndexPath.row)
        SecondViewController().saveDataArray(array: sourceArray)
        self.tableView?.reloadData()
    }
    
//     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
        //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let emoji = selectedEmojiFavo else {
            return
        }
        
        let secondViewController = segue.destination as! SecondViewController
        secondViewController.flag = 2
        secondViewController.selectedEmoji = emoji
        
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
    
   }
