//
//  DetalleRutinaView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct DetalleRutinaView: View {
    let rutina: Rutina
    @Environment(\.modelContext) private var modelContext
    @State private var mostrarSesion = false
    @State private var sesionActiva: Sesion? // Nueva propiedad para almacenar la sesión

    var body: some View {
        List {
            ForEach(rutina.ejercicios) { ejercicio in
                Text(ejercicio.nombre)
            }
        }
        .navigationTitle(rutina.nombre)
        .toolbar {
            Button("Empezar Sesión") {
                let nuevaSesion = Sesion(fecha: Date(), rutina: rutina)
                modelContext.insert(nuevaSesion)
                for ejercicio in rutina.ejercicios {
                    let ejercicioSesion = EjercicioSesion(
                        ejercicio: ejercicio,
                        series: ejercicio.seriesDefecto,
                        repeticiones: ejercicio.repeticionesDefecto,
                        peso: ejercicio.pesoDefecto
                    )
                    nuevaSesion.ejerciciosRealizados.append(ejercicioSesion)
                }
                sesionActiva = nuevaSesion // Asigna la nueva sesión a la propiedad de estado
                mostrarSesion = true
            }
        }
        .sheet(isPresented: $mostrarSesion, onDismiss: {
            sesionActiva = nil // Limpia la sesión activa al cerrar
        }) {
            if let sesion = sesionActiva {
                SesionEntrenamientoView(sesion: sesion)
            }
        }
    }
}
