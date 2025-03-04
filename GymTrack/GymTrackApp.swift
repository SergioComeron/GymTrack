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
            container = try ModelContainer(for: Ejercicio.self, EjercicioEntrenamiento.self, Serie.self)
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
        // Obtener la URL del archivo ejercicios.json
        guard let url = Bundle.main.url(forResource: "ejercicios", withExtension: "json") else {
            print("No se encontró el archivo ejercicios.json")
            return
        }

        // Leer y decodificar el JSON
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let ejerciciosJSON = try decoder.decode([EjercicioJSON].self, from: data)

        // Obtener los ejercicios existentes en SwiftData
        let ejerciciosExistentes = try context.fetch(FetchDescriptor<Ejercicio>())
        
        // Crear un diccionario para acceso rápido a los ejercicios existentes por nombre
        let ejerciciosPorNombre: [String: Ejercicio] = Dictionary(uniqueKeysWithValues: ejerciciosExistentes.map { ($0.nombre, $0) })

        // Iterar sobre los ejercicios del JSON
        for ejercicioJSON in ejerciciosJSON {
            if let ejercicioExistente = ejerciciosPorNombre[ejercicioJSON.nombre] {
                // Si el ejercicio ya existe, verificar si necesita actualización
                var necesitaActualizacion = false
                
                if ejercicioExistente.descripcion != ejercicioJSON.descripcion {
                    ejercicioExistente.descripcion = ejercicioJSON.descripcion
                    necesitaActualizacion = true
                }
                if ejercicioExistente.grupoMuscular != ejercicioJSON.grupoMuscular {
                    ejercicioExistente.grupoMuscular = ejercicioJSON.grupoMuscular
                    necesitaActualizacion = true
                }
                
                // Si hubo cambios, SwiftData detectará la modificación automáticamente
                if necesitaActualizacion {
                    print("Actualizado ejercicio: \(ejercicioJSON.nombre)")
                }
            } else {
                // Si no existe, crear un nuevo ejercicio
                let nuevoEjercicio = Ejercicio(
                    nombre: ejercicioJSON.nombre,
                    descripcion: ejercicioJSON.descripcion,
                    grupoMuscular: ejercicioJSON.grupoMuscular
                )
                context.insert(nuevoEjercicio)
                print("Añadido nuevo ejercicio: \(ejercicioJSON.nombre)")
            }
        }
        
        // Nota: No es necesario context.save() porque SwiftData guarda automáticamente los cambios
    } catch {
        print("Error al cargar datos del JSON: \(error)")
    }
}
