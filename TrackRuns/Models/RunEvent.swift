import Foundation

struct RunEvent: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var distance: Double
    var location: String
    var notes: String?
    var imageName: String?
}