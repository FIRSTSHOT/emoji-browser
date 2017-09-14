//
//  ViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView?
    var emojis: [Emoji?] = []
    
    var selectedEmoji: Emoji?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "My Table"
        parseJSON()
        //setupDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func parseJSON(){
        
        let session = URLSession.shared
        let url = URL(string: "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json")!
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data
            {
                var json: [Any]?
                do {
                    json = try JSONSerialization.jsonObject(with: data) as? [Any]
                    //print(json)
                } catch {
                    print(error)
                }
                guard let dictionary = json else { return }
                for item in dictionary {
                    guard let item1 = item as? [String:Any] else { return }
                    
                    if let title = item1["description"] as? String,
                        let symbol = item1["emoji"] as? String,
                        let category = item1["category"] as? String {
                        let emoji = Emoji(title: title, description: category, symbol: symbol)
                        self.emojis.append(emoji)
                    }
                }
                print(self.emojis.count)
                DispatchQueue.main.async(execute: {
                    self.tableView?.reloadData()
                })
            }
        }
        task.resume()
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleID", for: indexPath)
        if let emoji = emojis[indexPath.row] as? Emoji {
            if (emoji.title?.characters.count)! > 30 {
              cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:15)
            }
            if (emoji.title?.characters.count)! > 40 {
                cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:13)
            }
            cell.textLabel?.text = emoji.title
            cell.detailTextLabel?.text = emoji.symbol
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedEmoji = emojis[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "First" : "Second"
    }
    
    //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let emoji = selectedEmoji else {
            return
        }
        
        let secondViewController = segue.destination as! SecondViewController
        secondViewController.selectedEmoji = emoji
    }
}
