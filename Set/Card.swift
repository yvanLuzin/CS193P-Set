//
//  Card.swift
//  Set
//
//  Created by Иван Лузин on 15.05.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import Foundation

struct SetProperties {
    enum Feature {
        case color, shape, count, shading
        static var all = [Feature.color, .shape, count, .shading]
    }

    enum Value {
        case first, second, third
        static var all = [Value.first, .second, .third]
    }

    private(set) var feature: Feature
    private(set) var value: Value
}

struct Card: Hashable {
    var hashValue: Int { return identifier }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private var color: SetProperties
    private var shape: SetProperties
    private var shading: SetProperties
    private var count: SetProperties
    private var identifier: Int

    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init(colorValue: SetProperties.Value, shapeValue: SetProperties.Value, shadingValue: SetProperties.Value, countValue: SetProperties.Value) {
        self.color = SetProperties(feature: .color, value: colorValue)
        self.shape = SetProperties(feature: .shape, value: shapeValue)
        self.shading = SetProperties(feature: .shading, value: shadingValue)
        self.count = SetProperties(feature: .count, value: countValue)

        self.identifier = Card.getUniqueIdentifier()
    }

    subscript (property: SetProperties.Feature) -> SetProperties.Value {
        switch property {
        case .color: return color.value
        case .shape: return shape.value
        case .shading: return shading.value
        case .count: return count.value
        }
    }
}


extension Card: CustomStringConvertible {
    var description: String {
        var countString: String {
            switch count.value {
            case .first: return "1"
            case .second: return "2"
            case .third: return "3"
            }
        }
        var colorString: String {
            switch color.value {
            case .first: return "red"
            case .second: return "yellow"
            case .third: return "blue"
            }
        }
        var shapeString: String {
            switch shape.value {
            case .first: return "triangle"
            case .second: return "circle"
            case .third: return "square"
            }
        }
        var shadingString: String {
            switch shading.value {
            case .first: return "solid"
            case .second: return "outlined"
            case .third: return "stripped"
            }
        }
        return "\(countString ) \(colorString) \(shadingString) \(shapeString)"
    }
}
