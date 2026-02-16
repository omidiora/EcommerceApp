

import Foundation



struct Order: Codable, Identifiable {
    let id: String
    let items: [CartItem]
    let total: Double
    var date: Date = Date()
    let userId: String
}
