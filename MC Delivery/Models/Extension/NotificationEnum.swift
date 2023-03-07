//
//  NotificationEnum.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/7/23.
//

import Foundation

extension Notification.Name: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}
