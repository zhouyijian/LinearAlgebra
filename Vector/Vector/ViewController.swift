//
//  ViewController.swift
//  Vector
//
//  Created by 周一见 on 2020/7/31.
//  Copyright © 2020 周一见. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metrix = Metrix(metrix: [[1, 2], [3, 4]])
        let metrix2 = Metrix(metrix: [[5, 6], [7, 8]])
        let row0 = metrix.rowVector(index: 0)
        print(metrix)
        print(row0)
        
        print(metrix2 - metrix)
        print(metrix + metrix2)
        print(metrix • metrix2)
        print(metrix2 • metrix)
        
        let metrix3 = Metrix(metrix: [[1, 2, 3], [4, 5, 6]])
        print(metrix3.T())
        
        let metrix4 = Metrix(metrix: [[1, 2, 4], [3, 7 ,2], [2, 3, 3]])
        let vector = Vector(array: [7, -11, 1])
        var ls = LinearSystem(A: metrix4, b: vector)
        print(ls.gaussJordanElimination()) 
        print(ls)
        
        let metrix5 = Metrix(metrix: [[1, -1, 2, 0, 3], [-1, 1, 0, 2, -5], [1, -1, 4, 2, 4], [-2, 2, -5, -1, -3]])
        let vector5 = Vector(array: [1, 5, 13, -1])
        var ls5 = LinearSystem(A: metrix5, b: vector5)
        print(ls5.gaussJordanElimination())
        print(ls5)
        
        let metrix6 = Metrix(metrix: [[2, 2], [2, 1], [1, 2]])
        let vector6 = Vector(array: [3, 2.5, 7])
        var ls6 = LinearSystem(A: metrix6, b: vector6)
        print(ls6.gaussJordanElimination())
        print(ls6)
        
        print(metrix.inv()!)
        
        let metrix7 = Metrix(metrix: [[1, 2, 3], [4, 5, 6], [3, -3, 5]])
        print(metrix7.lu()!)
        print(metrix7.rank())
        let zhengjioaji = metrix7.gramSchmidtProcess()
        print(zhengjioaji)
        print(zhengjioaji[0] • zhengjioaji[1])
        
        let (Q, R) = metrix7.QR()
        print(Q, R)
        print(Q • R)
        
        let (Q1, R1) = metrix4.QR()
        print(Q1, R1)
        print(Q1 • R1)
    }


}

