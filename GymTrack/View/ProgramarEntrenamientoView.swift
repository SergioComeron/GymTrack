//
//  ProgramarEntrenamientoView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftUI
import SwiftData

struct ProgramarEntrenamientoView: View {
    @State private var nombreEntrenamiento: String = ""
    @State private var ejerciciosSeleccionados: [EjercicioProgramado] = []
    @State private var mostrarSelectorEjercicios: Bool = false
    @State private var estadoInicial: (String, [EjercicioProgramado]) = ("", [])
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var ejercicios: [Ejercicio]

    var body: some View {
        Form {
            Section(header: Text("Nombre del Entrenamiento")) {
                TextField("Ej: Pierna, Pecho y Tríceps...", text: $nombreEntrenamiento)
            }
            
            Section(header: Text("Añadir Ejercicios")) {
                ForEach(ejerciciosSeleccionados.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(ejerciciosSeleccionados[index].ejercicio.nombre)
                            .font(.headline)
                        
                        ForEach(ejerciciosSeleccionados[index].seriesPlanificadas.indices, id: \.self) { serieIndex in
                            HStack {
                                TextField("Reps", value: $ejerciciosSeleccionados[index].seriesPlanificadas[serieIndex].repeticiones, format: .number)
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                
                                TextField("Kg", value: $ejerciciosSeleccionados[index].seriesPlanificadas[serieIndex].pesoEstimado, format: .number)
                                    .keyboardType(.decimalPad)
                                    .frame(width: 70)

                                Spacer()

                                Button(action: {
                                    ejerciciosSeleccionados[index].seriesPlanificadas.remove(at: serieIndex)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }

                                if serieIndex == ejerciciosSeleccionados[index].seriesPlanificadas.count - 1 {
                                    Button(action: {
                                        let nuevaSerie = SeriePlanificada(repeticiones: 10, orden: ejerciciosSeleccionados[index].seriesPlanificadas.count + 1)
                                        ejerciciosSeleccionados[index].seriesPlanificadas.append(nuevaSerie)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button("Agregar Ejercicio") {
                    mostrarSelectorEjercicios = true
                }
            }
            
            Section {
                Button("Guardar Entrenamiento") {
                    let nuevoEntrenamiento = EntrenamientoProgramado(
                        nombre: nombreEntrenamiento,
                        ejerciciosProgramados: ejerciciosSeleccionados
                    )
                    modelContext.insert(nuevoEntrenamiento)
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error al guardar: \(error)")
                    }
                    // Reiniciar la vista después de guardar
                    nombreEntrenamiento = ""
                    ejerciciosSeleccionados = []
                    estadoInicial = ("", [])
                }
                .disabled(nombreEntrenamiento.isEmpty || ejerciciosSeleccionados.isEmpty)
            }
            
            Section {
                Button("Cancelar", role: .destructive) {
                    (nombreEntrenamiento, ejerciciosSeleccionados) = estadoInicial
                    dismiss()
                }
            }
        }
        .onAppear {
            estadoInicial = (nombreEntrenamiento, ejerciciosSeleccionados)
        }
        .sheet(isPresented: $mostrarSelectorEjercicios) {
            SelectorEjercicioView { ejercicio in
                let nuevoEjercicioProgramado = EjercicioProgramado(
                    ejercicio: ejercicio,
                    orden: ejerciciosSeleccionados.count + 1,
                    seriesPlanificadas: [SeriePlanificada(repeticiones: 10, orden: 1)]
                )
                ejerciciosSeleccionados.append(nuevoEjercicioProgramado)
            }
        }
        .navigationTitle("Nuevo Entrenamiento")
    }
}
