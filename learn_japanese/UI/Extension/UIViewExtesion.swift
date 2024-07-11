//
//  UIViewExtension.swift
//  viperBase
//
//  Created by Hưng Hà Quang on 9/5/24.
//

import Foundation
import UIKit
public extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            self.layer.borderColor = newValue?.cgColor
        }
        
        get {
            guard let cgcolor = self.layer.borderColor else { return nil }
            return UIColor(cgColor: cgcolor)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }
        
        get {
            return self.layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }
        
        get {
            return self.layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
        
        get {
            return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }
        
        get {
            return self.layer.shadowOpacity
        }
    }
    
    func fitSuperviewConstraint(edgeInset: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let superview = self.superview!
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeInset.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInset.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInset.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -edgeInset.bottom).isActive = true
    }
    
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    static func loadView(fromNib nibName: String, bundle: Bundle = Bundle.main) -> Self? {
        return bundle.loadNibNamed(nibName, owner: nil, options: nil)?.last as? Self
    }
    
    func heightConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self && constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                targetConstraint = constraint
            }
        }
        
        return targetConstraint
    }
    
    func widthConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self && constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                targetConstraint = constraint
            }
        }
        
        return targetConstraint
    }
    
    func setupCornerRadius(topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
        let bezierPath = UIBezierPath(shouldRoundRect: self.bounds,
                                      topLeftRadius: topLeftRadius,
                                      topRightRadius: topRightRadius,
                                      bottomLeftRadius: bottomLeftRadius,
                                      bottomRightRadius: bottomRightRadius)
        
        let shape = CAShapeLayer()
        shape.backgroundColor = UIColor.white.cgColor
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }
    
    static var bottomSafeArea: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
        
        return UIWindow.bottomSafeArea
    }
    
    static var topSafeArea: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
        
        return UIWindow.topSafeArea
    }
    
    func disableInteractiveFor(seconds: Double) {
        self.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
    
    func drawImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}

public extension UIView {
    func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return image
    }
}
