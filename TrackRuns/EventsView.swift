import SwiftUI

struct EventsView: View {
    @State private var events: [RunEvent] = [
        RunEvent(
            name: "Halbmarathon Hockenheim",
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 23))!,
            distance: 21.1,
            location: "Hockenheim 🇩🇪",
            notes: "Sur le circuit de Formule 1!",
            imageName: "hockenheim"
        ),
        RunEvent(
            name: "Marathon de Vienne",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 04, day: 6))!,
            distance: 42.2,
            location: "Vienne 🇦🇹",
            notes: "Premier marathon",
            imageName: "vienne"
        ),
        RunEvent(
            name: "Semi-marathon SPA",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 8))!,
            distance: 21.1,
            location: "Spa 🇧🇪",
            notes: "Circuit de Formule 1!",
            imageName: "spa"
        )
    ].sorted { $0.date < $1.date }
    
    @State private var showingAddEvent = false
    @State private var filterOption: FilterOption = .date
    @State private var sortOrder: SortOrder = .ascending
    
    enum SortOrder {
        case ascending
        case descending
    }
    
    enum FilterOption {
        case date
        case distance
        case location
        
        var label: String {
            switch self {
            case .date: return "Date"
            case .distance: return "Distance"
            case .location: return "Ville"
            }
        }
    }
    
    func getDistanceBadge(distance: Double) -> (String, Color) {
        switch distance {
        case 42...43:
            return ("Marathon", .red)
        case 21...21.5:
            return ("Semi", .orange)
        case 15...16:
            return ("15 km", .blue)
        case 10...10.5:
            return ("10 km", .green)
        case 5...5.5:
            return ("5 km", .mint)
        default:
            return ("Course", .gray)
        }
    }
    
    func daysUntilEvent(_ date: Date) -> String {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfEventDay = calendar.startOfDay(for: date)
        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfEventDay).day ?? 0
        
        switch days {
        case 0:
            return "Aujourd'hui"
        case 1:
            return "Demain"
        case ..<0:
            return "Événement passé"
        default:
            return "Dans \(days) jours"
        }
    }
    
    var filteredEvents: [RunEvent] {
        switch filterOption {
        case .date:
            return events.sorted { 
                sortOrder == .ascending ? $0.date < $1.date : $0.date > $1.date 
            }
        case .distance:
            return events.sorted { 
                sortOrder == .ascending ? $0.distance < $1.distance : $0.distance > $1.distance 
            }
        case .location:
            return events.sorted { 
                sortOrder == .ascending ? $0.location < $1.location : $0.location > $1.location 
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(filteredEvents) { event in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("darkBrown"))
                                Text(event.location)
                                    .font(.subheadline)
                                    .foregroundColor(Color("brown"))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                let badge = getDistanceBadge(distance: event.distance)
                                Text(badge.0)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(badge.1)
                                    .cornerRadius(8)
                                
                                Text("\(event.distance, specifier: "%.1f")")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("darkBrown")) +
                                Text(" km")
                                    .font(.subheadline)
                                    .foregroundColor(Color("brown"))
                            }
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color("brown"))
                            VStack(alignment: .leading) {
                                Text(event.date.formatted(
                                    .dateTime
                                        .locale(Locale(identifier: "fr_FR"))
                                        .day().month(.wide).year()
                                ))
                                Text(event.date.formatted(
                                    .dateTime
                                        .locale(Locale(identifier: "fr_FR"))
                                        .hour().minute()
                                ))
                            }
                            .font(.subheadline)
                            .foregroundColor(Color("brown"))
                            
                            Spacer()
                            
                            Image(systemName: "clock")
                                .foregroundColor(Color("brown"))
                            Text(daysUntilEvent(event.date))
                                .font(.subheadline)
                                .foregroundColor(daysUntilEvent(event.date) == "Événement passé" ? 
                                    .red : 
                                    Color("brown"))
                        }
                        
                        if let imageName = event.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                                .clipped()
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                        
                        if let notes = event.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.footnote)
                                .foregroundColor(Color("brown"))
                                .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("cream"))
                            .shadow(color: Color("brown").opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .safeAreaInset(edge: .top) {
                    Color.clear
                        .frame(height: 10)
                        .background(Color(UIColor.systemBackground))
                }
                
                VStack {
                    Spacer()
                    .overlay(alignment: .bottom) {
                        Button(action: { 
                            showingAddEvent = true
                        }) {
                            Text("Add an event")
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
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(events: $events)
            }
        }
    }
}

#Preview {
    EventsView()
} 
