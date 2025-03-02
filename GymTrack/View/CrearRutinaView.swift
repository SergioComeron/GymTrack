//
//  CrearRutinaView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI

struct CrearRutinaView: View {
    @State private var nombre = ""
    @State private var descripcion = ""
    @State private var ejerciciosSeleccionados: [Ejercicio] = []
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $nombre)
                    TextField("Descripción", text: $descripcion)
                }
                Section(header: Text("Ejercicios")) {
                    ForEach(ejerciciosSeleccionados) { ejercicio in
                        Text(ejercicio.nombre)
                    }
                    NavigationLink(destination: SeleccionarEjerciciosView(seleccionados: $ejerciciosSeleccionados)) {
                        Text("Agregar Ejercicios")
                    }
                }
            }
            .navigationTitle("Nueva Rutina")
            .toolbar {
                Button("Guardar") {
                    let nuevaRutina = Rutina(nombre: nombre, descripcion: descripcion, ejercicios: ejerciciosSeleccionados)
                    modelContext.insert(nuevaRutina)
                    dismiss()
                }
            }
        }
    }
}
