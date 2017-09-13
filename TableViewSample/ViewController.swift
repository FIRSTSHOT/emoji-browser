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
    
    func setupDataSource() {
        emojis.append(Emoji(title: "Grinning Face", description: "A face with a big open (grinning) mouth, showing teeth. Differs only slightly from the Smiling Face With Open Mouth And Smiling Eyes by the fact that these eyes are small circles, instead of the emoji-style smiling eyes.", symbol: "😀"))
        emojis.append(Emoji(title: "Face With Tears of Joy", description: "A laughing emoji which at small sizes is often mistaken for being tears of sadness. This emoji is laughing so much that it is crying tears of joy /n This emoji has been in the top 10 most popular emojis on Emojipedia for all of 2015, and was deemed the 2015 word of the year by the Oxford English Dictionary", symbol: "😂"))
        emojis.append(Emoji(title: "Speak-No-Evil Monkey", description: "This Speak-No-Evil monkey has hands covering his mouth, as part of the proverb “see no evil, hear no evil, speak no evil”.", symbol: "🙊"))
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

