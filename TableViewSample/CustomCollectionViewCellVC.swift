//
//  CustomCollectionViewCellVC.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/29/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class CustomCollectionViewCellVC: UICollectionViewCell {
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        textLabel.font = UIFont.boldSystemFont(ofSize: 80)
       
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
