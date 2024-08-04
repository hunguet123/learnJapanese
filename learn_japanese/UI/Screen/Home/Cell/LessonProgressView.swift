//
//  LessonProgressView.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 4/8/24.
//

import UIKit

class LessonProgressView: UIView {
    
    var totalDots = 8
    var completedDots = 4
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        
        context.setLineWidth(20)
        context.setStrokeColor(AppColors.goldenPoppy?.cgColor ?? UIColor.clear.cgColor)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.strokePath()
        
        // Draw the inner circle
        let innerCirclePath = UIBezierPath(arcCenter: center, radius: radius - 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.white.setFill()
        innerCirclePath.fill()
        
        // Draw the dots
        let angleIncrement = CGFloat.pi * 2 / CGFloat(totalDots)
        let dotRadius: CGFloat = 10
        for i in 0..<totalDots {
            let angle = angleIncrement * CGFloat(i) - CGFloat.pi / 2
            let dotCenter = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let dotPath = UIBezierPath(arcCenter: dotCenter, radius: dotRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            
            if i < completedDots {
                AppColors.shockingPink?.setFill()
            } else {
                AppColors.philippineSliver?.setFill()
            }
            
            dotPath.fill()
        }
        
        // Draw the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32, weight: .bold),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        let text = "\(completedDots)/\(totalDots)"
        let textRect = CGRect(x: center.x - 50, y: center.y - 25, width: 100, height: 50)
        text.draw(in: textRect, withAttributes: attributes)
    }
}
