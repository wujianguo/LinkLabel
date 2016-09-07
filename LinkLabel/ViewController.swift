//
//  ViewController.swift
//  LinkLabel
//
//  Created by wujianguo on 16/9/6.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: LinkLabel!
    @IBOutlet weak var label2: LinkLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "hello my friend @user #hello #you are big #so#sns"
        label.adapters = [LinkAdapter.hashtagLinkAdapter()]
        label.text = text

        label2.text = text
        let link1 = LinkItem(adapter: LinkAdapter.hashtagLinkAdapter(), value: nil, text: "my", range: NSRange(location: 6, length: 2))
        label2.linkItems = [link1]
        label2.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

