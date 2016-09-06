//
//  LinkLabel.swift
//  LinkLabel
//
//  Created by wujianguo on 16/9/6.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

struct LinkAdapter {

    static func hashtagLinkAdapter() -> LinkAdapter {
        return LinkAdapter()
    }

    static func userHandleLinkAdapter() -> LinkAdapter {
        return LinkAdapter()
    }

    var linkTransformHandler: ((String) -> AnyObject)?
    var regex: NSRegularExpression!
//    var matches: [NSTextCheckingResult] = []
    var normalAttributes: [String: AnyObject] = [:]
    var highlightedAttributes: [String: AnyObject] = [:]

    func match(text: String) -> [LinkItem] {
        return []
    }
}

//extension Array where Element: LinkAdapter {
//
//    func match(text: String) -> [LinkItem] {
//        return []
//    }
//
//}

struct LinkItem {
    var adapter: LinkAdapter
    var value: AnyObject
    var text: String
//    var range: Range<String.Index>
    var result: NSTextCheckingResult
}

protocol LinkLabelDelegate: class {
    func linkLabel(label: LinkLabel, didClick linkItem: LinkItem)
}

class LinkLabel: UILabel {

    weak var delegate: LinkLabelDelegate?

    var adapters: [LinkAdapter] = []
    var linkItems: [LinkItem] = []
}
