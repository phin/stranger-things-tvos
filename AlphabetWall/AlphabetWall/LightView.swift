//
//  LightView.swift
//  AlphabetWall
//
//  Created by Séraphin Hochart on 2016-10-14.
//  Copyright © 2016 Séraphin Hochart. All rights reserved.
//

import UIKit
import QuartzCore

class LightView: UIView {

    private var duration = 0.0
    private var color = UIColor.red
    init(frame: CGRect, color: UIColor, duration: Double) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        alpha = 0.8
        self.clipsToBounds = false
        self.duration = duration
        self.color = color
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupCandle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupCandle() {

        let layerPath = UIBezierPath(ovalIn: self.bounds)
        layerPath.usesEvenOddFillRule = true

        let shadowLayer = CAShapeLayer()
        let fillColor = color
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.path = layerPath.cgPath
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowRadius = 20.0
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.fillRule = kCAFillRuleEvenOdd

        self.layer.addSublayer(shadowLayer)

        // Center white light
        let whiteWidth = self.bounds.width * 0.5
        let frame =  CGRect(
            origin: CGPoint(x: self.bounds.width * 0.5 - whiteWidth * 0.5, y: self.bounds.width * 0.5 - whiteWidth * 0.5),
            size: CGSize(width: whiteWidth, height: whiteWidth))
        let shadowLayerCenter = RadialGradient()

        shadowLayerCenter.frame = frame
        shadowLayerCenter.innerColor = UIColor.white
        shadowLayerCenter.outerColor = color

        self.addSubview(shadowLayerCenter)
    }
}

class RadialGradient: UIView {
    var innerColor = UIColor.white
    var outerColor = UIColor.red

    override func draw(_ rect: CGRect) {
        self.isOpaque = false
        var point = CGPoint.zero
        point.x = rect.width * 0.5
        point.y = rect.height * 0.5

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let radius = rect.width - 20.0
        let colors = [innerColor.cgColor, outerColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1])
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter: point, startRadius: 0, endCenter: point, endRadius: radius, options: .drawsAfterEndLocation)
    }
}
