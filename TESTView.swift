//
//  TESTView.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 31/07/2025.
//
import SwiftUI

struct SimpleContentView: View {
    @State private var isFirst: Bool = false
     var body: some View {
         VStack {
             Button("Переключить") {
                 isFirst.toggle()
             }
             if isFirst {
                 Text("Текст 1")
             } else {
                 Text("Текст 2")
             }
         }
     }
}

#Preview {
    SimpleContentView()
}
