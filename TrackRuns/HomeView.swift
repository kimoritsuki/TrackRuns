import SwiftUI

struct StatRow: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(Color("brown"))
                    .frame(width: 26, height: 26)
                    .background(
                        Circle()
                            .fill(Color("brown").opacity(0.1))
                    )
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("darkBrown"))
            }
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(Color("darkBrown")) +
            Text(" \(unit)")
                .font(.caption)
                .foregroundColor(Color("brown"))
        }
        .padding(.vertical, 8)
    }
}

struct HomeView: View {
    @State private var selectedPeriod: StatsPeriod = .week
    @State private var runs: [Run] = HistoryView().runs
    
    enum StatsPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
    }
    
    func filteredRuns() -> [Run] {
        let calendar = Calendar.current
        let now = Date()
        
        return runs.filter { run in
            switch selectedPeriod {
            case .week:
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                return run.date >= startOfWeek
                
            case .month:
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
                return run.date >= startOfMonth
                
            case .year:
                let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
                return run.date >= startOfYear
                
            case .all:
                return true
            }
        }
    }
    
    var stats: (runs: Int, distance: Double, duration: String, pace: String) {
        let filtered = filteredRuns()
        
        let totalRuns = filtered.count
        let totalDistance = filtered.reduce(0) { $0 + $1.distance }
        let totalDurationMinutes = filtered.reduce(0) { $0 + $1.duration }
        
        let hours = totalDurationMinutes / 60
        let minutes = totalDurationMinutes % 60
        let durationString = "\(hours)h \(minutes)"
        
        let averagePace = totalDistance > 0 ? Double(totalDurationMinutes) / totalDistance : 0
        let paceMinutes = Int(averagePace)
        let paceSeconds = Int((averagePace - Double(paceMinutes)) * 60)
        let paceString = String(format: "%d'%02d\"", paceMinutes, paceSeconds)
        
        return (totalRuns, totalDistance, durationString, paceString)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("My stats")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("darkBrown"))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(spacing: 0) {
                    ForEach(StatsPeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation {
                                selectedPeriod = period
                            }
                        }) {
                            Text(period.rawValue)
                                .font(.caption)
                                .fontWeight(selectedPeriod == period ? .semibold : .regular)
                                .foregroundColor(selectedPeriod == period ? .white : Color("brown"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedPeriod == period ? Color("brown") : Color.clear)
                                )
                        }
                    }
                }
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("cream"))
                )
                .padding(.horizontal)
                
                VStack(spacing: 4) {
                    StatRow(
                        title: "Runs",
                        value: "\(stats.runs)",
                        unit: "runs",
                        icon: "figure.run"
                    )
                    
                    Divider()
                        .background(Color("brown").opacity(0.15))
                        .padding(.horizontal, 8)
                    
                    StatRow(
                        title: "Distance",
                        value: String(format: "%.0f", stats.distance),
                        unit: "km",
                        icon: "arrow.left.and.right"
                    )
                    
                    Divider()
                        .background(Color("brown").opacity(0.15))
                        .padding(.horizontal, 8)
                    
                    StatRow(
                        title: "Time",
                        value: stats.duration,
                        unit: "min",
                        icon: "clock"
                    )
                    
                    Divider()
                        .background(Color("brown").opacity(0.15))
                        .padding(.horizontal, 8)
                    
                    StatRow(
                        title: "Speed",
                        value: stats.pace,
                        unit: "/km",
                        icon: "speedometer"
                    )
                    
                    Divider()
                        .background(Color("brown").opacity(0.15))
                        .padding(.horizontal, 8)
                    
                    StatRow(
                        title: "FC",
                        value: "151",
                        unit: "bpm",
                        icon: "heart"
                    )
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("cream"))
                        .shadow(
                            color: Color("brown").opacity(0.1),
                            radius: 10,
                            x: 0,
                            y: 3
                        )
                )
                .padding(.horizontal)
            }
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    HomeView()
}
