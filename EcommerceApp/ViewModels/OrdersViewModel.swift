
import Foundation
import FirebaseAuth
import Combine

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = OrderService()
    
    func loadOrders() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not authenticated"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            orders = try await service.fetchOrders(for: userId)
        } catch {
            errorMessage = "Failed to load orders"
        }
        isLoading = false
    }
}
