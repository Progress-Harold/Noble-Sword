//
//  CGRect+Ext.swift
//  Noble Sword
//
//  Created by Lee Davis on 5/8/21.
//

import UIKit



extension CGRect {
    func reverseSize() -> CGRect {
        let currentRect = self
        
        return CGRect(x: 0,
                      y: 0,
                      width: currentRect.height,
                      height: currentRect.width)
    }
}


