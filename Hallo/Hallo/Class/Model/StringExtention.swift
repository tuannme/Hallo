//
//  StringExtention.swift
//  Hallo
//
//  Created by Dreamup on 7/20/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func isEmtyContent() -> Bool {
        let check = self.replacingOccurrences(of: " ", with: "")
        return check.characters.count > 0 ? false : true
    }
    
}
