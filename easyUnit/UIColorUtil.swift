//
//  UIColorUtil.swift
//  easyUnit
//
//  Created by Wu on 4/3/16.
//  Copyright © 2016 Jiadong Wu. All rights reserved.
//

import UIKit

class UIColorUtil {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func blueRangeUIColor (blueValue: Double) -> UIColor {
        let tmp = (blueValue <= 500) ? (1000 - blueValue)/1000.0 : 0.5
        return UIColor(
            red: CGFloat(1.0),
            green: CGFloat(1.0),
            blue: CGFloat(tmp),
            alpha: CGFloat(1.0)
        )
    }
}