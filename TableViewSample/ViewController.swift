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
    
    @IBAction func buttonGrid(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueGrid", sender: self)
    }
    
    var sectionsEmojis: [EmojiCategory] = []
    var selectedEmoji: Emoji?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Emoji"
        parseJSON()
        
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
                        
                        if let existingIndex = self.sectionsEmojis.index(where:
                            {
                            if let title = $0.category {
                                return title == category
                            }
                            return false })
                        {
                            
                            var existingCategory = self.sectionsEmojis[existingIndex]
                            
                            if var items = existingCategory.items as? [Emoji] {
                                items.append(emoji)
                                existingCategory.items = items
                                self.sectionsEmojis[existingIndex] = existingCategory
                            }
                        } else {
                            //let newCateg = ["title": category, "items": [emoji] ] as [String : Any]
                            let newCateg = EmojiCategory(category: category, items: [emoji])
                            self.sectionsEmojis.append(newCateg)
                        }
                        
                        
                        
                                        }
                }
                DispatchQueue.main.async(execute: {
                    self.tableView?.reloadData()
                })
                
                            }
        }
        task.resume()
        
    }
    
    
}

class EmojiTableCell : UITableViewCell {
    @IBOutlet weak var labelEmojiSymbol: UILabel!
    
}
//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsEmojis.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = sectionsEmojis[section]
        if let items = category.items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sampleID", for: indexPath) as! EmojiTableCell
        
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items else { return cell }
        
        
        if let emoji = items[indexPath.row] as? Emoji {
//            if (emoji.title?.characters.count)! > 30 {
//              cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:15)
//            }
//            if (emoji.title?.characters.count)! > 40 {
//                cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:13)
//            }
//            cell.textLabel?.text = emoji.title
//            cell.detailTextLabel?.text = emoji.symbol
        cell.labelEmojiSymbol.text = emoji.symbol
        }
        return cell
    }
    //size of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items  else { return  }

        selectedEmoji = items[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = sectionsEmojis[section]
        
            if let title = category.category  {
                return title
            }else{
        return ""
        }
            return ""
    }
    
    //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
        guard let emoji = selectedEmoji else {
            return
        }
        
        let secondViewController = segue.destination as! SecondViewController
        secondViewController.flag = 1
        secondViewController.selectedEmoji = emoji
    }
    }
}
