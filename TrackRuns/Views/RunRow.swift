import SwiftUI

struct RunRow: View {
    let run: Run
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 16) {
                // Partie gauche : Distance et badge de type
                VStack(alignment: .leading, spacing: 8) {
                    // Distance principale
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(run.distance, specifier: "%.1f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("darkBrown"))
                        Text("km")
                            .font(.subheadline)
                            .foregroundColor(Color("brown"))
                    }
                    
                    // Badge du type de course
                    Text(run.type.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(typeColor(for: run.type))
                        .cornerRadius(20)
                }
                
                Spacer()
                
                // Partie droite : Durée et pace
                VStack(alignment: .trailing, spacing: 8) {
                    // Durée avec icône
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(Color("brown"))
                        Text("\(run.duration) min")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color("brown"))
                    
                    // Pace avec icône
                    HStack(spacing: 4) {
                        Image(systemName: "speedometer")
                            .foregroundColor(Color("brown"))
                        Text(run.pace)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color("brown"))
                }
                .font(.subheadline)
            }
            
            // Séparateur subtil
            Rectangle()
                .fill(Color("brown").opacity(0.1))
                .frame(height: 1)
            
            // Pied de carte : Date et lieu
            HStack(spacing: 12) {
                // Date avec icône
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("brown"))
                    Text(run.date.formatted(.dateTime.day().month(.abbreviated)))
                }
                
                // Lieu avec icône
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Color("brown"))
                    Text(run.location)
                }
            }
            .font(.caption)
            .foregroundColor(Color("brown"))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("cream"))
                .shadow(color: Color("brown").opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    func typeColor(for type: Run.RunType) -> Color {
        switch type {
        case .footing: return .green
        case .fractioned: return .blue
        case .slowLong: return .indigo
        case .race: return .red
        }
    }
}

#Preview {
    RunRow(run: Run(
        distance: 10.0,
        duration: 60,
        pace: "6'00\"/km",
        date: Date(),
        location: "Augsbourg",
        type: .footing
    ))
    .padding()
} 