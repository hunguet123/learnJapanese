//
//  DrawingView.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 1/4/25.
//
import UIKit
//import MLKitDigitalInkRecognition

protocol DrawableViewDelegate: AnyObject {
    func didDraw(stroke: [NSValue])
}

class DrawingView: UIView {
    
    weak var delegate: DrawableViewDelegate?
    
    private let path = UIBezierPath()
    private let lineWidth: CGFloat = 10.0
    private let strokeMinPointCount = 3
    
    private var previousPoint = CGPoint.zero
    private var undoPaths = [CGPath]()
    private var currentStroke: NSMutableArray?
    
    private(set) var strokes = [NSMutableArray]()
    var isEmpty: Bool { return path.cgPath.isEmpty }
    
    // Lớp CAShapeLayer để hiển thị đường vẽ
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 8
        
        // Cấu hình shapeLayer
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        layer.addSublayer(shapeLayer)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.stroke()
        path.lineWidth = lineWidth
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        // Lưu lại đường path hiện tại để có thể undo
        undoPaths.append(path.cgPath)
        
        // Bắt đầu đường vẽ mới
        path.move(to: currentPoint)
        
        // Tạo stroke mới
        currentStroke = NSMutableArray()
        currentStroke!.add(NSValue(cgPoint: currentPoint))
        
        previousPoint = currentPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentStroke = currentStroke else { return }
        
        let currentPoint = touch.location(in: self)
        let midPoint = self.midPoint(p0: previousPoint, p1: currentPoint)
        
        // Thêm đường cong vào path
        path.addQuadCurve(to: midPoint, controlPoint: previousPoint)
        
        // Thêm điểm vào stroke hiện tại
        currentStroke.add(NSValue(cgPoint: currentPoint))
        
        previousPoint = currentPoint
        
        // Cập nhật shapeLayer để hiển thị đường vẽ
        shapeLayer.path = path.cgPath
        
        // Cập nhật giao diện
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentStroke = currentStroke else { return }
        
        // Thêm stroke hiện tại vào danh sách strokes
        strokes.append(currentStroke)
        
        // Kiểm tra nếu stroke quá ngắn thì bỏ qua
        if (currentStroke.count < strokeMinPointCount) {
            undo()
        } else {
            // Thông báo cho delegate
            delegate?.didDraw(stroke: currentStroke as! [NSValue])
        }
    }
    
    private func midPoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
        let x = (p0.x + p1.x) / 2
        let y = (p0.y + p1.y) / 2
        return CGPoint(x: x, y: y)
    }
    
    func undo() {
        if (undoPaths.count == 0) {
            return
        }
        
        path.cgPath = undoPaths.popLast()!
        
        if !strokes.isEmpty {
            currentStroke = strokes.popLast()!
        }
        
        previousPoint = path.currentPoint
        
        // Cập nhật shapeLayer
        shapeLayer.path = path.cgPath
        
        self.setNeedsDisplay()
    }
    
    func clear() {
        path.removeAllPoints()
        undoPaths.removeAll()
        strokes.removeAll()
        currentStroke = nil
        
        // Xóa đường vẽ trên shapeLayer
        shapeLayer.path = nil
        
        self.setNeedsDisplay()
    }
    
    // Chuyển đổi các nét vẽ thành định dạng Stroke cho MLKit
//    func getStrokes() -> [Stroke] {
//        return strokes.map { strokePoints in
//            let points = strokePoints.compactMap { ($0 as? NSValue)?.cgPointValue }
//            
//            // Chuyển đổi CGPoint thành StrokePoint
//            let strokePoints = points.enumerated().map { index, point in
//                // Sử dụng index làm timestamp giả lập nếu không có timestamp thực
//                return StrokePoint(x: Float(point.x), y: Float(point.y), t: index)
//            }
//            
//            return Stroke(points: strokePoints)
//        }
//    }
}
