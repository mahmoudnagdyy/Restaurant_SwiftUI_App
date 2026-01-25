//
//  Double.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 22/01/2026.
//

import Foundation


extension Double {
    
    
    func doubleToStringPrice() -> String {
        return "$" + String(format: "%.2f", self)
    }
    
}
