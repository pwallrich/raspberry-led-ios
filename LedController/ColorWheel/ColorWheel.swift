//
//  ColorWheel.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit

struct ColorPath {
    var Path:UIBezierPath
    var Color:UIColor
}

@IBDesignable
class ColorWheel: UIControl {

    private var paths = [ColorPath]()

    // indicator
    private var indicatorLayer: CAShapeLayer!
    private var point: CGPoint!
    private var indicatorCircleRadius: CGFloat = 12.0
    private var indicatorColor: CGColor = UIColor.lightGray.cgColor
    private var indicatorBorderWidth: CGFloat = 2.0
    @objc dynamic
    var currentColor: UIColor = UIColor.clear
    private var radius: CGFloat = 0

    @IBInspectable var size: CGSize = CGSize.zero { didSet { setNeedsDisplay() }}
    @IBInspectable var sectors: Int = 360 { didSet { setNeedsDisplay() }}

    override init(frame: CGRect) {
        super.init(frame: frame)
        center = super.center
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        contentMode = .redraw
        // init the indicator
        indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = indicatorColor
        indicatorLayer.lineWidth = indicatorBorderWidth
        indicatorLayer.fillColor = nil
        self.layer.addSublayer(indicatorLayer)
    }


    func colorAtPoint(point: CGPoint) -> UIColor {
        for colorPath in 0..<paths.count {
            if paths[colorPath].Path.contains(point) {
                return paths[colorPath].Color
            }
        }
        return UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        radius = CGFloat(min(bounds.size.width, bounds.size.height) / 2.0) * 0.90
        let angle: CGFloat = CGFloat(2.0) * CGFloat(Double.pi) / CGFloat(sectors)
        var colorPath = ColorPath(Path: UIBezierPath(), Color: UIColor.clear)

        UIGraphicsGetCurrentContext()

        UIColor.white.setFill()
        UIRectFill(frame)

        for sector in 0..<sectors {
            let center = self.center
            colorPath.Path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: CGFloat(sector) * angle,
                endAngle: (CGFloat(sector) + CGFloat(1)) * angle,
                clockwise: true)
            colorPath.Path.addLine(to: center)
            colorPath.Path.close()

            let color = UIColor(
                hue: CGFloat(sector) / CGFloat(sectors),
                saturation: 1,
                brightness: 1,
                alpha: 1)
            color.setFill()
            color.setStroke()

            colorPath.Path.fill()
            colorPath.Path.stroke()
            colorPath.Color = color

            paths.append(colorPath)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 18.0
        touchHandler(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 12.0
        touchHandler(touches)
    }

    func touchHandler(_ touches: Set<UITouch>) {
        // Set reference to the location of the touch in member point
        if let touch = touches.first {
            point = touch.location(in: self)
        }

        let indicator = getIndicatorCoordinate(point)
        point = indicator.point
        currentColor = colorAtPoint(point: CGPoint(x: point.x, y: point.y))
        // Draw the indicator
        drawIndicator()
    }

    func drawIndicator() {
        // Draw the indicator
        if (point != nil) {
            indicatorLayer.path = UIBezierPath(roundedRect: CGRect(x: point.x-indicatorCircleRadius, y: point.y-indicatorCircleRadius, width: indicatorCircleRadius*2, height: indicatorCircleRadius*2), cornerRadius: indicatorCircleRadius).cgPath
            indicatorLayer.fillColor = self.currentColor.cgColor
        }
    }

    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel
        let wheelLayerCenter: CGPoint = self.center
        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx*dx + dy*dy)
        var outputCoord: CGPoint = coord

        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }

        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 10
        var isCenter = false
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }

        return (outputCoord, isCenter)
    }

}
