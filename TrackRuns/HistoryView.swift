import SwiftUI

struct Run: Identifiable {
    let id = UUID()
    let distance: Double
    let duration: Int // en minutes
    let pace: String
    let date: Date
    let location: String
    let type: RunType
    
    enum RunType: String {
        case footing = "Footing"
        case fractioned = "Fractionné"
        case slowLong = "Sortie longue"
        case race = "Race"
    }
}

struct MonthlyStats: Identifiable {
    let id = UUID()
    let month: Date
    let runs: [Run]
    
    var totalDistance: Double {
        runs.reduce(0) { $0 + $1.distance }
    }
    
    var totalRuns: Int {
        runs.count
    }
    
    var totalDuration: Int {
        runs.reduce(0) { $0 + $1.duration }
    }
}

struct HistoryView: View {
    @State private var runs: [Run] = [
        // Novembre
        Run(
            distance: 7.0,
            duration: 42, // 42 minutes
            pace: "5'36\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 19))!,
            location: "Augsbourg",
            type: .footing
        ),
        Run(
            distance: 10.0,
            duration: 55,
            pace: "5'30\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 15))!,
            location: "Augsbourg",
            type: .fractioned
        ),
        Run(
            distance: 5.0,
            duration: 28,
            pace: "5'36\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 12))!,
            location: "Augsbourg",
            type: .footing
        ),
        
        // Octobre
        Run(
            distance: 21.1,
            duration: 115,
            pace: "5'27\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 29))!,
            location: "Munich",
            type: .race
        ),
        Run(
            distance: 15.0,
            duration: 85,
            pace: "5'40\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 22))!,
            location: "Augsbourg",
            type: .slowLong
        ),
        Run(
            distance: 8.0,
            duration: 45,
            pace: "5'37\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 15))!,
            location: "Augsbourg",
            type: .footing
        ),
        Run(
            distance: 12.0,
            duration: 66,
            pace: "5'30\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 8))!,
            location: "Augsbourg",
            type: .fractioned
        ),

        // Septembre
        Run(
            distance: 18.0,
            duration: 102,
            pace: "5'40\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 24))!,
            location: "Augsbourg",
            type: .slowLong
        ),
        Run(
            distance: 10.0,
            duration: 54,
            pace: "5'24\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 17))!,
            location: "Augsbourg",
            type: .fractioned
        ),
        Run(
            distance: 7.0,
            duration: 40,
            pace: "5'43\"/km",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10))!,
            location: "Augsbourg",
            type: .footing
        )
    ].sorted { $0.date > $1.date } // Tri par date décroissante
    @State private var showingAddRun = false
    
    // Fonction de tri améliorée
    var groupedRuns: [MonthlyStats] {
        let calendar = Calendar.current
        
        // 1. Grouper par mois
        let grouped = Dictionary(grouping: runs) { run in
            // S'assurer que nous prenons le premier jour du mois
            calendar.date(from: calendar.dateComponents([.year, .month], from: run.date))!
        }
        
        // 2. Créer les MonthlyStats et trier
        return grouped.map { (month, monthRuns) in
            // Trier les runs dans chaque mois par date décroissante
            let sortedRuns = monthRuns.sorted { $0.date > $1.date }
            return MonthlyStats(month: month, runs: sortedRuns)
        }
        // 3. Trier les mois par date décroissante
        .sorted { $0.month > $1.month }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(groupedRuns, id: \.month) { monthStats in
                        VStack(spacing: 0) {
                            // En-tête du mois
                            HStack(spacing: 16) {
                                // Partie gauche : Mois et statistiques principales
                                VStack(alignment: .leading, spacing: 8) {
                                    // Mois
                                    Text(monthStats.month.formatted(.dateTime.month(.wide)))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    // Stats principales en ligne
                                    HStack(spacing: 16) {
                                        // Nombre de runs
                                        HStack(spacing: 4) {
                                            Image(systemName: "figure.run")
                                                .foregroundColor(Color("cream"))
                                            Text("\(monthStats.totalRuns)")
                                                .foregroundColor(Color("cream"))
                                                .fontWeight(.semibold)
                                            Text("runs")
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .font(.subheadline)
                                        
                                        // Durée totale
                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .foregroundColor(Color("cream"))
                                            Text("\(monthStats.totalDuration/60)h \(monthStats.totalDuration%60)min")
                                                .foregroundColor(Color("cream"))
                                                .fontWeight(.semibold)
                                        }
                                        .font(.subheadline)
                                    }
                                }
                                
                                Spacer()
                                
                                // Partie droite : Distance totale mise en valeur
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(monthStats.totalDistance, specifier: "%.0f")")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Color("cream"))
                                    Text("kilomètres")
                                        .font(.caption)
                                        .textCase(.uppercase)
                                        .foregroundColor(.white.opacity(0.8))
                                        .tracking(1)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("darkBrown"))
                                    .shadow(color: Color("darkBrown").opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .padding(.top, 16)
                            
                            // Liste des runs du mois
                            ForEach(monthStats.runs) { run in
                                RunRow(run: run)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                            
                            // Ajout d'un padding en bas du dernier élément du mois
                            Spacer()
                                .frame(height: 24)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .top) {
                Color.clear
                    .frame(height: 10)
                    .background(Color(UIColor.systemBackground))
            }
            
            // Bouton d'ajout
            .overlay(alignment: .bottom) {
                Button(action: { 
                    showingAddRun = true
                }) {
                    Text("Add a run")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150)
                        .padding(.vertical, 12)
                        .background(Color("brown"))
                        .cornerRadius(25)
                        .shadow(radius: 3)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddRun) {
            AddRunView(runs: $runs)
        }
    }
}

// Extension pour le formatage des dates
extension Date {
    func startOfMonth(calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }
}

#Preview {
    ContentView()
}
