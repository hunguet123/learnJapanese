//
//  TapableView.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 23/7/24.
//

import UIKit

open class TapableView: UIControl {
    @IBInspectable open var dimAlpha: CGFloat = 0.6
    @IBInspectable open var scaleOnHighlight: CGFloat = 0.8
    
    open var touchInset: UIEdgeInsets = .zero
    private var boundsWhenTouchBegan: CGRect!
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.boundsWhenTouchBegan = self.bounds
        self.animate(alpha: dimAlpha, scale: self.scaleOnHighlight)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animate(alpha: 1, scale: 1)
        
        let location = touches.first!.location(in: self)
        if self.boundsWhenTouchBegan.inset(by: touchInset).contains(location) {
            self.sendActions(for: .touchUpInside)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(alpha: 1, scale: 1)
    }
    
    private func animate(alpha: CGFloat, scale: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = alpha
            self.transform = scale == 1 ? .identity : .init(scaleX: scale, y: scale)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.inset(by: touchInset).contains(point)
    }
}
