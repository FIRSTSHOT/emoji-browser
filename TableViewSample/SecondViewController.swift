//
//  SecondViewController.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/12/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let urlEmoji: String = "https://emojipedia.org/"
    var selectedEmoji: Emoji? {
        didSet {
            title = selectedEmoji?.title
        }
    }
    @IBOutlet weak var webView: UIWebView!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let newUrl = modifyURL(title: title!)
        print(newUrl)
        let url = NSURL (string: newUrl);
        let request = NSURLRequest(url: url! as URL);
        webView.loadRequest(request as URLRequest);
        //guard let emoji = selectedEmoji else { return }
        //labelSymbol.text = emoji.symbol
        //labelDescription.text = emoji.description
    }
    
    func modifyURL(title: String) -> String
    {
        var titleNoEspace = title.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        titleNoEspace = titleNoEspace.replacingOccurrences(of: "&", with: "and", options: .literal, range: nil)
        return urlEmoji + titleNoEspace
    }
    
}
