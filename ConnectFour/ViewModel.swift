//
//  ViewModel.swift
//  ConnectFour
//
//  Created by A. Zheng (github.com/aheze) on 4/1/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var pieces = [Piece]()
    @Published var activeSymbol: Symbol? = .red
    @Published var winner: Symbol?

    func addPiece(in column: Int) {
        let currentPiecesInColumn = pieces.filter { $0.location.column == column }
        var row = 0

        if let highestRow = currentPiecesInColumn.max(by: { $0.location.row < $1.location.row }) {
            row = highestRow.location.row + 1
        }

        let location = Location(row: row, column: column)
        let piece = Piece(symbol: activeSymbol ?? .red, location: location)

        withAnimation(.spring()) {
            pieces.append(piece)
        }
    }

    func checkEnd() -> Symbol? {
        let redPieces = pieces.filter { $0.symbol == .red }
        let yellowPieces = pieces.filter { $0.symbol == .yellow }

        if check4InRow(with: redPieces) {
            return .red
        }

        if check4InRow(with: yellowPieces) {
            return .yellow
        }

        if pieces.count >= 42 {
            return .tie
        }
        return nil
    }

    func check4InRow(with pieces: [Piece]) -> Bool {
        guard pieces.count >= 4 else { return false }
        let locations = pieces.map { $0.location }

        /// check vertical columns
        for column in 0 ..< 7 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column)
                let location2 = Location(row: row + 2, column: column)
                let location3 = Location(row: row + 3, column: column)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check horizontal rows
        for row in 0 ..< 6 {
            for column in 0 ..< 7 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row, column: column + 1)
                let location2 = Location(row: row, column: column + 2)
                let location3 = Location(row: row, column: column + 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check ascending stairs
        for column in 0 ..< 4 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column + 1)
                let location2 = Location(row: row + 2, column: column + 2)
                let location3 = Location(row: row + 3, column: column + 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check descending stairs
        for column in 3 ..< 7 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column - 1)
                let location2 = Location(row: row + 2, column: column - 2)
                let location3 = Location(row: row + 3, column: column - 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        return false
    }
}
