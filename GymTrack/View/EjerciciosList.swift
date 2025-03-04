//
//  EjerciciosList.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//


import SwiftUI
import SwiftData

struct EjerciciosList: View {
    @State var textoBuscar: String = ""
    @State var gruposMuscularesSeleccionados: Set<String> = []
    @Query private var ejercicios: [Ejercicio]

    // Propiedad computada para obtener los grupos musculares únicos de los ejercicios
    var gruposMuscularesDisponibles: [String] {
        // Extraer los grupos únicos, filtrar nulos y ordenarlos
        let grupos = Set(ejercicios.compactMap { $0.grupoMuscular })
        return grupos.sorted()
    }

    // Propiedad computada para filtrar ejercicios
    var ejerciciosFiltrados: [Ejercicio] {
        var resultado = ejercicios

        // Filtrar por texto de búsqueda
        if !textoBuscar.isEmpty {
            resultado = resultado.filter { $0.nombre.localizedCaseInsensitiveContains(textoBuscar) }
        }

        // Filtrar por grupos musculares seleccionados
        if !gruposMuscularesSeleccionados.isEmpty {
            resultado = resultado.filter {
                guard let grupoMuscular = $0.grupoMuscular else { return false }
                return gruposMuscularesSeleccionados.contains(grupoMuscular)
            }
        }

        return resultado
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Selector de grupos musculares dinámico
                if !gruposMuscularesDisponibles.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(gruposMuscularesDisponibles, id: \.self) { grupo in
                                Button(action: {
                                    if gruposMuscularesSeleccionados.contains(grupo) {
                                        gruposMuscularesSeleccionados.remove(grupo)
                                    } else {
                                        gruposMuscularesSeleccionados.insert(grupo)
                                    }
                                }) {
                                    Text(grupo)
                                        .padding(8)
                                        .background(gruposMuscularesSeleccionados.contains(grupo) ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(gruposMuscularesSeleccionados.contains(grupo) ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No hay grupos musculares disponibles")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Lista de ejercicios filtrados
                List(ejerciciosFiltrados) { ejercicio in
                    NavigationLink(destination: EjercicioView(ejercicio: ejercicio)) {
                        Text(ejercicio.nombre)
                    }
                }
                .searchable(text: $textoBuscar)
            }
            .navigationTitle("Ejercicios")
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Ejercicio.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let context = container.mainContext
    cargarDatosIniciales(context: context)
    
    return EjerciciosList()
        .modelContainer(container)
}
