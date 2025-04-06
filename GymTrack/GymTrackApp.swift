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
        var ejerciciosPorClave = [String: Ejercicio]()
        for ejercicio in ejerciciosExistentes {
            let clave = "\(ejercicio.nombre.lowercased())_\(ejercicio.grupoMuscular?.lowercased() ?? "")"
            if ejerciciosPorClave[clave] == nil {
                ejerciciosPorClave[clave] = ejercicio
            } else {
                print("⚠️ Advertencia: Duplicado en SwiftData ignorado -> \(ejercicio.nombre) (\(ejercicio.grupoMuscular ?? "Sin grupo"))")
            }
        }

        // Conjunto para detectar duplicados dentro del JSON
        var clavesVistas = Set<String>()

        for ejercicioJSON in ejerciciosJSON {
            let clave = "\(ejercicioJSON.nombre.lowercased())_\(ejercicioJSON.grupoMuscular.lowercased())"
            if clavesVistas.contains(clave) {
                print("⚠️ Advertencia: Duplicado en JSON ignorado -> \(ejercicioJSON.nombre) (\(ejercicioJSON.grupoMuscular))")
                continue // Saltar este ejercicio
            }
            clavesVistas.insert(clave)

            if let ejercicioExistente = ejerciciosPorClave[clave] {
                // Verificar si necesita actualización
                var necesitaActualizacion = false

                if ejercicioExistente.descripcion != ejercicioJSON.descripcion {
                    ejercicioExistente.descripcion = ejercicioJSON.descripcion
                    necesitaActualizacion = true
                }
                if ejercicioExistente.grupoMuscular ?? "" != ejercicioJSON.grupoMuscular {
                    ejercicioExistente.grupoMuscular = ejercicioJSON.grupoMuscular
                    necesitaActualizacion = true
                }
                
                let nombreImagenEsperado = "\(ejercicioJSON.nombre.lowercased())_\(ejercicioJSON.grupoMuscular.lowercased())"
                if ejercicioExistente.imagenNombre == nil || ejercicioExistente.imagenNombre?.isEmpty == true {
                    ejercicioExistente.imagenNombre = nombreImagenEsperado
                    necesitaActualizacion = true
                }

                if necesitaActualizacion {
                    print("✅ Actualizado ejercicio: \(ejercicioJSON.nombre) (\(ejercicioJSON.grupoMuscular))")
                }
            } else {
                // Insertar nuevo ejercicio si no existe
                let nombreImagen = "\(ejercicioJSON.nombre.lowercased())_\(ejercicioJSON.grupoMuscular.lowercased())"
                let nuevoEjercicio = Ejercicio(
                    nombre: ejercicioJSON.nombre,
                    descripcion: ejercicioJSON.descripcion,
                    grupoMuscular: ejercicioJSON.grupoMuscular,
                    imagenNombre: nombreImagen
                )
                context.insert(nuevoEjercicio)
                print("➕ Añadido nuevo ejercicio: \(ejercicioJSON.nombre) (\(ejercicioJSON.grupoMuscular))")
            }
        }

    } catch {
        print("❌ Error al cargar datos del JSON: \(error)")
    }
}
