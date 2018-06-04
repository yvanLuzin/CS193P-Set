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

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()

        //TODO: would beed another subview for multiple shapes
        let figure = Figure(frame: bounds, color: color, shape: shape, shading: shading)
        addSubview(figure)

//        let label = UILabel(frame: bounds)
//        label.numberOfLines = 3
//        label.adjustsFontSizeToFitWidth = true
//        label.text = textRepresentation
//        addSubview(label)
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

//    private func configureColor(_ color: SetProperties.Value) -> UIColor {
//        switch color {
//        case .first: return
//        case .second: return
//        case .third: return
//        }
//    }

    class Figure: UIView {
        var color: UIColor?
        var shape: Shape
        var shading: Shading?

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

        override func draw(_ rect: CGRect) {
            var figure: UIBezierPath {
                switch shape {
                case .squiggle: return drawSquiggle(in: rect)
                case .oval: return drawOval(in: rect)
                case .diamond: return drawDiamond(in: rect)
            }
        }

            color?.setFill()
            color?.setStroke()
            figure.lineWidth = 5.0

            if shading == .solid {
                figure.fill()
            } else {
                figure.stroke()
            }

        }

        init(frame: CGRect, color: UIColor, shape: Shape, shading: Shading) {
            self.color = color
            self.shape = shape
            self.shading = shading
            super.init(frame: frame)
            self.isOpaque = false
            self.backgroundColor = UIColor.clear
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension SetCardView {
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
