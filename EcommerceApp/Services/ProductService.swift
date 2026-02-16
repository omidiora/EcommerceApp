

import FirebaseFirestore

final class ProductService {
    private let db = Firestore.firestore()
    private let collection = "products"
    
    func fetchProducts() async throws -> [Product] {
        let snapshot = try await db.collection(collection).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Product.self) }
    }
    
    func createProduct(_ product: Product) async throws {
            try db.collection(collection).document(product.id).setData(from: product)
        }
}
