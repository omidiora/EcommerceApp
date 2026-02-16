
import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = ProductService()
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            products = try await service.fetchProducts()
        } catch {
            errorMessage = "Failed to load products. Check your connection and try again."
        }
        isLoading = false
    }
}
