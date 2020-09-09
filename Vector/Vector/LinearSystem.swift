//
//  LinearSystem.swift
//  Vector
//
//  Created by 周一见 on 2020/8/14.
//  Copyright © 2020 周一见. All rights reserved.
//

import Foundation

struct LinearSystem {
    fileprivate let m: Int
    fileprivate let n: Int
    fileprivate var augmentedMatrix: [Vector] = []
    fileprivate var pivots: [Int] = []
    
    init(A: Metrix, b: Vector) {
        assert(A.row() == b.getLen())
        self.m = A.row()
        self.n = A.col()
        for i in 0..<self.m {
            augmentedMatrix.append(Vector(array: A.rowVector(index: i).values + [b.getItem(index: i)]))
        }
    }
    
    init(A: Metrix, B: Metrix) {
        assert(A.row() == B.row())
        self.m = A.row()
        self.n = A.col()
        for i in 0..<self.m {
            augmentedMatrix.append(Vector(array: A.rowVector(index: i).values + B.rowVector(index: i).values))
        }
    }
    
    init(A: Metrix) {
        self.m = A.row()
        self.n = A.col()
        for i in 0..<self.m {
            augmentedMatrix.append(Vector(array: A.rowVector(index: i).values))
        }
    }
    
    mutating func gaussJordanElimination() -> Bool {
        forward()
        backward()
        var isSlution = true
        for i in pivots.count..<m {
            if !augmentedMatrix[i].getItem(index: n).isZero {
                isSlution = false
                break
            }
        }
        return isSlution
    }
    
    private mutating func forward() {
        //i 为行，k 为列
        var i = 0, k = 0
        while i < m && k < n {
            let maxRow = getMaxZhuYuan(row: i, col: k)
            augmentedMatrix.swapAt(i, maxRow)
            if augmentedMatrix[i].getItem(index: k).isZero {
                k += 1
            } else {
                augmentedMatrix[i] = augmentedMatrix[i] / augmentedMatrix[i].getItem(index: k)
                for j in (i+1)..<m {
                    augmentedMatrix[j] = augmentedMatrix[j] - augmentedMatrix[j].getItem(index: k) * augmentedMatrix[i]
                }
                i += 1
                pivots.append(k)
            }
        }
    }
    
    private mutating func backward() {
        for (index, j) in pivots.enumerated().reversed() {
            for i in (0..<index).reversed() {
                augmentedMatrix[i] = augmentedMatrix[i] - augmentedMatrix[i].getItem(index: j) * augmentedMatrix[index]
            }
        }
    }
    
    private func getMaxZhuYuan(row: Int, col: Int) -> Int {
        var maxNumber = augmentedMatrix[row].getItem(index: col)
        var maxRow = row
        for i in row..<m {
            if augmentedMatrix[i].getItem(index: col) > maxNumber {
                maxNumber = augmentedMatrix[i].getItem(index: col)
                maxRow = i
            }
        }
        return maxRow
    }
}

extension LinearSystem: CustomStringConvertible {
    var description: String {
        var str = ""
        for i in 0..<m {
            for j in 0..<n {
                str.append("\(augmentedMatrix[i].getItem(index: j)) ")
            }
            str.append("| \(augmentedMatrix[i].getItem(index: n))\n")
        } 
        return str
    }
}

extension Metrix {
    func inv() -> Metrix? {
        assert(row() == col())
        var ls = LinearSystem.init(A: self, B: Metrix(identity: row()))
        if ls.gaussJordanElimination() {
            var invA: [[Double]] = []
            for i in 0..<ls.m {
                var rowA: [Double] = []
                for j in ls.m..<(2 * ls.m) {
                    rowA.append(ls.augmentedMatrix[i].getItem(index: j))
                }
                invA.append(rowA)
            }
            return Metrix(metrix: invA)
        } else {
            return nil
        }
    }
    
    func rank() -> Int {
        var ls = LinearSystem(A: self)
        _ = ls.gaussJordanElimination()
        let zero = Vector(zeroDim: self.col())
        var rank = 0
        for vector in ls.augmentedMatrix {
            if vector != zero {
                rank += 1
            }
        }
        return rank
    }
}
