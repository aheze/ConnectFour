//
//  ContentView.swift
//  ConnectFour
//
//  Created by A. Zheng (github.com/aheze) on 4/1/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModel()

    var body: some View {
        VStack {
            Text("Connect 4")
                .font(.system(size: 64, weight: .bold, design: .monospaced))

            if let winner = model.winner {
                HStack(spacing: 20) {
                    switch winner {
                    case .red:
                        CirclePiece(color: .red, borderColor: .yellow, lineWidth: 2)
                            .frame(width: 40, height: 40)

                        Text("RED you won!")
                            .foregroundColor(.red)

                    case .yellow:
                        CirclePiece(color: .yellow, borderColor: .red, lineWidth: 2)
                            .frame(width: 40, height: 40)

                        Text("YELLOW you won!")
                            .foregroundColor(.yellow)
                    default:
                        Text("TIE")
                            .foregroundColor(.blue)
                    }

                    Button {
                        withAnimation(.spring()) {
                            model.pieces.removeAll()
                            model.activeSymbol = .red
                            model.winner = nil
                        }
                    } label: {
                        Text("Play Again?")
                    }
                }
                .font(.system(size: 36, weight: .semibold))
            } else if let activeSymbol = model.activeSymbol {
                HStack(spacing: 20) {
                    switch activeSymbol {
                    case .red:
                        CirclePiece(color: .red, borderColor: .yellow, lineWidth: 2)
                            .frame(width: 40, height: 40)

                        Text("RED it's your turn")
                            .foregroundColor(.red)
                    case .yellow:
                        CirclePiece(color: .yellow, borderColor: .red, lineWidth: 2)
                            .frame(width: 40, height: 40)
                        Text("YELLOW it's your turn")
                            .foregroundColor(.yellow)
                    default:
                        EmptyView()
                    }
                }
                .font(.system(size: 36, weight: .semibold))
            }

            HStack(spacing: 10) {
                ForEach(0..<7, id: \.self) { column in

                    Button {
                        model.addPiece(in: column)
                        if let activeSymbol = model.activeSymbol {
                            switch activeSymbol {
                            case .red:
                                model.activeSymbol = .yellow
                            case .yellow:
                                model.activeSymbol = .red
                            case .tie:
                                model.activeSymbol = .red
                            }
                        }

                        model.winner = model.checkEnd()

                    } label: {
                        VStack(spacing: 10) {
                            let delay = Double(column) * 0.25

                            VStack {
                                if let winner = model.winner {
                                    switch winner {
                                    case .red:
                                        Color.red
                                    case .yellow:
                                        Color.yellow
                                    case .tie:
                                        Color.blue
                                    }
                                } else {
                                    Color.blue
                                }
                            }
                            .frame(height: 50)
                            .cornerRadius(16)
                            .overlay(
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.title.weight(.bold))
                            )
                            .scaleEffect(model.winner != nil ? 1 : 0.8)
                            .animation(.spring().delay(delay), value: model.winner)
                            .opacity(disabledColumn(column: column) ? 0.3 : 1)

                            ForEach(Array(0..<6).reversed(), id: \.self) { row in
                                let location = Location(row: row, column: column)
                                let piece = model.pieces.first(where: { $0.location == location })

                                SquareView(location: location, symbol: piece?.symbol)
                            }
                        }
                    }
                    .disabled(disabledColumn(column: column))
                }
            }
            .disabled(model.winner != nil)
        }
        .padding(20)
    }

    /// disable column if already full
    func disabledColumn(column: Int) -> Bool {
        let columnPieces = model.pieces.filter { $0.location.column == column }
        return columnPieces.count >= 6
    }
    
    func getRemovalDelay(column: Int, row: Int) -> Double {
        let delay = Double(column) * Double(row) * 0.1
        return delay
    }
}

struct SquareView: View {
    var location: Location
    var symbol: Symbol?

    var body: some View {
        Color(uiColor: .secondarySystemBackground)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(16)
            .shadow(
                color: Color(uiColor: .label).opacity(0.25),
                radius: 5,
                x: 0,
                y: 3
            )
            .overlay {
                VStack {
                    if let symbol = symbol {
                        switch symbol {
                        case .red:
                            CirclePiece(color: .red, borderColor: .yellow)
                        case .yellow:
                            CirclePiece(color: .yellow, borderColor: .red)
                        case .tie:
                            EmptyView()
                        }
                    }
                }
                .padding(16)
            }
            .font(.largeTitle)
    }
}

struct CirclePiece: View {
    let color: Color
    let borderColor: Color
    var lineWidth = CGFloat(6)

    var body: some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(
                        borderColor,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .butt,
                            lineJoin: .miter,
                            miterLimit: lineWidth * 2,
                            dash: [lineWidth * 2],
                            dashPhase: 0
                        )
                    )
                    .shadow(
                        color: Color(uiColor: .label).opacity(0.4),
                        radius: 1,
                        x: 0,
                        y: 0
                    )
                    .padding(lineWidth / 2)
            )
            .shadow(
                color: Color(uiColor: .label).opacity(0.4),
                radius: 3,
                x: 0,
                y: 2
            )
            .transition(.offset(x: 0, y: -1000).combined(with: .opacity))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
