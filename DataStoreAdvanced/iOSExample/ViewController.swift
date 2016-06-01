//
//  ViewController.swift
//  iOSExample
//
//  Created by Christopher Miller on 31/05/16.
//
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var reelCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = Reel.count()
        reelCountLabel.text = "\(count) Reels Loaded"
    }
}

