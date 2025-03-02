//
//  FormularioEjercicioView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI

struct FormularioEjercicioView: View {
    @State private var nombre = ""
    @State private var descripcion = ""
    @State private var grupoMuscular = ""
    @State private var seriesDefecto = 3
    @State private var repeticionesDefecto = 10
    @State private var pesoDefecto = 0.0
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $nombre)
                TextField("Descripción", text: $descripcion)
                TextField("Grupo Muscular", text: $grupoMuscular)
                Stepper("Series: \(seriesDefecto)", value: $seriesDefecto, in: 1...10)
                Stepper("Repeticiones: \(repeticionesDefecto)", value: $repeticionesDefecto, in: 1...20)
                TextField("Peso por defecto", value: $pesoDefecto, format: .number)
            }
            .navigationTitle("Nuevo Ejercicio")
            .toolbar {
                Button("Guardar") {
                    let nuevoEjercicio = Ejercicio(
                        nombre: nombre,
                        descripcion: descripcion.isEmpty ? nil : descripcion,
                        grupoMuscular: grupoMuscular.isEmpty ? nil : grupoMuscular,
                        seriesDefecto: seriesDefecto,
                        repeticionesDefecto: repeticionesDefecto,
                        pesoDefecto: pesoDefecto
                    )
                    modelContext.insert(nuevoEjercicio)
                    dismiss()
                }
            }
        }
    }
}
