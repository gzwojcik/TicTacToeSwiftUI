//
//  Move.swift
//  TicTacToeSwiftUI
//
//  Created by zgagaSur on 14/05/2021.
//

import SwiftUI

struct Move {
    let player:Player
    let boardIndex:Int // position on the board
    
    var indicator:String{
        return player == .human ? SFSymbols.human : SFSymbols.cpu
    }
}

