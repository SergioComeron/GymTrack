//
//  Ejercicio.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

@main
struct GymApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                RutinasView()
                    .tabItem { Label("Rutinas", systemImage: "list.dash") }
                HistorialSesionesView()
                    .tabItem { Label("Sesiones", systemImage: "clock") }
                EjerciciosView()
                    .tabItem { Label("Ejercicios", systemImage: "dumbbell") }
            }
        }
        .modelContainer(for: [Rutina.self, Ejercicio.self, Sesion.self, EjercicioSesion.self]) { result in
            switch result {
            case .success(let container):
                let context = container.mainContext
                
                // Verificar si ya hay ejercicios
                let descriptor = FetchDescriptor<Ejercicio>()
                let existingExercises = try? context.fetchCount(descriptor)
                
                // Solo cargar si no hay ejercicios
                if existingExercises == 0 {
                    do {
                        guard let url = Bundle.main.url(forResource: "ejercicios", withExtension: "json") else {
                            print("No se encontró el archivo ejercicios.json")
                            return
                        }
                        let data = try Data(contentsOf: url)
                        let ejerciciosJSON = try JSONDecoder().decode([EjercicioJSON].self, from: data)
                        
                        for ejercicioJSON in ejerciciosJSON {
                            let ejercicio = Ejercicio(
                                nombre: ejercicioJSON.nombre,
                                descripcion: ejercicioJSON.descripcion,
                                grupoMuscular: ejercicioJSON.grupoMuscular,
                                seriesDefecto: ejercicioJSON.seriesDefecto,
                                repeticionesDefecto: ejercicioJSON.repeticionesDefecto,
                                pesoDefecto: ejercicioJSON.pesoDefecto
                            )
                            context.insert(ejercicio)
                        }
                        try context.save()
                    } catch {
                        print("Error al cargar ejercicios desde JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error al crear el ModelContainer: \(error)")
            }
        }
    }
}

struct EjercicioJSON: Codable {
    let nombre: String
    let descripcion: String?
    let grupoMuscular: String?
    let seriesDefecto: Int
    let repeticionesDefecto: Int
    let pesoDefecto: Double
}
