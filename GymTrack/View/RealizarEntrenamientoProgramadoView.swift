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

    var body: some View {
        List {
            ForEach(entrenamiento.ejerciciosProgramados) { ejercicioProgramado in
                Section(header: Text(ejercicioProgramado.ejercicio.nombre)) {
                    ForEach(ejercicioProgramado.seriesPlanificadas.indices, id: \.self) { index in
                        let seriePlanificada = ejercicioProgramado.seriesPlanificadas[index]
                        HStack {
                            Text("\(seriePlanificada.repeticiones) reps")
                            Spacer()
                            TextField("Peso", value: Binding(
                                get: { ejercicioProgramado.seriesPlanificadas[index].pesoEstimado ?? 0 },
                                set: { nuevoValor in
                                    ejercicioProgramado.seriesPlanificadas[index].pesoEstimado = nuevoValor
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
                            }) {
                                Text(seriesRealizadas.contains(seriePlanificada.id) ? "✅" : "⏳")
                            }
                            .disabled(seriesRealizadas.contains(seriePlanificada.id))
                        }
                    }
                }
            }
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
                dismiss()
            }
        }
        .navigationTitle(entrenamiento.nombre)
    }
}
