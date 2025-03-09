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

    var body: some View {
        List(ejercicios) { ejercicio in
            Button(ejercicio.nombre) {
                onSeleccionar(ejercicio)
                dismiss()
            }
        }
        .navigationTitle("Seleccionar Ejercicio")
    }
}
