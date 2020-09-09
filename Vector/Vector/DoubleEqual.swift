//
//  DoubleEqual.swift
//  Vector
//
//  Created by 周一见 on 2020/8/16.
//  Copyright © 2020 周一见. All rights reserved.
//

import Foundation

extension Double {
    func isZero() -> Bool {
        return abs(self) < epsilon
    }
    
    func isEqual(_ other: Double) -> Bool {
        return abs(self - other) < epsilon
    }
}
