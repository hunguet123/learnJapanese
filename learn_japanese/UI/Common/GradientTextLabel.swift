//
//  GradientTextLabel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/7/24.
//

import UIKit

class GradientTextLabel: UILabel {
    private var gradientColors: [CGColor] = [
        UIColor.red.cgColor,
        UIColor.blue.cgColor
    ]
    
    func setGradientColors(_ colors: [UIColor?]) {
        self.gradientColors = colors.map { $0?.cgColor ?? UIColor.clear.cgColor }
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = gradientColors
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let textLayer = CATextLayer()
        textLayer.frame = self.bounds
        textLayer.string = self.text
        textLayer.font = self.font
        textLayer.fontSize = self.font.pointSize
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.mask = textLayer
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        self.layer.addSublayer(gradientLayer)
    }
}
