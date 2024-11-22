import SwiftUI

struct AddRunView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var runs: [Run]
    
    @State private var distance = 0.0
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var date = Date()
    @State private var location = ""
    @State private var selectedType: Run.RunType = .footing
    
    let runTypes: [Run.RunType] = [.footing, .fractioned, .slowLong, .race]
    
    // Calcul du pace
    var paceString: String {
        let totalMinutes = (hours * 60) + minutes + (seconds / 60)
        if distance > 0 && totalMinutes > 0 {
            let paceMinutes = Int(Double(totalMinutes) / distance)
            let paceSeconds = Int((Double(totalMinutes) / distance * 60).truncatingRemainder(dividingBy: 60))
            return String(format: "%d'%02d\"/km", paceMinutes, paceSeconds)
        }
        return "--'--\"/km"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Distance et Temps") {
                    HStack {
                        Text("Distance (km)")
                        Spacer()
                        TextField("0.0", value: $distance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Durée")
                        Spacer()
                        HStack(spacing: 0) {
                            TextField("00", value: $hours, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 40)
                            Text("h")
                            TextField("00", value: $minutes, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 40)
                            Text("m")
                            TextField("00", value: $seconds, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 40)
                            Text("s")
                        }
                    }
                    
                    HStack {
                        Text("Pace")
                        Spacer()
                        Text(paceString)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Type de course") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(runTypes, id: \.self) { type in
                            HStack {
                                Circle()
                                    .fill(typeColor(for: type))
                                    .frame(width: 12, height: 12)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.inline)
                }
                
                Section("Détails") {
                    DatePicker("Date", selection: $date)
                    TextField("Lieu", text: $location)
                }
            }
            .navigationTitle("Nouvelle course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let totalMinutes = (hours * 60) + minutes
                        let newRun = Run(
                            distance: distance,
                            duration: totalMinutes,
                            pace: paceString,
                            date: date,
                            location: location,
                            type: selectedType
                        )
                        runs.append(newRun)
                        dismiss()
                    }
                    .disabled(distance == 0 || (hours == 0 && minutes == 0 && seconds == 0) || location.isEmpty)
                }
            }
        }
    }
    
    func typeColor(for type: Run.RunType) -> Color {
        switch type {
        case .footing: return .green       // Vert système pour le footing (course légère)
        case .fractioned: return .blue     // Bleu système pour le fractionné (intensité)
        case .slowLong: return .indigo     // Indigo système pour la sortie longue
        case .race: return .red            // Rouge système pour la course/compétition
        }
    }
}

#Preview {
    AddRunView(runs: .constant([]))
} 