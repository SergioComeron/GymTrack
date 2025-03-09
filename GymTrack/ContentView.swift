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
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            EjerciciosList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ejercicios")
                }
            
            ProgramarEntrenamientoView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Crear Entrenamiento")
                }
            
            SeleccionarEntrenamientoProgramadoView()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Realizar Entrenamiento")
                }
        }
    }
}

#Preview {
    ContentView()
}
