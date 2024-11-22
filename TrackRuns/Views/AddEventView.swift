import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [RunEvent]
    
    @State private var name = ""
    @State private var date = Date()
    @State private var distance = 0.0
    @State private var location = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations principales")) {
                    TextField("Nom de l'événement", text: $name)
                    DatePicker("Date", selection: $date)
                    HStack {
                        Text("Distance (km)")
                        TextField("Distance", value: $distance, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    TextField("Lieu", text: $location)
                }
                
                Section(header: Text("Notes additionnelles")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Nouvel événement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let newEvent = RunEvent(
                            name: name,
                            date: date,
                            distance: distance,
                            location: location,
                            notes: notes.isEmpty ? nil : notes,
                            imageName: nil
                        )
                        events.append(newEvent)
                        events.sort { $0.date < $1.date }
                        dismiss()
                    }
                    .disabled(name.isEmpty || location.isEmpty || distance == 0)
                }
            }
        }
    }
}

#Preview {
    AddEventView(events: .constant([]))
}