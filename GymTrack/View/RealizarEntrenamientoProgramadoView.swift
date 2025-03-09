//
//  RealizarEntrenamientoProgramado.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftUI
import SwiftData

struct RealizarEntrenamientoProgramadoView: View {
    let entrenamiento: EntrenamientoProgramado
    @State private var ejerciciosRealizados: [EjercicioEntrenamiento] = []
    @State private var seriesRealizadas: Set<UUID> = []
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let userDefaultsKey: String

    init(entrenamiento: EntrenamientoProgramado) {
        self.entrenamiento = entrenamiento
        self.userDefaultsKey = "seriesRealizadas_\(entrenamiento.id.uuidString)"
    }

    var body: some View {
        List {
            ForEach(entrenamiento.ejerciciosProgramados) { ejercicioProgramado in
                Section(header: Text(ejercicioProgramado.ejercicio.nombre)) {
                    ForEach(ejercicioProgramado.seriesPlanificadas.sorted(by: { ($0.orden ?? Int.max) < ($1.orden ?? Int.max) }), id: \.id) { seriePlanificada in
                        HStack {                            
                            TextField("Reps", value: Binding(
                                get: { seriePlanificada.repeticiones },
                                set: { nuevoValor in
                                    if let indexEjercicio = entrenamiento.ejerciciosProgramados.firstIndex(where: { $0.id == ejercicioProgramado.id }),
                                       let indexSerie = entrenamiento.ejerciciosProgramados[indexEjercicio].seriesPlanificadas.firstIndex(where: { $0.id == seriePlanificada.id }) {
                                        entrenamiento.ejerciciosProgramados[indexEjercicio].seriesPlanificadas[indexSerie].repeticiones = nuevoValor
                                    }
                                }
                            ), format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 50)

                            TextField("Peso", value: Binding(
                                get: { seriePlanificada.pesoEstimado ?? 0 },
                                set: { nuevoValor in
                                    if let indexEjercicio = entrenamiento.ejerciciosProgramados.firstIndex(where: { $0.id == ejercicioProgramado.id }),
                                       let indexSerie = entrenamiento.ejerciciosProgramados[indexEjercicio].seriesPlanificadas.firstIndex(where: { $0.id == seriePlanificada.id }) {
                                        entrenamiento.ejerciciosProgramados[indexEjercicio].seriesPlanificadas[indexSerie].pesoEstimado = nuevoValor
                                    }
                                }
                            ), format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 70)

                            Button(action: {
                                let nuevaSerie = Serie(
                                    repeticiones: seriePlanificada.repeticiones,
                                    peso: seriePlanificada.pesoEstimado ?? 0,
                                    fecha: Date()
                                )
                                if let index = ejerciciosRealizados.firstIndex(where: { $0.ejercicio == ejercicioProgramado.ejercicio }) {
                                    ejerciciosRealizados[index].series.append(nuevaSerie)
                                } else {
                                    let nuevoEjercicioEntrenamiento = EjercicioEntrenamiento(
                                        fecha: Date(),
                                        ejercicio: ejercicioProgramado.ejercicio,
                                        series: [nuevaSerie]
                                    )
                                    ejerciciosRealizados.append(nuevoEjercicioEntrenamiento)
                                }
                                seriesRealizadas.insert(seriePlanificada.id)
                                saveSeriesRealizadas()
                            }) {
                                Text(seriesRealizadas.contains(seriePlanificada.id) ? "✅" : "⏳")
                            }
                            .disabled(seriesRealizadas.contains(seriePlanificada.id))
                        }
                    }
                }
            }
        }
        .onAppear {
            loadSeriesRealizadas()
        }
        .toolbar {
            Button("Guardar") {
                for ejercicioRealizado in ejerciciosRealizados {
                    modelContext.insert(ejercicioRealizado)
                }
                do {
                    try modelContext.save()
                } catch {
                    print("Error al guardar: \(error)")
                }
                // Reiniciar las series registradas
                seriesRealizadas.removeAll()
                UserDefaults.standard.removeObject(forKey: userDefaultsKey)
                dismiss()
            }
        }
        .navigationTitle(entrenamiento.nombre)
    }

    private func saveSeriesRealizadas() {
        if let encoded = try? JSONEncoder().encode(Array(seriesRealizadas)) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadSeriesRealizadas() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(Set<UUID>.self, from: savedData) {
            seriesRealizadas = decoded
        }
    }
}
