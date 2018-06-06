//
//  SetCardView.swift
//  Set
//
//  Created by Иван Лузин on 03.06.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    var textRepresentation: String = "" { didSet { setNeedsDisplay() } }

    var shape: Shape!
    var color: UIColor!
    var shading: Shading!
    var count: Int!

    var gridBounds: CGRect?

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(
            roundedRect: bounds.insetBy(dx: (bounds.width+bounds.height)*0.008, dy: (bounds.width+bounds.height)*0.008),
            cornerRadius: paddingRatio)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        let paddedRect = bounds.insetBy(dx: paddingRatio, dy: paddingRatio)
        let debugLine = UIBezierPath(rect: paddedRect)
        UIColor.cyan.setStroke()
        debugLine.stroke()

        var isHorizontal: Bool {
            return paddedRect.size.height < paddedRect.size.width
        }

        var minimalSideSize: CGFloat {
            let widestSide = isHorizontal ? paddedRect.size.width : paddedRect.size.height
            let shortestSide = isHorizontal ? paddedRect.size.height : paddedRect.size.width
            let oneThird = widestSide / 3
            return oneThird > shortestSide ? shortestSide : oneThird
        }

        let boundsCenter = CGPoint(
            x: paddedRect.origin.x + paddedRect.width / 2,
            y: paddedRect.origin.y + paddedRect.height / 2)

        for amount in 1...count {
            var horizontalPosition: CGFloat {
                if !isHorizontal {
                    return boundsCenter.x - minimalSideSize / 2
                }
                switch count {
                case 1: return boundsCenter.x - minimalSideSize / 2
                case 2: return boundsCenter.x - minimalSideSize * (CGFloat(amount-1))
                case 3: return boundsCenter.x - minimalSideSize * 1.5 + minimalSideSize * (CGFloat(amount-1))
                default:
                    fatalError("Count can't be more than 3, current value: \(count)")
                }
            }

            var verticalPosition: CGFloat {
                if isHorizontal {
                    return boundsCenter.y - minimalSideSize / 2
                }
                switch count {
                case 1: return boundsCenter.y - minimalSideSize / 2
                case 2: return boundsCenter.y - minimalSideSize * (CGFloat(amount-1))
                case 3: return boundsCenter.y - minimalSideSize * 1.5 + minimalSideSize * (CGFloat(amount-1))
                default:
                    fatalError("Count can't be more than 3, current value: \(count)")
                }
            }

            let drawArea = CGRect(x: horizontalPosition, y: verticalPosition, width: minimalSideSize, height: minimalSideSize).insetBy(dx: minimalSideSize*0.04, dy: minimalSideSize*0.04)

            var debugBounds = UIBezierPath(rect: drawArea)
            UIColor.cyan.setStroke()
            debugBounds.stroke()

            var figure: UIBezierPath {
                switch shape! {
                case .diamond: return drawDiamond(in: drawArea)
                case .oval: return drawOval(in: drawArea)
                case .squiggle: return drawSquiggle(in: drawArea)
                }
            }

            color.setFill()
            color.setStroke()

            figure.fill()
            figure.stroke()
        }

//        subviews.forEach { $0.removeFromSuperview() }

//        let label = UILabel(frame: bounds)
//        label.text = textRepresentation
//        label.numberOfLines = 0
//        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
//        addSubview(label)
    }

    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        let oneThirdWidth = rect.width/3
        let oneThirdHeight = rect.height/3
        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        figure.addLine(to: CGPoint(x: rect.width, y: oneThirdHeight))
        figure.addLine(to: CGPoint(x: oneThirdWidth*2, y: oneThirdHeight*2))
        figure.addLine(to: CGPoint(x: rect.width, y: rect.height))
        figure.addLine(to: CGPoint(x: rect.origin.x, y: oneThirdHeight*2))
        figure.addLine(to: CGPoint(x: oneThirdWidth, y: oneThirdHeight))
        figure.close()
        return figure
    }

    private func drawOval(in rect: CGRect) -> UIBezierPath {
//        let figure = UIBezierPath(ovalIn: rect)
//        return figure
        let smallRect = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height/4, width: rect.size.width, height: rect.size.height/2)

        let figure = UIBezierPath(roundedRect: smallRect, cornerRadius: 14.0)
        return figure
    }

    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let halfWidth = rect.size.width/2
        let halfHeight = rect.size.height/2

        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: halfWidth, y: rect.origin.y))
        figure.addLine(to: CGPoint(x: rect.size.width, y: halfHeight))
        figure.addLine(to: CGPoint(x: halfWidth, y: rect.size.height))
        figure.addLine(to: CGPoint(x: rect.origin.x, y: halfHeight))
        figure.close()
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
    var lineWidth: CGFloat {
        return 3.0
    }

    var paddingRatio: CGFloat {
        return (bounds.width+bounds.height)*0.04
    }

    var verticalPadding: CGFloat {
        return 10.0
    }

    var horizontalPadding: CGFloat {
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
        static var red = #colorLiteral(red: 1, green: 0.2043219659, blue: 0.1832181957, alpha: 1)
        static var green = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static var purple = #colorLiteral(red: 0.7055400032, green: 0.05926413926, blue: 0.5150790473, alpha: 1)
    }
}
