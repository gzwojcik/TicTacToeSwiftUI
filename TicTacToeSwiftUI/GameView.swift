//
//  GameView.swift
//  TicTacToeSwiftUI
//
//  Created by zgagaSur on 10/05/2021.
//

import SwiftUI




struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()

    
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Spacer()
                
                LazyVGrid(columns:viewModel.columns,spacing: 5) {
                    ForEach(0..<9) {i in
                        ZStack{
                            BoardSquareView(proxy: geometry)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                            
                        }
                        
                    }
                } //end of lazyVgrid
                
                Spacer()
            }// end of Vstack
            .disabled(viewModel.isGameboardDisabled)
            .padding() // to move it away from the edges
            .alert(item: $viewModel.alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
            
            
            
        }
        
        
    }
    
    
    
}

//enum Player {
//    case human, cpu
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct BoardSquareView: View {
    
    var proxy: GeometryProxy
    var body: some View {
        Rectangle()
            .foregroundColor(.orange).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            // if its nil there's no symbol
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundColor(.black)
    }
}
