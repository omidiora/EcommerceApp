

import Foundation

import FirebaseFirestore

final class OrderService {
    private let db = Firestore.firestore()
    
    func placeOrder(_ order: Order) async throws {
        try db.collection("orders").document(order.id).setData(from: order)
    }
    
    func fetchOrders(for userId: String) async throws -> [Order] {
        let snapshot = try await db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Order.self) }
    }
}
