//
//  Ejercicio.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

@main
struct MiApp: App {
    let container: ModelContainer

    init() {
        do {
            // Configurar el contenedor para el modelo Ejercicio
            container = try ModelContainer(for: Ejercicio.self, EjercicioEntrenamiento.self, Serie.self, EjercicioProgramado.self, EntrenamientoProgramado.self, SeriePlanificada.self)
            let context = container.mainContext
            // Cargar datos iniciales si no hay ejercicios guardados
            cargarDatosIniciales(context: context)
        } catch {
            fatalError("Error al crear el ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container) // Pasar el contenedor a las vistas
    }
}

// Función para cargar datos del JSON a SwiftData
func cargarDatosIniciales(context: ModelContext) {
    do {
        guard let url = Bundle.main.url(forResource: "ejercicios", withExtension: "json") else {
            print("No se encontró el archivo ejercicios.json")
            return
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let ejerciciosJSON = try decoder.decode([EjercicioJSON].self, from: data)

        // Obtener los ejercicios existentes en SwiftData
        let ejerciciosExistentes = try context.fetch(FetchDescriptor<Ejercicio>())

        // Crear un diccionario seguro sin duplicados de los ejercicios existentes
        var ejerciciosPorNombre = [String: Ejercicio]()
        for ejercicio in ejerciciosExistentes {
            if ejerciciosPorNombre[ejercicio.nombre] == nil {
                ejerciciosPorNombre[ejercicio.nombre] = ejercicio
            } else {
                print("⚠️ Advertencia: Duplicado en SwiftData ignorado -> \(ejercicio.nombre)")
            }
        }

        // Conjunto para detectar duplicados dentro del JSON
        var nombresVistos = Set<String>()

        for ejercicioJSON in ejerciciosJSON {
            if nombresVistos.contains(ejercicioJSON.nombre) {
                print("⚠️ Advertencia: Nombre duplicado en JSON ignorado -> \(ejercicioJSON.nombre)")
                continue // Saltar este ejercicio
            }
            nombresVistos.insert(ejercicioJSON.nombre)

            if let ejercicioExistente = ejerciciosPorNombre[ejercicioJSON.nombre] {
                // Verificar si necesita actualización
                var necesitaActualizacion = false

                if ejercicioExistente.descripcion != ejercicioJSON.descripcion {
                    ejercicioExistente.descripcion = ejercicioJSON.descripcion
                    necesitaActualizacion = true
                }
                if ejercicioExistente.grupoMuscular != ejercicioJSON.grupoMuscular {
                    ejercicioExistente.grupoMuscular = ejercicioJSON.grupoMuscular
                    necesitaActualizacion = true
                }

                if necesitaActualizacion {
                    print("✅ Actualizado ejercicio: \(ejercicioJSON.nombre)")
                }
            } else {
                // Insertar nuevo ejercicio si no existe
                let nuevoEjercicio = Ejercicio(
                    nombre: ejercicioJSON.nombre,
                    descripcion: ejercicioJSON.descripcion,
                    grupoMuscular: ejercicioJSON.grupoMuscular
                )
                context.insert(nuevoEjercicio)
                print("➕ Añadido nuevo ejercicio: \(ejercicioJSON.nombre)")
            }
        }

    } catch {
        print("❌ Error al cargar datos del JSON: \(error)")
    }
}
