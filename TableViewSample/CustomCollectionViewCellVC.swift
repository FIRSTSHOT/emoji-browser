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
    
        
        textLabel = UILabel()
        
       
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    
    override func layoutSubviews() {
        textLabel.frame = contentView.bounds
        let size = contentView.frame.width / 2
        textLabel.font = UIFont.boldSystemFont(ofSize: size)
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
