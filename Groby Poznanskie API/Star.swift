//
//  Star.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 16/06/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit
import Foundation

/**
 Drawing Star for favorite section
*/
class Star: UIView {
    
    //MARK: - Private variables
    private var starContainer: UIView!
    private var starLayer: CAShapeLayer!
    private var fill = false
    private let starColor = UIColor.init(colorLiteralRed: 242/255, green: 219/255, blue: 106/255, alpha: 0.0)

    
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initAll(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initAll(frame)
    }
    
    
    //MARK: - Public methods
    /**
     Toggle star fill with default animation
     */
    func toggleFill() {
        CATransaction.begin()
        //CATransaction.setAnimationDuration(1)
        CATransaction.setDisableActions(false)
        
        self.fillStar(!self.fill)
        CATransaction.commit()
    }
    
    /**
     Set star fill without animation
     
     - parameter fill: Specifies whether star to have color
     */
    func set(fill: Bool) {
        CATransaction.begin()
        //CATransaction.setAnimationDuration(0)
        CATransaction.setDisableActions(true)
        
        self.fillStar(fill)
        CATransaction.commit()
    }
    
    /**
     Rotate star
     
     - parameter degree: For how many degree rotate star
     */
    func rotateStar(forDegree degree: CGFloat) {
        self.rotateStar(forRadian: degree2radian(degree))
    }
    
    /**
     Rotate star
     
     - parameter radian: For how many radian rotate star
     */
    func rotateStar(forRadian radian: CGFloat) {
        let transform = self.starContainer.transform
        self.starContainer.transform = transform.rotated(by: radian)
    }
    
    
    //MARK: - Private methods
    private func initAll(_ frame: CGRect) {
        self.drawStar(frame)
    }
    
    private func fillStar(_ fill: Bool) {
        self.starLayer.fillColor = self.starColor.withAlphaComponent(fill ? 1.0 : 0.0).cgColor
        self.fill = fill
    }
    
    private func addAnimation(forLayer layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "fillColor.alpha")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.add(animation, forKey: "animate")
    }
    
    private func drawStar(_ frame: CGRect) {
        let starPath = self.starPath(x: frame.size.width/2, y: frame.size.height/2, radius: 10, sides: 5, pointyness: 1.75)
        self.starLayer = self.createLayer(forPath: starPath, color: UIColor.black.cgColor)
        
        self.starContainer = self.createStarContainer()
        self.addSubview(self.starContainer)
        let constraints = self.createConstraints(self.starContainer)
        self.addConstraints(constraints)
        
        self.starContainer.layer.addSublayer(self.starLayer)
        self.rotateStar(forDegree: -17)
    }
    
    private func createStarContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }
    
    private func createConstraints(_ view: UIView) -> [NSLayoutConstraint] {
        let leadingConstraint = NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        let equalWidthConstraint = NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let equalHeightConstraint = NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)
        
        let constraints = [leadingConstraint, equalWidthConstraint, topConstraint, equalHeightConstraint]
        return constraints
    }
    
    private func degree2radian(_ a: CGFloat) -> CGFloat {
        return .pi * a/180
    }
    
    private func polygonPointArray(sides:Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        var points:[CGPoint] = []
        for i in 0...sides {
            let xPoint = x - radius * cos(angle * CGFloat(sides-i) + degree2radian(adjustment))
            let yPoint = y - radius * sin(angle * CGFloat(sides-i) + degree2radian(adjustment))
            points.append(CGPoint(x: xPoint, y: yPoint))
        }
        return points
    }
    
    private func starPath(x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, pointyness: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let points = polygonPointArray(sides: sides, x: x, y: y, radius: radius)
        let adjustment = 360/sides/2
        let points2 = polygonPointArray(sides: sides, x: x, y: y, radius: radius*pointyness, adjustment:CGFloat(adjustment))
        path.move(to: points[0])
        for i in 0...sides {
            path.addLine(to: points2[i])
            path.addLine(to: points[i])
        }
        path.closeSubpath()
        
        return path
    }
    
    private func createLayer(forPath path: CGPath, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path
        layer.lineWidth = 1
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
    
    private func createLinePath(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        path.close()
        return path
    }
    
}
