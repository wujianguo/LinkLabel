//
//  LinkLabel.swift
//  LinkLabel
//
//  Created by wujianguo on 16/9/6.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

struct LinkAdapter {

    static func defaultNormalLinkAttributes() -> [String: AnyObject] {
        return [NSForegroundColorAttributeName: UIColor.blueColor()]
    }

    static func defaultHighlightedLinkAttributes() -> [String: AnyObject] {
        return [:]
    }

    static func hashtagLinkAdapter(normalLinkAttributes: [String: AnyObject] = LinkAdapter.defaultNormalLinkAttributes(),
                                   highlightedLinkAttributes: [String: AnyObject] = LinkAdapter.defaultHighlightedLinkAttributes(),
                                   linkTransformHandler: ((String) -> Any)? = nil) -> LinkAdapter {
        return LinkAdapter(linkTransformHandler: linkTransformHandler,
                           regex: try! NSRegularExpression(pattern: "[#]\\w\\S*\\b", options: []),
                           normalLinkAttributes: normalLinkAttributes,
                           highlightedLinkAttributes: highlightedLinkAttributes)
    }

    static func userHandleLinkAdapter(normalLinkAttributes: [String: AnyObject] = LinkAdapter.defaultNormalLinkAttributes(),
                                      highlightedLinkAttributes: [String: AnyObject] = LinkAdapter.defaultHighlightedLinkAttributes(),
                                      linkTransformHandler: ((String) -> Any)? = nil) -> LinkAdapter {
        return LinkAdapter(linkTransformHandler: linkTransformHandler,
                           regex: try! NSRegularExpression(pattern: "[@]\\w\\S*\\b", options: []),
                           normalLinkAttributes: normalLinkAttributes,
                           highlightedLinkAttributes: highlightedLinkAttributes)
    }

    var linkTransformHandler: ((String) -> Any)?
    var regex: NSRegularExpression
    var normalLinkAttributes: [String: AnyObject] = LinkAdapter.defaultNormalLinkAttributes()
    var highlightedLinkAttributes: [String: AnyObject] = LinkAdapter.defaultHighlightedLinkAttributes()

    func match(text: String) -> [LinkItem] {
        var result = [LinkItem]()
        let nsString = text as NSString
        let matches = regex.matchesInString(text, options: [], range: NSRange(location: 0, length: nsString.length))
        for match in matches {
            let matchText = nsString.substringWithRange(match.range)
            let value = linkTransformHandler?(matchText)
            let item = LinkItem(adapter: self, value: value, text: matchText, range: match.range)
            result.append(item)
        }
        return result
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
    var value: Any?
    var text: String
//    var result: NSTextCheckingResult
    var range: NSRange
}

protocol LinkLabelDelegate: class {
    func linkLabel(label: LinkLabel, didClick linkItem: LinkItem)
}


class LinkLabel: UILabel {

    weak var delegate: LinkLabelDelegate?
    var adapters: [LinkAdapter] = []
    var linkItems: [LinkItem] = []

    override var text: String? {
        didSet {
            updateUI()
        }
    }


    func updateUI() {
        guard text != nil && text != "" else {
            attributedText = nil
            return
        }
        var items: [LinkItem] = []
        if adapters.count > 0 {
            for adapter in adapters {
                adapter.match(text!)
                items.appendContentsOf(adapter.match(text!))
            }
        } else {
            items = linkItems
        }
        attributedText = attributed(text!, links: items)
    }

    func attributed(text: String, links: [LinkItem]) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        for link in links {
            attributed.addAttributes(link.adapter.normalLinkAttributes, range: link.range)
        }
        return attributed
    }

}
