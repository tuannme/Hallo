//
//  Utils.swift
//  Hallo
//
//  Created by Dreamup on 7/20/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static func getKeyboardHeight() -> CGFloat{
        
        var keyboardHeight:CGFloat = 224
        
        switch UIScreen.main.bounds.width {
        case 320:
            keyboardHeight = 224
        case 375:
            keyboardHeight = 225
        case 414:
            keyboardHeight = 236
        default:
            break
        }
        
        return keyboardHeight
    }
    
}
