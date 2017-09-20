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

    var sourceArray: [[String:String?]]?
    
    override func viewDidLoad() {
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
            cell.textLabel?.text = emoji.title
            cell.detailTextLabel?.text = emoji.symbol
                return cell
            
        }
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
   }
