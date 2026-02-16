
import Foundation



struct Product: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String?
    let price: Double
    let imageUrl: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case imageUrl = "image_url"
        case category
    }
}
