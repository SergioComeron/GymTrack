//
//  SerieEntrenamientoView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct SesionEntrenamientoView: View {
    @Bindable var sesion: Sesion
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach($sesion.ejerciciosRealizados) { $ejercicioSesion in
                    VStack {
                        Text(ejercicioSesion.ejercicio.nombre)
                        Stepper("Series: \(ejercicioSesion.series)", value: $ejercicioSesion.series, in: 1...10)
                        Stepper("Repeticiones: \(ejercicioSesion.repeticiones)", value: $ejercicioSesion.repeticiones, in: 1...20)
                        TextField("Peso", value: $ejercicioSesion.peso, format: .number)
                    }
                }
            }
            .navigationTitle("Sesión de Entrenamiento")
            .toolbar {
                Button("Guardar") {
                    try? modelContext.save()
                    dismiss()
                }
            }
        }
    }
}
