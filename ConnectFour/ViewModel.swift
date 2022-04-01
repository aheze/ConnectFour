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

        if pieces.count == 9 {
            return .tie
        }
        return nil
    }

    func check4InRow(with pieces: [Piece]) -> Bool {
        guard pieces.count >= 4 else { return false }
        let locations = pieces.map { $0.location }

        /// check vertical columns
        for column in 0 ..< 7 {
            let rows = locations.filter { $0.column == column }.sorted { $0.row < $1.row }.map { $0.row }
            print("rows: \(rows)")
            let consecutive = rows.map { $0 - 1 }.dropFirst() == rows.dropLast()
            
            if rows.count >= 4, consecutive {
                return true
            }
        }
        
        /// check horizontal rows
        for row in 0 ..< 6 {
            let columns = locations.filter { $0.row == row }.sorted { $0.column < $1.column }.column { $0.columns }
            let consecutive = columns.map { $0 - 1 }.dropFirst() == columns.dropLast()
            
            if columns.count >= 4, consecutive {
                return true
            }
        }
        
        
        return false
    }
}
