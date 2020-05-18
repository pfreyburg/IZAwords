//
//  Vyhodnoceni.swift
//  IZAwords
//
//  Created by Petr Freyburg on 18/05/2020.
//  Copyright © 2020 Petr Freyburg. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// vyhodnocení testu
struct VyhodnoceniView : View {
    var spatne : Int // špatné odpovědi počet
    var vysledky : [Zodpovezene_slovicko] // pole s chybně zodpovězenými slovíčky
    var nezodpovezeno : Int // nezodpovězeno počet
    var body: some View {
        GeometryReader { geometry in
            VStack(){
                Text("Vyhodnocení").font(.largeTitle)
                Spacer()
                // "tabulka" odpovědí
                HStack(){
                    Text("Slovíčko").fontWeight(Font.Weight.bold)
                    Spacer()
                    Text("Odpověď").fontWeight(Font.Weight.bold)
                    Spacer()
                    Text("Správně").fontWeight(Font.Weight.bold)
                }
                
                ForEach(self.vysledky, id: \.self){ zodpovezeno in
                    HStack(){
                        Text(zodpovezeno.otazka)
                            .frame(width: geometry.size.width*0.2, alignment: .center)
                        Spacer()
                        Text(zodpovezeno.odpoved)
                            .frame(width: geometry.size.width*0.2, alignment: .center)
                        Spacer()
                        Text(zodpovezeno.spravne)
                            .frame(width: geometry.size.width*0.2, alignment: .center)
                    }
                    
                }
                
                Spacer()
                // počet špatných a nezodpovězených
                HStack() {
                    Text("Špatně: \(self.spatne)")
                    Text("(nevyplněno: \(self.nezodpovezeno))")
                }
            }
        }.padding(20)
    }
}

