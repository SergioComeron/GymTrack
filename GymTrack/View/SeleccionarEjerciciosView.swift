//
//  SeleccionarEjerciciosView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct SeleccionarEjerciciosView: View {
    @Query private var ejercicios: [Ejercicio]
    @Binding var seleccionados: [Ejercicio]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(ejercicios) { ejercicio in
                MultipleSelectionRow(ejercicio: ejercicio, isSelected: seleccionados.contains(ejercicio)) {
                    if seleccionados.contains(ejercicio) {
                        seleccionados.removeAll { $0 == ejercicio }
                    } else {
                        seleccionados.append(ejercicio)
                    }
                }
            }
            .navigationTitle("Seleccionar Ejercicios")
            .toolbar {
                Button("Listo") {
                    dismiss()
                }
            }
        }
    }
}

struct MultipleSelectionRow: View {
    let ejercicio: Ejercicio
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(ejercicio.nombre)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
