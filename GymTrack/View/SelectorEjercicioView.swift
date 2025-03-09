//
//  SelectorEjercicioView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftUI
import SwiftData

struct SelectorEjercicioView: View {
    @Query private var ejercicios: [Ejercicio]
    @Environment(\.dismiss) private var dismiss
    var onSeleccionar: (Ejercicio) -> Void

    @State private var grupoMuscularSeleccionado: String = "Todos"

    var gruposMusculares: [String] {
        let grupos = Set(ejercicios.compactMap { $0.grupoMuscular }) // Filtra los nil
        return ["Todos"] + grupos.sorted()
    }

    var ejerciciosFiltrados: [Ejercicio] {
        if grupoMuscularSeleccionado == "Todos" {
            return ejercicios
        } else {
            return ejercicios.filter { $0.grupoMuscular == grupoMuscularSeleccionado }
        }
    }

    var body: some View {
        VStack {
            Picker("Grupo Muscular", selection: $grupoMuscularSeleccionado) {
                ForEach(gruposMusculares, id: \.self) { grupo in
                    Text(grupo).tag(grupo)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            List(ejerciciosFiltrados) { ejercicio in
                Button(ejercicio.nombre) {
                    onSeleccionar(ejercicio)
                    dismiss()
                }
            }
        }
        .navigationTitle("Seleccionar Ejercicio")
    }
}
