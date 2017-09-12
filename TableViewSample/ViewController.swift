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
       setupDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setupDataSource() {
       emojis.append(Emoji(title: "Grinning Face", description: "A face with a big open (grinning) mouth, showing teeth. Differs only slightly from the Smiling Face With Open Mouth And Smiling Eyes by the fact that these eyes are small circles, instead of the emoji-style smiling eyes.", symbol: "😀"))
        emojis.append(Emoji(title: "Face With Tears of Joy", description: "A laughing emoji which at small sizes is often mistaken for being tears of sadness. This emoji is laughing so much that it is crying tears of joy /n This emoji has been in the top 10 most popular emojis on Emojipedia for all of 2015, and was deemed the 2015 word of the year by the Oxford English Dictionary", symbol: "😂"))
        emojis.append(Emoji(title: "Speak-No-Evil Monkey", description: "This Speak-No-Evil monkey has hands covering his mouth, as part of the proverb “see no evil, hear no evil, speak no evil”.", symbol: "🙊"))
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

