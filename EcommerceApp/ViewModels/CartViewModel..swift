

import Foundation
import Combine

import FirebaseAuth

@MainActor
final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var isPlacingOrder = false
    @Published var orderSuccess = false
    @Published var orderError: String?
    
    private let cartService = CartService()
    private let orderService = OrderService()
    
    var total: Double {
        items.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    init() {
        items = cartService.load()
    }
    
    func add(_ product: Product) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(id: product.id, product: product))
        }
        save()
    }
    
    func updateQuantity(_ item: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if quantity > 0 {
            items[index].quantity = quantity
        } else {
            items.remove(at: index)
        }
        save()
    }
    
    func remove(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    func placeOrder() async {
        guard let userId = Auth.auth().currentUser?.uid, total > 0 else {
            orderError = "Unable to place order"
            return
        }
        
        isPlacingOrder = true
        orderError = nil
        orderSuccess = false
        
        let order = Order(id: UUID().uuidString, items: items, total: total, userId: userId)
        do {
            try await orderService.placeOrder(order)
            orderSuccess = true
            items.removeAll()
            save()
        } catch {
            orderError = "Order failed: \(error.localizedDescription)"
        }
        isPlacingOrder = false
    }
    
    private func save() {
        cartService.save(items)
    }
}
