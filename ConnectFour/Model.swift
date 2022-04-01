//
//  Model.swift
//  ConnectFour
//
//  Created by A. Zheng (github.com/aheze) on 4/1/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    

import SwiftUI

enum Symbol: Equatable {
    case red
    case yellow
    case tie
}

struct Piece: Equatable {
    var symbol: Symbol
    var location: Location /// section = row, item = column
}

struct Location: Equatable {
    var row = 0
    var column = 0
}
