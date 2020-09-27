//
//  TimelineItem.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 20/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit

public class TimelineItem: TimelineSourceElement {
    public let id: UUID
    
    public var subelements: [TimelineSourceElement]? = nil
    
    public var milestoneShape: TimelineCard.ItemShape
    public var title: NSAttributedString?
    public var subtitle: NSAttributedString?
    public var customView: UIView?
    public var icon: UIImage?
    
    public init(title: NSAttributedString, subtitle: NSAttributedString,
         shape: TimelineCard.ItemShape = .circle, icon: UIImage? = nil) {
        
        id = UUID()
        
        self.title = title
        self.subtitle = subtitle
        self.milestoneShape = shape
        self.icon = icon
    }
    
    public init(customView: UIView, shape: TimelineCard.ItemShape = .circle, icon: UIImage? = nil) {
        id = UUID()
        
        self.milestoneShape = shape
        self.icon = icon
        self.customView = customView
    }
}

/// Extended version of `TimelineItem` that supports children.
public class TimelineItemGroup: TimelineItem {
    public init(title: NSAttributedString, subtitle: NSAttributedString, items: [TimelineItem],
         shape: TimelineCard.ItemShape = .circle, icon: UIImage? = nil) {
        
        super.init(title: title, subtitle: subtitle, shape: shape, icon: icon)
        
        self.subelements = items
    }
    
    public init(customView: UIView, items: [TimelineItem], shape: TimelineCard.ItemShape = .circle, icon: UIImage? = nil) {
        
        super.init(customView: customView, shape: shape, icon: icon)
        
        self.subelements = items
    }
}
