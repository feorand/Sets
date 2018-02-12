//
//  UICardView.swift
//  Sets
//
//  Created by Pavel Prokofyev on 23.01.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

@IBDesignable
class UICardView: UIView {
    
    @IBInspectable var number: Int = 1
    
    var symbol: Symbol = .circle
    
    var shading: Shading = .solid
    
    @IBInspectable var color: UIColor = .red
    
    var isSelected = false { didSet { setNeedsDisplay() } }
    
    var isBack = false { didSet { setNeedsDisplay() }}
    
    init(frame: CGRect, number: Int, symbol: Symbol, shading: Shading, color: UIColor) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color

        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var symbolDesign: Int {
        get { return symbol.rawValue }
        set { symbol = Symbol(rawValue: newValue) ?? Symbol.circle }
    }
    
    @IBInspectable var stripingDesign: Int {
        get { return shading.rawValue }
        set { shading = Shading(rawValue: newValue) ?? Shading.solid }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isBack == true {
            let cardBackImage = UIImage(named: "card-back")!
            cardBackImage.draw(in: bounds)
        } else {
            drawCard()
            drawAllSymbols()
        }
    }
    
    private func drawCard() {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 3, dy: 3), cornerRadius: 5)
        
        isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill() : #colorLiteral(red: 1, green: 0.8297816798, blue: 0.567272414, alpha: 1).setFill()
        path.fill()
        path.addClip()
    }
    
    private func drawBounds() {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 3, dy: 3), cornerRadius: 5)
        path.lineWidth = bounds.width / 5
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
        path.stroke()
    }
    
    private func getPathForSymbol(inRect rect: CGRect) -> UIBezierPath {
        let centerX = rect.minX + rect.width / 2
        let centerY = rect.minY + rect.height / 2

        func circlePath() -> UIBezierPath {
            let center = CGPoint(x: centerX, y: centerY)
            let radius = rect.width / 2
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            return path
        }
        
        func diamondPath() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: centerX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: centerY))
            path.addLine(to: CGPoint(x: centerX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: centerY))
            path.addLine(to: CGPoint(x: centerX, y: rect.minY))
            return path
        }
        
        func trianglePath() -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: centerX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: centerX, y: rect.minY))
            return path
        }
        
        switch symbol {
        case .circle:
            return circlePath()
        case .diamond:
            return diamondPath()
        case .triangle:
            return trianglePath()
        }
    }
    
    private func getPathForAllSymbols() -> UIBezierPath {
        let measure = min(bounds.width, bounds.height)
        let symbolAspectRatio: CGFloat = 0.33
        let distanceBetweenSymbols = CGFloat(9 - 2 * number) / CGFloat(6 + 6 * number) * measure

        let path = UIBezierPath()
        
        for i in 1...number {
            let yCoord = distanceBetweenSymbols +
                CGFloat(symbolAspectRatio * measure + distanceBetweenSymbols) * CGFloat(i - 1)
            let rect = CGRect(x: measure * symbolAspectRatio,
                              y: yCoord,
                              width: measure * symbolAspectRatio,
                              height: measure * symbolAspectRatio)
            let pathPart = getPathForSymbol(inRect: rect)
            path.append(pathPart)
        }
            
        return path
    }
    
    private func addShading(toPath path: UIBezierPath) {
        switch shading {
        case .striped:
            for i in stride(from: 0, to: bounds.height, by: 5) {
                path.move(to: CGPoint(x: i, y: 0.0))
                path.addLine(to: CGPoint(x: i, y: bounds.height))
            }
            path.lineWidth = 1
            color.setStroke()
            path.stroke()
        case .open:
            path.lineWidth = 5
            color.setStroke()
            path.stroke()
        case .solid:
            color.setStroke()
            color.setFill()
            path.stroke()
            path.fill()
        }
    }
    
    private func drawAllSymbols() {
        let path = getPathForAllSymbols()
        path.addClip()
        addShading(toPath: path)
    }
}

extension UICardView {
    enum Symbol: Int {
        case diamond, circle, triangle
    }
    
    enum Shading: Int {
        case solid, striped, open
    }
}

extension UICardView: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copyCard = UICardView(frame: frame, number: number, symbol: symbol, shading: shading, color: color)
        copyCard.isSelected = isSelected
        return copyCard
    }
}
