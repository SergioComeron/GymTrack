//
//  Home.swift
//  GymTrack
//
//  Created by Sergio Comerón on 4/3/25.
//
import SwiftUI
import SwiftData

struct Home: View {
    @Query private var ejerciciosEntrenamientos: [EjercicioEntrenamiento]
    
    // Formateador de fecha
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Ejemplo: "Mar 4, 2025"
        formatter.timeStyle = .short  // Ejemplo: "14:30"
        return formatter
    }()
    
    // Entrenamientos ordenados por fecha
    var entrenamientosOrdenados: [EjercicioEntrenamiento] {
        ejerciciosEntrenamientos.sorted { $0.fecha > $1.fecha } // Más reciente primero
    }
    
    // Función para formatear las series como "4x15" o "4x15,12,10,8" en orden de fecha
    private func formatoSeries(_ series: [Serie]) -> String {
        guard !series.isEmpty else { return "Sin series" }
        
        // Ordenar las series por fecha (más antigua primero), manejando fechas nulas
        let seriesOrdenadas = series.sorted { ($0.fecha ?? Date.distantFuture) < ($1.fecha ?? Date.distantFuture) }
        let repeticiones = seriesOrdenadas.map { $0.repeticiones }
        let numeroSeries = series.count
        
        // Verificar si todas las repeticiones son iguales
        if repeticiones.allSatisfy({ $0 == repeticiones.first }) {
            return "\(numeroSeries)x\(repeticiones.first!)" // Ejemplo: "4x15"
        } else {
            return "\(numeroSeries)x\(repeticiones.map(String.init).joined(separator: ","))" // Ejemplo: "4x15,12,10,8"
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(entrenamientosOrdenados) { ejercicioEntrenamiento in
                    NavigationLink(destination: EjercicioView(ejercicio: ejercicioEntrenamiento.ejercicio)) {
                        HStack(alignment: .center, spacing: 12) {
                            // Ícono representativo (opcional)
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                // Nombre del ejercicio
                                Text(ejercicioEntrenamiento.ejercicio.nombre)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                // Fecha del entrenamiento
                                Text(dateFormatter.string(from: ejercicioEntrenamiento.fecha))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                // Resumen de series y peso máximo
                                Text("\(formatoSeries(ejercicioEntrenamiento.series)) | Peso máx: \(ejercicioEntrenamiento.series.max(by: { $0.peso < $1.peso })?.peso ?? 0.0, specifier: "%.2f") kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer() // Deja el chevron del sistema a la derecha
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Mis Entrenamientos")
            .listStyle(.plain) // O .insetGrouped si prefieres
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Ejercicio.self, EjercicioEntrenamiento.self, Serie.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let context = container.mainContext
    
    let ejercicio1 = Ejercicio(
        nombre: "Press de Banca",
        descripcion: "Ejercicio para trabajar el pectoral mayor",
        grupoMuscular: "Pecho"
    )
    let ejercicio2 = Ejercicio(
        nombre: "Sentadillas",
        descripcion: "Ejercicio para piernas",
        grupoMuscular: "Cuádriceps"
    )
    context.insert(ejercicio1)
    context.insert(ejercicio2)
    
    // Entrenamiento con repeticiones uniformes
    let entrenamiento1 = EjercicioEntrenamiento(
        fecha: Date(),
        ejercicio: ejercicio1,
        series: [
            Serie(repeticiones: 15, peso: 80.0, fecha: Date()),
            Serie(repeticiones: 15, peso: 82.5, fecha: Calendar.current.date(byAdding: .minute, value: 1, to: Date())!),
            Serie(repeticiones: 15, peso: 85.0, fecha: Calendar.current.date(byAdding: .minute, value: 2, to: Date())!),
            Serie(repeticiones: 15, peso: 87.5, fecha: Calendar.current.date(byAdding: .minute, value: 3, to: Date())!)
        ]
    )
    // Entrenamiento con repeticiones variables (ordenado por fecha)
    let entrenamiento2 = EjercicioEntrenamiento(
        fecha: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        ejercicio: ejercicio2,
        series: [
            Serie(repeticiones: 15, peso: 100.0, fecha: Calendar.current.date(byAdding: .minute, value: -4, to: Date())!),
            Serie(repeticiones: 12, peso: 105.0, fecha: Calendar.current.date(byAdding: .minute, value: -3, to: Date())!),
            Serie(repeticiones: 10, peso: 110.0, fecha: Calendar.current.date(byAdding: .minute, value: -2, to: Date())!),
            Serie(repeticiones: 8, peso: 115.0, fecha: Calendar.current.date(byAdding: .minute, value: -1, to: Date())!)
        ]
    )
    context.insert(entrenamiento1)
    context.insert(entrenamiento2)
    
    try? context.save()
    
    return Home()
        .modelContainer(container)
}
