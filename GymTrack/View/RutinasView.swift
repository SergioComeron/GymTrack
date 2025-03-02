//
//  RutinasView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct RutinasView: View {
    @Query private var rutinas: [Rutina]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(rutinas) { rutina in
                    NavigationLink(destination: DetalleRutinaView(rutina: rutina)) {
                        Text(rutina.nombre)
                    }
                }
                .onDelete(perform: deleteRutinas)
            }
            .navigationTitle("Rutinas")
            .toolbar {
                NavigationLink(destination: CrearRutinaView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func deleteRutinas(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(rutinas[index])
        }
    }
}
