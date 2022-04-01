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
                .font(.largeTitle)

            if let winner = model.winner {
                VStack {
                    switch winner {
                    case .red:
                        Text("**RED** you won!")
                            .foregroundColor(.red)
                    case .yellow:
                        Text("**YELLOW** you won!")
                            .foregroundColor(.yellow)
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

            HStack {
                ForEach(Array(0..<7).reversed(), id: \.self) { column in
                    VStack {
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
                            
                            let winner = model.checkEnd()
                            
                            
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
            .overlay {
                VStack {
                    if let symbol = symbol {
                        switch symbol {
                        case .red:
                            Circle()
                                .fill(.red)
                                .transition(.scale)
                        case .yellow:
                            Circle()
                                .fill(.yellow)
                                .transition(.scale)
                        case .tie:
                            EmptyView()
                        }
                    }
                }
                .padding(16)
            }
            .font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(16)
            .shadow(radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
