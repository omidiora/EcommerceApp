import SwiftUI

struct CartView: View {
    @EnvironmentObject var vm: CartViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if vm.items.isEmpty {
                    Text("Your cart is empty")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(vm.items) { item in
                        CartRowView(item: item)
                    }
                    .onDelete { indices in
                        indices.forEach { vm.remove(vm.items[$0]) }
                    }
                    
                    Section {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("₦\(vm.total, specifier: "%.2f")")
                                .font(.title2.bold())
                        }
                        
                        Button("Place Order") {
                            Task { await vm.placeOrder() }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(vm.isPlacingOrder || vm.total == 0)
                    }
                    
                    if vm.isPlacingOrder {
                        ProgressView("Processing...")
                    }
                    
                    if let error = vm.orderError {
                        Text(error).foregroundStyle(.red)
                    }
                    
                    if vm.orderSuccess {
                        Text("Order placed successfully!")
                            .foregroundStyle(.green)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    dismiss()
                                }
                            }
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
}
