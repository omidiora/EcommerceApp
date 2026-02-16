import SwiftUI

struct OrdersView: View {
    @StateObject private var vm = OrdersViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView()
                } else if let error = vm.errorMessage {
                    Text(error).foregroundStyle(.red)
                } else if vm.orders.isEmpty {
                    Text("No orders yet")
                        .foregroundStyle(.secondary)
                } else {
                    List(vm.orders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Order #\(order.id.prefix(8))")
                                .font(.headline)
                            Text(order.date, style: .date)
                                .foregroundStyle(.secondary)
                            Text("₦\(order.total, specifier: "%.2f") • \(order.items.count) items")
                        }
                    }
                }
            }
            .navigationTitle("My Orders")
            .task { await vm.loadOrders() }
            .refreshable { await vm.loadOrders() }
        }
    }
}
