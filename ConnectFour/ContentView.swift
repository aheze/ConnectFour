//
//  ContentView.swift
//  ConnectFour
//
//  Created by A. Zheng (github.com/aheze) on 4/1/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

enum Symbol {
    case red
    case yellow
    case tie
}

struct Piece {
    var symbol: Symbol
    var location: Location /// section = row, item = column
}

struct Location: Equatable {
    var row = 0
    var column = 0
}

struct ContentView: View {
    @StateObject var model = ViewModel()

    var body: some View {
        VStack {
            Text("Connect 4")
                .font(.system(size: 64, weight: .bold, design: .monospaced))

            if let winner = model.winner {
                VStack {
                    switch winner {
                    case .red:
                        Text("**RED** you won!")
                            .foregroundColor(.red)
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                    case .yellow:
                        Text("**YELLOW** you won!")
                            .foregroundColor(.yellow)
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                    default:
                        EmptyView()
                    }
                }.font(.largeTitle)
            } else if let activeSymbol = model.activeSymbol {
                VStack {
                    switch activeSymbol {
                    case .red:
                        Text("**RED** it's your turn")
                            .foregroundColor(.red)
                    case .yellow:
                        Text("**YELLOW** it's your turn")
                            .foregroundColor(.yellow)
                    default:
                        EmptyView()
                    }
                }.font(.largeTitle)
            }

            HStack(spacing: 10) {
                ForEach(0..<7, id: \.self) { column in
                    VStack(spacing: 10) {
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
                            Color.green
                                .frame(height: 40)
                                .cornerRadius(16)
                                .padding()
                        }

                        ForEach(Array(0..<6).reversed(), id: \.self) { row in
                            let location = Location(row: row, column: column)
                            let piece = model.pieces.first(where: { $0.location == location })

                            SquareView(location: location, symbol: piece?.symbol)
                        }
                    }
                }
            }
        }
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
    let lineWidth = CGFloat(6)
    
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
                            miterLimit: 10,
                            dash: [10],
                            dashPhase: 0
                        )
                    )
                    .padding(lineWidth / 2)
            )
            .shadow(
                color: Color(uiColor: .label).opacity(0.4),
                radius: 3,
                x: 0,
                y: 2
            )
            .transition(.offset(x: 0, y: -1000))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
