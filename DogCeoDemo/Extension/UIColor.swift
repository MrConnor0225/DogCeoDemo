//
//  UIColor.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/18.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var cleanedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            cleanedHexString = cleanedHexString.replacingOccurrences(of: "#", with: "")

            var rgbValue: UInt64 = 0
            Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
