//
//  EmojiViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/28/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class EmojiViewController: UIViewController {
    
     var tableView: UITableView!
     var collectionView: UICollectionView?
    
    var sectionsEmojis: [EmojiCategory] = []
    var selectedEmoji: Emoji?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        parseJSON()
        configureSegmentControl()
        
        
    }
    func changeView(sender : UISegmentedControl)  {
        switch sender.selectedSegmentIndex {
        case 0:
            configureTableView()
        case 1:
            configureCollectionView()
        default:
            configureTableView()
            
        }
    }
    func configureSegmentControl() {
        var segControl = UISegmentedControl(items:["list", "grid"])
        segControl.selectedSegmentIndex = 0
        let frame = UIScreen.main.bounds
        
        segControl.frame = CGRect(x: frame.minX + 30, y: frame.minY + 50, width: frame.width - 50, height: frame.height*0.1)
        segControl.layer.cornerRadius = 5.0
       
        segControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
        configureTableView()
        self.navigationItem.titleView = segControl

    }
    func configureTableView()  {
        
        tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.dataSource = self as UITableViewDataSource
        tableView.delegate = self  as UITableViewDelegate
        self.view.addSubview(tableView)
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
    }
    
    func configureCollectionView()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 90, height: 80)
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(CustomCollectionViewCellVC.self, forCellWithReuseIdentifier: NSStringFromClass(CustomCollectionViewCellVC.self))
        collectionView?.backgroundColor = UIColor.white
        self.view.addSubview(collectionView!)
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })

    }
    
    func parseJSON() {
        
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
//                DispatchQueue.main.async(execute: {
//                    self.collectionView?.reloadData()
//                })
                
            }
        }
        task.resume()
        
    }
}

extension EmojiViewController: UITableViewDelegate, UITableViewDataSource  {
    
   
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath as IndexPath)
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items else { return cell }
        if let emoji = items[indexPath.row] as? Emoji {
        cell.textLabel!.text = emoji.symbol
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:100)
            
        }
        return cell
    }
    
    //size of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
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
    // selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items  else { return  }
        
        selectedEmoji = items[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)
        
    }
    
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // number of item in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let category = sectionsEmojis[section]
        if let items = category.items {
            return items.count
        }
        return 0
    }
    // number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return sectionsEmojis.count
    }
    // add data to cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CustomCollectionViewCellVC.self), for: indexPath) as! CustomCollectionViewCellVC
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items else { return cell }
        
        if let emoji = items[indexPath.row] as? Emoji {
            cell.textLabel.text = emoji.symbol
            //cell.backgroundColor = UIColor(red: 17/255, green: 4/255, blue: 62/255, alpha: 1.0)

            
        }
        return cell
    }
    
    // selected cell segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items else { return }
        selectedEmoji = items[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    // preapre for segue
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


