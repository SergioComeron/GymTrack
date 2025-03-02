//
//  EjerciciosView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct EjerciciosView: View {
    @Query private var ejercicios: [Ejercicio]
    @Environment(\.modelContext) private var modelContext
    @State private var buscarTexto = ""
    @State private var grupoMuscularSeleccionado: String? = nil // nil significa "Todos"
    @State private var mostrarFormulario = false

    // Lista de grupos musculares únicos para el filtro
    private var gruposMusculares: [String] {
        let grupos = ejercicios.compactMap { $0.grupoMuscular }.sorted()
        return Array(Set(grupos)) // Elimina duplicados
    }

    // Ejercicios filtrados según búsqueda y grupo muscular
    private var ejerciciosFiltrados: [Ejercicio] {
        var resultado = ejercicios

        // Filtrar por grupo muscular si está seleccionado
        if let grupo = grupoMuscularSeleccionado {
            resultado = resultado.filter { $0.grupoMuscular == grupo }
        }

        // Filtrar por texto de búsqueda (ignorando mayúsculas/minúsculas)
        if !buscarTexto.isEmpty {
            resultado = resultado.filter { $0.nombre.lowercased().hasPrefix(buscarTexto.lowercased()) }
        }

        return resultado.sorted { $0.nombre < $1.nombre } // Orden alfabético
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Buscador
                TextField("Buscar ejercicios...", text: $buscarTexto)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Filtro por grupo muscular
                Picker("Grupo Muscular", selection: $grupoMuscularSeleccionado) {
                    Text("Todos").tag(String?.none)
                    ForEach(gruposMusculares, id: \.self) { grupo in
                        Text(grupo).tag(String?.some(grupo))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Lista de ejercicios filtrados
                List {
                    ForEach(ejerciciosFiltrados) { ejercicio in
                        NavigationLink(destination: DetalleEjercicioView(ejercicio: ejercicio)) {
                            Text(ejercicio.nombre)
                        }
                    }
                    .onDelete(perform: deleteEjercicios)
                }
            }
            .navigationTitle("Ejercicios")
            .toolbar {
                Button(action: { mostrarFormulario = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                FormularioEjercicioView()
            }
        }
    }

    private func deleteEjercicios(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(ejerciciosFiltrados[index])
        }
    }
}
