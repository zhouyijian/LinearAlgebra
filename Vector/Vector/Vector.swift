//
//  Vector.swift
//  Vector
//
//  Created by 周一见 on 2020/7/31.
//  Copyright © 2020 周一见. All rights reserved.
//

import Foundation
struct Vector {
    
    let values: [Double]
    
    init(array: [Double]) {
        self.values = array
    }
    
    init(zeroDim: Int) {
        self.init(array: Array.init(repeating: 0, count: zeroDim))
    }
    
    func getLen() -> Int {
        return values.count
    }
    
    func getItem(index: Int) -> Double {
        return values[index]
    }
    
}

precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}

infix operator •: DotProductPrecedence

//MARK: - 规范化
extension Vector {
    func norm() -> Double {
        var sum = 0.0
        for i in self.values {
            sum += (i * i)
        }
        return sum.squareRoot()
    }
    
    func normalize() -> Vector {
        if self.norm() < epsilon {
            fatalError("Can not normalize zero vector")
        } else {
            return self / self.norm()
        }
    }
}

// MARK: - Operators
extension Vector {
    static func + (left: Vector, right: Vector) -> Vector {
        assert(left.getLen() == right.getLen())
        var sum = Array.init(repeating: 0.0, count: left.getLen())
        for i in 0..<sum.count {
            sum[i] = left.getItem(index: i) + right.getItem(index: i)
        }
        return Vector(array: sum)
    }
    
    static func - (left: Vector, right: Vector) -> Vector {
        assert(left.getLen() == right.getLen())
        var sum = Array.init(repeating: 0.0, count: left.getLen())
        for i in 0..<sum.count {
            sum[i] = left.getItem(index: i) - right.getItem(index: i)
        }
        return Vector(array: sum)
    }
    
    static prefix func - (vector: Vector) -> Vector {
        var sum = Array.init(repeating: 0.0, count: vector.getLen())
        for i in 0..<sum.count {
            sum[i] = -vector.getItem(index: i)
        }
        return Vector(array: sum)
    }
    
    static func * (left: Double, right: Vector) -> Vector {
        var sum = Array.init(repeating: 0.0, count: right.getLen())
        for i in 0..<sum.count {
            sum[i] = left * right.getItem(index: i)
        }
        return Vector(array: sum)
    }
    
    //这里用到了上面重载的*运算
    static func * (left: Vector, right: Double) -> Vector {
        return right * left
    }
    
    static func / (left: Vector, right: Double) -> Vector {
        return left * (1 / right)
    }
    
    static func • (left: Vector, right: Vector) -> Double {
        assert(left.getLen() == right.getLen())
        var sum = 0.0
        for i in 0..<left.getLen() {
            sum += left.getItem(index: i) * right.getItem(index: i)
        }
        return sum
    }
}

extension Vector: Equatable {
    static func == (left: Vector, right: Vector) -> Bool {
        assert(left.getLen() == right.getLen())
        for i in 0..<left.getLen() {
            if left.getItem(index: i) != right.getItem(index: i) {
                return false
            }
        }
        return true
    }
}

extension Vector: CustomStringConvertible {
    var description: String {
        var des = "("
        for (index, e) in values.enumerated() {
            if index == values.count - 1 {
                des += "\(e)"
            } else {
                des += "\(e), "
            }
        }
        des += ")"
        return des
    }

}


