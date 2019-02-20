//
//  SetCardView.swift
//  Set
//
//  Created by Иван Лузин on 03.06.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    var shape: Shape? { didSet { setNeedsDisplay() } }
    var color: UIColor? = UIColor.white { didSet { setNeedsDisplay() } }
    var shading: Shading? { didSet { setNeedsDisplay() } }
    var count: Int? { didSet { setNeedsDisplay() } }
    var identifier: Int? { didSet { setNeedsDisplay() } }

    var isSelected: Bool = false { didSet { setNeedsDisplay() } }

    var textualRepresentation: String = ""

    enum matchedState {
        case matched
        case mismatched
        case idle
    }

    var isMatched: matchedState = .idle

    private(set) var gridBounds: CGRect?

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(
            roundedRect: bounds.insetBy(dx: (bounds.width+bounds.height)*0.008, dy: (bounds.width+bounds.height)*0.008),
            cornerRadius: paddingRatio)
        roundedRect.addClip()

        switch isMatched {
        case .matched: Color.confirm.setFill()
        case .mismatched: Color.denied.setFill()
        case .idle: UIColor.white.setFill()
        }

        roundedRect.fill()

        if isSelected == true {
            roundedRect.lineWidth = lineWidth * 2
            Color.outline.setStroke()
            roundedRect.stroke()
        }

        var figureColor = color ?? UIColor.white

        figureColor.setFill()
        figureColor.setStroke()

        let paddedRect = bounds.insetBy(dx: paddingRatio, dy: paddingRatio)
        var isHorizontal: Bool {
            return paddedRect.size.height < paddedRect.size.width
        }
        var minimalSideSize: CGFloat {
            let widestSide = isHorizontal ? paddedRect.size.width : paddedRect.size.height
            let shortestSide = isHorizontal ? paddedRect.size.height : paddedRect.size.width
            let oneThird = widestSide / 3
            return oneThird > shortestSide ? shortestSide : oneThird
        }
        var shortSide = minimalSideSize / 2
        let boundsCenter = CGPoint(
            x: paddedRect.origin.x + paddedRect.width / 2,
            y: paddedRect.origin.y + paddedRect.height / 2)

        for amount in 1...(count ?? 1) {
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            var horizontalPosition: CGFloat {
                if !isHorizontal { return boundsCenter.x - minimalSideSize / 2 }
                switch count {
                case 1: return boundsCenter.x - minimalSideSize / 2
                case 2: return boundsCenter.x - minimalSideSize * (CGFloat(amount-1))
                case 3: return boundsCenter.x - minimalSideSize * 1.5 + minimalSideSize * (CGFloat(amount-1))
                default: return boundsCenter.x
                }
            }
            var verticalPosition: CGFloat {
                if isHorizontal { return boundsCenter.y - shortSide / 2 }
                switch count {
                case 1: return boundsCenter.y - shortSide / 2
                case 2: return boundsCenter.y - shortSide * (CGFloat(amount-1))
                case 3: return boundsCenter.y - shortSide * 1.5 + shortSide * (CGFloat(amount-1))
                default: return boundsCenter.y
                }
            }
            var drawArea = CGRect(x: horizontalPosition,
                                  y: verticalPosition,
                                  width: minimalSideSize,
                                  height: shortSide)
                .insetBy(dx: minimalSideSize*0.04,
                         dy: minimalSideSize*0.04)

            if let figureShape = shape, let figureShading = shading {
                var figure: UIBezierPath {
                    switch figureShape {
                    case .diamond: return drawDiamond(in: drawArea)
                    case .oval: return drawOval(in: drawArea)
                    case .squiggle: return drawSquiggle(in: drawArea)
                    }
                }

                figure.addClip()

                if figureShading == .striped {
                    let line = UIBezierPath()
                    line.lineWidth = lineWidth/2
                    for singleLine in stride(from: Float(rect.minX), to: Float(rect.maxX), by: Float(lineWidth*1.5)) {
                        line.move(to: CGPoint(x: rect.minX+CGFloat(singleLine), y: rect.minY))
                        line.addLine(to: CGPoint(x: rect.minX+CGFloat(singleLine), y: rect.maxY))
                    }
                    line.stroke()
                }

                context?.restoreGState()

                if !(shading! == .open) {
                    figure.stroke()
                } else {
                    figure.fill()
                }
            }
        }
    }

    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        let oneThirdX = rect.minX + (rect.width)/3
        let twoThirdX = rect.minX + (rect.width)/1.5
        let ratio = (rect.size.width + rect.size.height) * 0.1

        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: oneThirdX, y: rect.minY))
        figure.addCurve(to: CGPoint(x: twoThirdX, y: rect.midY-ratio),
                        controlPoint1: CGPoint(x: twoThirdX-ratio, y: rect.minY),
                        controlPoint2: CGPoint(x: oneThirdX+ratio, y: rect.midY-ratio))
        figure.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                        controlPoint1: CGPoint(x: rect.maxX-ratio, y: rect.midY-ratio),
                        controlPoint2: CGPoint(x: twoThirdX+ratio, y: rect.minY))
        figure.addCurve(to: CGPoint(x: twoThirdX, y: rect.maxY),
                        controlPoint1: CGPoint(x: rect.maxX+ratio, y: rect.midY),
                        controlPoint2: CGPoint(x: rect.maxX-ratio, y: rect.maxY))
        figure.addCurve(to: CGPoint(x: oneThirdX, y: rect.midY+ratio),
                        controlPoint1: CGPoint(x: twoThirdX-ratio, y: rect.maxY),
                        controlPoint2: CGPoint(x: twoThirdX-ratio, y: rect.midY+ratio))
        figure.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                        controlPoint1: CGPoint(x: rect.minX+ratio, y: rect.midY+ratio),
                        controlPoint2: CGPoint(x: oneThirdX-ratio, y: rect.maxY))
        figure.addCurve(to: CGPoint(x: oneThirdX, y: rect.minY),
                        controlPoint1: CGPoint(x: rect.minX-ratio, y: rect.midY-ratio),
                        controlPoint2: CGPoint(x: rect.midX-ratio, y: rect.minY))
        figure.close()
        figure.lineJoinStyle = .round
        figure.lineWidth = lineWidth

        return figure
    }

    private func drawOval(in rect: CGRect) -> UIBezierPath {
        let figure = UIBezierPath(roundedRect: rect, cornerRadius: 14.0)
        figure.lineWidth = lineWidth
        return figure
    }

    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: rect.midX, y: rect.minY))
        figure.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        figure.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        figure.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        figure.close()
        figure.lineWidth = lineWidth
        return figure
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.contentMode = .redraw
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetCardView {
    private var lineWidth: CGFloat {
        return paddingRatio*0.15
    }

    private var paddingRatio: CGFloat {
        return (bounds.width+bounds.height)*0.04
    }

    private var verticalPadding: CGFloat {
        return 10.0
    }

    private var horizontalPadding: CGFloat {
        return 10.0
    }

    enum Shape {
        case diamond, squiggle, oval
    }

    enum Shading {
        case solid, striped, open
    }

    enum Count: Int {
        case one = 1, two, three
    }

    struct Color {
        private(set) static var red = #colorLiteral(red: 1, green: 0.233825969, blue: 0.4614375874, alpha: 1)
        private(set) static var green = #colorLiteral(red: 0.4215252755, green: 0.7735763008, blue: 0.2147679271, alpha: 1)
        private(set) static var purple = #colorLiteral(red: 0.5041278131, green: 0.3157204778, blue: 0.7055400032, alpha: 1)
        private(set) static var outline = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        private(set) static var confirm = #colorLiteral(red: 0.664418355, green: 1, blue: 0.8068742257, alpha: 1)
        private(set) static var denied = #colorLiteral(red: 1, green: 0.6733556793, blue: 0.6629678455, alpha: 1)
    }
}
