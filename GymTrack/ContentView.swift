//
//  ContentView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 28/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var ejerciciosEntrenamientos: [EjercicioEntrenamiento]

    var body: some View {
        TabView {
//            Text("GymTrack")
            List {
                ForEach(ejerciciosEntrenamientos) { ejercicioEntrenamiento in
                    Text("\(ejercicioEntrenamiento.ejercicio.nombre)")
                }
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            EjerciciosList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ejercicios")
                }
        }
    }
}

#Preview {
    ContentView()
}
