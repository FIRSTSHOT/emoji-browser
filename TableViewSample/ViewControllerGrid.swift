//
//  ViewControllerGrid.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/21/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class  ViewControllerGrid:  UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sectionsEmojis: [EmojiCategory] = []
    var selectedEmoji: Emoji?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Grid"
        collectionView.dataSource = self
        parseJSON()
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
                    self.collectionView?.reloadData()
                })
                
            }
        }
        task.resume()
        
    }
}

class  collectioEmojiCell: UICollectionViewCell {
    
    @IBOutlet weak var labelEmoji: UILabel!
}

class collectioEmojiHeader: UICollectionReusableView {
    
    @IBOutlet weak var labelHeader: UILabel!
}

extension ViewControllerGrid: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = sectionsEmojis[section]
        if let items = category.items {
            return items.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellId", for: indexPath) as! collectioEmojiCell
        let category = sectionsEmojis[indexPath.section]
        guard let items = category.items else { return cell }
    
        if let emoji = items[indexPath.row] as? Emoji {
            cell.labelEmoji.text = emoji.symbol
        }
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "headerSectionId",for: indexPath) as! collectioEmojiHeader
            let category = sectionsEmojis[indexPath.section]
            if let title = category.category  {
                headerView.labelHeader.text = title
            }else{
                headerView.labelHeader.text =  ""
            }
            //headerView.textLabel.text = shops[indexPath.section]["shop_name"] as? String
            
            return headerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
}
