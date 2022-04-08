//
//  UIView+Extension.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit

extension UIView {
    func removeSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
    func setIsHidden(_ hidden: Bool, animated: Bool) {
        
        var isBecomingVisible: Bool {
            // currently Hidden and becoming visible
            return self.isHidden && !hidden
        }
        
        if animated {
            if isBecomingVisible {
                self.alpha = 0.0
                self.isHidden = false
            }
            
            UIView.animate(withDuration: 0.6, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            }) { (complete) in
                self.isHidden = hidden
            }
        } else {
            self.isHidden = hidden
        }
    }
}
