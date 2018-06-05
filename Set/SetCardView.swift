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
            cornerRadius: (bounds.width+bounds.height)*0.04)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel(frame: bounds)
        label.text = textRepresentation
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)



        //TODO: would need another subview for multiple shapes??
//        let figure = Figure(frame: bounds, color: color, shape: shape, shading: shading)
//        addSubview(figure)
    }

    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        let oneThirdWidth = rect.width/3
        let oneThirdHeight = rect.height/3
        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: 0, y: 0))
        figure.addLine(to: CGPoint(x: rect.width, y: oneThirdHeight))
        figure.addLine(to: CGPoint(x: oneThirdWidth*2, y: oneThirdHeight*2))
        figure.addLine(to: CGPoint(x: rect.width, y: rect.height))
        figure.addLine(to: CGPoint(x: 0, y: oneThirdHeight*2))
        figure.addLine(to: CGPoint(x: oneThirdWidth, y: oneThirdHeight))
        figure.close()
        return figure
    }

    private func drawOval(in rect: CGRect) -> UIBezierPath {
        let figure = UIBezierPath(ovalIn: rect)
        return figure
    }

    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let halfWidth = rect.width/2
        let halfHeight = rect.height/2

        let figure = UIBezierPath()
        figure.move(to: CGPoint(x: halfWidth, y: 0))
        figure.addLine(to: CGPoint(x: rect.width, y: halfHeight))
        figure.addLine(to: CGPoint(x: halfWidth, y: rect.height))
        figure.addLine(to: CGPoint(x: 0, y: halfHeight))
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

    class Figure: UIView {
        var color: UIColor
        var shape: Shape
        var shading: Shading
        var context = UIGraphicsGetCurrentContext()

        private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
            let oneThirdWidth = rect.width/3
            let oneThirdHeight = rect.height/3
            let figure = UIBezierPath()
            figure.move(to: CGPoint(x: 0, y: 0))
            figure.addLine(to: CGPoint(x: rect.width, y: oneThirdHeight))
            figure.addLine(to: CGPoint(x: oneThirdWidth*2, y: oneThirdHeight*2))
            figure.addLine(to: CGPoint(x: rect.width, y: rect.height))
            figure.addLine(to: CGPoint(x: 0, y: oneThirdHeight*2))
            figure.addLine(to: CGPoint(x: oneThirdWidth, y: oneThirdHeight))
            figure.close()
//            figure.lineWidth = lineWidth

            return figure
        }

        private func drawOval(in rect: CGRect) -> UIBezierPath {
            let figure = UIBezierPath(ovalIn: rect)
//            figure.lineWidth = lineWidth
            return figure
        }

        private func drawDiamond(in rect: CGRect) -> UIBezierPath {
            let halfWidth = rect.width/2
            let halfHeight = rect.height/2

            let figure = UIBezierPath()
            figure.move(to: CGPoint(x: halfWidth, y: 0))
            figure.addLine(to: CGPoint(x: rect.width, y: halfHeight))
            figure.addLine(to: CGPoint(x: halfWidth, y: rect.height))
            figure.addLine(to: CGPoint(x: 0, y: halfHeight))
            figure.close()
//            figure.lineWidth = lineWidth
            return figure
        }

        override func draw(_ rect: CGRect) {
            var figure: UIBezierPath {
                switch shape {
                case .squiggle: return drawSquiggle(in: rect)
                case .oval: return drawOval(in: rect)
                case .diamond: return drawDiamond(in: rect)
                }
            }
            figure.addClip()

            color.setFill()
            color.setStroke()

            switch shading {
            case .solid: figure.fill()
            case .open: figure.stroke()
            case .striped: addSubview(StripedFillView(frame: CGRect(x: 0, y: 0, width: rect.size.width/2, height: rect.size.height)))
            }

            figure.addClip()
        }

        init(frame: CGRect, color: UIColor, shape: Shape, shading: Shading) {
            self.color = color
            self.shape = shape
            self.shading = shading
            super.init(frame: frame)
            self.isOpaque = false
            self.backgroundColor = UIColor.clear
            self.contentMode = .redraw
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    class StripedFillView: UIView {
        override func draw(_ rect: CGRect) {
            let stripe = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
            #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1).setFill()
            stripe.stroke()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.isOpaque = false
            self.backgroundColor = UIColor.clear
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    /*
    class StripedFillView: UIView {
        override func draw(_ rect: CGRect) {
            let color1 = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let color2 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

            let context = UIGraphicsGetCurrentContext()

            UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), false, 0.0)
            let color1Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 10, height: 10))
            color1.setFill()
            color1Path.fill()

            let color2Path = UIBezierPath(rect: CGRect(x: 10, y: 0, width: 10, height: 10))
            color2.setFill()
            color2Path.fill()

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            UIColor(patternImage: image!).setFill()
            CGContext.fillPath(context)
        }
    }
    */
}

extension SetCardView {
    var lineWidth: CGFloat {
        return 3.0
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
