//
//  CellAnimation.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/25/21.
//

import UIKit

extension UICollectionViewCell {
    func fadeInAnimation(location: Int) {
    self.alpha = 0
         UIView.animate(
             withDuration: 0.8,
             delay: 0.00 * Double(location),
             animations: {
                self.alpha = 1
         })
    }
}
