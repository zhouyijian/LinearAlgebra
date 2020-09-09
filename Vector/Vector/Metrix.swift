//
//  Metrix.swift
//  Vector
//
//  Created by 周一见 on 2020/8/3.
//  Copyright © 2020 周一见. All rights reserved.
//

import Foundation

struct Metrix {
    let values: Array<[Double]>
    
    init(metrix: Array<[Double]>) {
        self.values = metrix
    }
    
    ///零矩阵
    init(zeroPos: (Int, Int)) {
        self.init(metrix: Array(repeating: Array(repeating: 0.0, count: zeroPos.1), count: zeroPos.0))
    }
    
    ///单位矩阵
    init(identity: Int) {
        var metrix = Array(repeating: Array(repeating: 0.0, count: identity), count: identity)
        for i in 0..<identity {
            metrix[i][i] = 1
        }
        self.init(metrix: metrix)
    }
    
    func size() -> Int {
        let (r, c) = self.shape()
        return r * c
    }
    
    func row() -> Int {
        return self.shape().0
    }
    
    func col() -> Int {
        return self.shape().1
    }
    
    func shape() -> (Int, Int) {
        return (self.values.count, self.values[0].count)
    }
    
    func rowVector(index: Int) -> Vector {
        return Vector(array: self.values[index])
    }
    
    func colVector(index: Int) -> Vector {
        var colArray = Array<Double>()
        for value in values {
            colArray.append(value[index])
        }
        return Vector(array: colArray)
    }
    
    func getItem(pos: (Int, Int)) -> Double {
        return self.values[pos.0][pos.1]
    }
    
    ///转置矩阵
    func T() -> Metrix {
        var t = Array(repeating: Array(repeating: 0.0, count: self.row()), count: self.col())
        for i in 0..<self.row() {
            for j in 0..<self.col() {
                t[j][i] = self.getItem(pos: (i, j))
            }
        }
        return Metrix(metrix: t)
    }
}

// MARK: - Operators
extension Metrix {
    static func + (left: Metrix, right: Metrix) -> Metrix {
        assert(left.shape() == right.shape() )
        let row = Array(repeating: 0.0, count: left.col())
        var sum = Array(repeating: row, count: left.row())
        for i in 0..<left.row() {
            for j in 0..<left.col() {
                sum[i][j] = left.getItem(pos: (i, j)) + right.getItem(pos: (i, j))
            }
        }
        return Metrix(metrix: sum)
    }
    
    static func - (left: Metrix, right: Metrix) -> Metrix {
        assert(left.shape() == right.shape())
        let row = Array(repeating: 0.0, count: left.col())
        var sum = Array(repeating: row, count: left.row())
        for i in 0..<left.row() {
            for j in 0..<left.col() {
                sum[i][j] = left.getItem(pos: (i, j)) - right.getItem(pos: (i, j))
            }
        }
        return Metrix(metrix: sum)
    }
    
    static prefix func - (metrix: Metrix) -> Metrix {
        return -1 * metrix
    }
    
    static func * (left: Metrix, right: Double) -> Metrix {
        let row = Array(repeating: 0.0, count: left.col())
        var sum = Array(repeating: row, count: left.row())
        for i in 0..<left.row() {
            for j in 0..<left.col() {
                sum[i][j] = left.getItem(pos: (i, j)) * right
            }
        }
        return Metrix(metrix: sum)
    }
    
    static func * (left: Double, right: Metrix) -> Metrix {
        return right * left
    }
    
    static func / (left: Metrix, right: Double) -> Metrix {
        return left * (1 / right)
    }
    
    static func • (left: Metrix, right: Vector) -> Vector {
        assert(left.col() == right.getLen())
        var sum: [Double] = Array(repeating: 0.0, count: right.getLen())
        for i in 0..<left.row() {
            let row = left.rowVector(index: i)
            sum[i] = (row • right)
        }
        return Vector(array: sum)
    }
    
    static func • (left: Vector, right: Metrix) -> Vector {
        return right • left
    }
    
    static func • (left: Metrix, right: Metrix) -> Metrix {
        assert(left.col() == right.row())
        var sum: [[Double]] = Array(repeating: Array(repeating: 0.0, count: left.col()), count: right.row())
        for i in 0..<left.row() {
            for j in 0..<right.col() {
                var dot = 0.0
                for k in 0..<left.col() {
                    dot += left.getItem(pos: (i, k)) * right.getItem(pos: (k, j))
                }
                sum[i][j] = dot
            }
        }
        return Metrix(metrix: sum)
    }
}
 
extension Metrix: CustomStringConvertible {
    var description: String {
        return "Metrix(\(self.values))"
    }
}

extension Metrix {
    func lu() -> (Metrix, Metrix)? {
        assert(row() == col())
        let n = row()
        var U: [Vector] = []
        for i in 0..<n {
            U.append(rowVector(index: i))
        }
        var L = Array(repeating: Array(repeating: 0.0, count: n), count: n)
        for i in 0..<n {
            if U[i].getItem(index: i) == 0 {
                return nil
            }
            L[i][i] = 1.0
            for j in (i + 1)..<n {
                let p = U[j].getItem(index: i) / U[i].getItem(index: i)
                U[j] = U[j] - p * U[i]
                L[j][i] = p
            }
        }
        var u: [[Double]] = []
        for i in U {
            u.append(i.values)
        }
        return (Metrix(metrix: L), Metrix(metrix: u))
    }
}

extension Metrix {
    func gramSchmidtProcess() -> [Vector] {
        assert(self.rank() == self.col())
        var res: [Vector] = [self.rowVector(index: 0)]
        for i in 1..<self.row() {
            var p = self.rowVector(index: i)
            for r in res {
                p = p - (self.rowVector(index: i) • r) / (r • r) * r
            }
            res.append(p)
        }
        return res
    }
    
    func QR() -> (Metrix, Metrix) {
        var metrix: [[Double]] = []
        var vectors: [Vector] = self.T().gramSchmidtProcess()
        for (i, vector) in vectors.enumerated() {
            vectors[i] = vector / vector.norm()
        }
        for vector in vectors {
            metrix.append(vector.values)
        }
        let Q = Metrix(metrix: metrix).T()
        let R = Q.T() • self
        return (Q, R)
    }
}
