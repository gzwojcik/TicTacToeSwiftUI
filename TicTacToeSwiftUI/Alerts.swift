//
//  Alerts.swift
//  TicTacToeSwiftUI
//
//  Created by zgagaSur on 12/05/2021.
//

import SwiftUI

struct AlertItem:Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
     static let humanWin = AlertItem(title: Text("You Won, Dude!"),
                             message:Text("Managed to beat your own AI."),
                             buttonTitle: Text("Noch mall !"))
    
    static let cpuWin = AlertItem(title: Text("You Lost, Dude!"),
                             message:Text("Unbittable AI."),
                             buttonTitle: Text("Lets Go Again!"))
    
    static let draw = AlertItem(title: Text("It's a Draw  Dude!"),
                             message:Text("Battle to the End?"),
                             buttonTitle: Text("Another Try?"))
}

