//
//  StringExtensions.swift
//  MerlinForsquare
//
//  Created by Wylan Neely on 12/9/18.
//  Copyright © 2018 Wylan Neely. All rights reserved.
//

import Foundation


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
