//
//  Card.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible, Equatable {
    var description: String {
        return "Card with \(count) \(shading) \(color) \(shape)\(count.rawValue > 1 ? "s" : "")"
    }

    var color: Color
    var shape: Shape
    var count: Count
    var shading: Shading

    enum Color: CustomStringConvertible {
        var description: String {
            switch self {
            case .firstColor: return "red"
            case .secondColor: return "yellow"
            case .thirdColor: return "blue"
            }
        }

        case firstColor, secondColor, thirdColor
        static var all = [Color.firstColor, .secondColor, .thirdColor]
    }
    enum Shape: CustomStringConvertible {
        var description: String {
            switch self {
            case .firstShape: return "triangle"
            case .secondShape: return "circle"
            case .thirdShape: return "square"
            }
        }
        case firstShape, secondShape, thirdShape
        static var all = [Shape.firstShape, .secondShape, .thirdShape]
    }
    enum Count: Int, CustomStringConvertible {
        var description: String {
            return String(self.rawValue)
        }
        case firstNumber = 1, secondNumber, thirdNumber
        static var all = [Count.firstNumber, .secondNumber, .thirdNumber]
    }
    enum Shading: CustomStringConvertible {
        var description: String {
            switch self {
            case .firstShading: return "solid"
            case .secondShading: return "outlined"
            case .thirdShading: return "striped"
            }
        }

        case firstShading, secondShading, thirdShading
        static var all = [Shading.firstShading, .secondShading, .thirdShading]
    }
}


