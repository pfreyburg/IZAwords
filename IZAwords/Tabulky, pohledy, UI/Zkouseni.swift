//
//  Zkouseni.swift
//  IZAwords
//
//  Created by Petr Freyburg on 31/03/2020.
//  Copyright © 2020 Petr Freyburg. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// zkoušení View
struct Zkouseni: View {
    @State var lekce_name : String
    @State var activity = false
    var slovicka : [String]
    var typ_zkouseni_jazyk : typ_zkouseni
    var slovicka_vsechny : [Slovicko]
    @State var vyhodnoceni : Vyhodnoceni? = nil
    @State private var odpovedi : [String:String] = [:]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(){
                Text(self.lekce_name).font(Font.largeTitle).padding(15)
                
                ScrollView(.horizontal) {
                    HStack() {
                        
                        ForEach(self.slovicka, id: \.self){ slovicko in
                            VStack{
                                Text(slovicko)
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .frame(width: geometry.size.width*0.9, height: geometry.size.width*0.7, alignment: .center)
                                    .background(Color(red: 26 / 255, green: 188 / 255, blue: 156 / 255))
                                    .padding(geometry.size.width*0.05)
                                
                                TextField("Vaše odpověď:", text: Binding(
                                    get: {self.odpovedi[slovicko] ?? ""},
                                    set: {newValue in return self.odpovedi[slovicko] = newValue}
                                )).padding(geometry.size.width*0.05)
                                
                                
                            }
                        }
                    }
                    Spacer()
                }
                
                Button(action: {
                    self.activity.toggle()
                    let vyhodnoceniVC = VyhodnoceniVC(_odpovedi: self.odpovedi, _typ_zkouseni_jazyk: self.typ_zkouseni_jazyk, _slovicka : self.slovicka_vsechny)
                    self.vyhodnoceni = vyhodnoceniVC.provest()
                }) {
                    Text("Vyhodnotit")
                }.sheet(isPresented: self.$activity){
                    
                    VyhodnoceniView(spatne: self.vyhodnoceni!.spatne, vysledky: self.vyhodnoceni!.vysledky, nezodpovezeno: self.vyhodnoceni!.nezodpovezeno)
                }
            }
        }.background(Color(red: 236 / 255, green: 240 / 255, blue: 241 / 255).edgesIgnoringSafeArea(.all))
    }
}
