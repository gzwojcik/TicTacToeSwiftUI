//
//  GameViewModel.swift
//  TicTacToeSwiftUI
//
//  Created by zgagaSur on 13/05/2021.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    let columns:[GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem:AlertItem?
    
    func processPlayerMove(for i :Int){
        
        //human move processing
        // i to pozycja
        
        // check if its taken
        if isSquareOccupied(in: moves, forIndex: i){return}
        
        moves[i] = Move(player: .human, boardIndex: i)
       
        
        // check for win condition or draw
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return // to stop the game
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return // to stop the game
        }
        // 1st check for win, then disable the board !!!!!
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            
            // computer moves
            let cpuPosition = determineCpuMovePosition(in: moves)
            moves[cpuPosition] = Move(player: .cpu, boardIndex: cpuPosition)
            //enabling the board after cpu move
            isGameboardDisabled = false
            
            if checkWinCondition(for: .cpu, in: moves) {
                alertItem = AlertContext.cpuWin
                return // to stop the game
            }
            
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return // to stop the game
            }
        }
        
    }
    
    
    func isSquareOccupied(in moves: [Move?], forIndex index:Int) ->Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    // if Ai can win, then win
    
    // if Ai can't win, then block
    // it Ai cant block, take middle square
    //if Ai cant take the middle square, take random avaiable square

    
    func determineCpuMovePosition(in moves:[Move?]) -> Int {
        // if Ai can win, then win
        
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let cpuMoves = moves.compactMap{$0}.filter {$0.player == .cpu}
        let cpuPositions = Set(cpuMoves.map {$0.boardIndex})
        
        for pattern in winPatterns {
            // if only 1 or 2 positions are avail then take it
            let winPositions = pattern.subtracting(cpuPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        
        
        // if Ai can't win, then block
        
        let humanMoves = moves.compactMap{$0}.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        
        for pattern in winPatterns {
            // if only 1 or 2 positions are avail then take it
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
       
        
        // it Ai cant block, take middle square
        
        // if its not occupied
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        //if Ai cant take the middle square, take random avaiable square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            
        
        movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player:Player, in moves:[Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter {$0.player == player}
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        // if winpattern is found in playerPositions then we have a winner
        
        for pattern in winPatterns where pattern.isSubset(of:playerPositions){ return true}
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        
        return moves.compactMap{$0}.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
        
    }
    
}


