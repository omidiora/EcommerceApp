

import Foundation



struct CartItem: Codable, Identifiable {
    let id: String
    let product: Product
    var quantity: Int = 1
}
