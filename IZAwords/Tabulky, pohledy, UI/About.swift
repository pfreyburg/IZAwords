//
//  About.swift
//  IZAwords
//
//  Created by Petr Freyburg on 16/05/2020.
//  Copyright © 2020 Petr Freyburg. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct AboutView : View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(){
                Text("IZAwords").foregroundColor(Color.green).font(Font.system(size: 40)).fontWeight(Font.Weight.bold).padding(20)
                Text("Aplikace na zkoušení slovíček.")
                HStack{
                    Text("Autor:").fontWeight(Font.Weight.bold)
                    Text("Petr Freyburg")
                }.padding(20)
                Text("Vytvořeno jako projekt do předmětu IZA na FIT VUT.").multilineTextAlignment(.center)
                
                
            }
        }.background(Color(red: 189 / 255, green: 195 / 255, blue: 199 / 255).edgesIgnoringSafeArea(.all))
    }
}
