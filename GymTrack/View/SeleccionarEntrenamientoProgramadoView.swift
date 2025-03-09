//
//  SeleccionarEntrenamientoProgramadoView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftUI
import SwiftData

struct SeleccionarEntrenamientoProgramadoView: View {
    @Query private var entrenamientosProgramados: [EntrenamientoProgramado]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                if entrenamientosProgramados.isEmpty {
                    Text("No hay entrenamientos programados.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(entrenamientosProgramados) { entrenamiento in
                        NavigationLink(destination: RealizarEntrenamientoProgramadoView(entrenamiento: entrenamiento)) {
                            VStack(alignment: .leading) {
                                Text(entrenamiento.nombre)
                                    .font(.headline)
                                Text("Creado el \(formatearFecha(entrenamiento.fechaCreacion))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Entrenamientos Programados")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cerrar") {
//                        dismiss()
//                    }
//                }
//            }
        }
    }
    
    // Función para formatear la fecha
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: fecha)
    }
}

#Preview {
    SeleccionarEntrenamientoProgramadoView()
}
