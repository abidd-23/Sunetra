//
//  UIColor+Hex.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 27/05/24.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        // Check if the hex string starts with #
        if hex.hasPrefix("#") {
            // Extract the hex color
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                // Scan the hex color code and convert it to UInt64
                if scanner.scanHexInt64(&hexNumber) {
                    // Extracting individual color components from the hex number
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
