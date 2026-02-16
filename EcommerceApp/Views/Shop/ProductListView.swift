import SwiftUI

struct ProductListView: View {
    @StateObject private var vm = ProductListViewModel()
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading products...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errorMessage {
                    VStack(spacing: 16) {
                        Text(error)
                            .foregroundStyle(.red)
                        Button("Retry") { Task { await vm.loadProducts() } }
                            .buttonStyle(.bordered)
                    }
                } else if vm.products.isEmpty {
                    Text("No products available. Add one!")
                } else {
                    List(vm.products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRowView(product: product)
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CartView()
                    } label: {
                        Label("\(cartVM.items.count)", systemImage: "cart")
                    }
                }
            }
            .task { await vm.loadProducts() }
            .refreshable { await vm.loadProducts() }
            // NEW: Floating Action Button to create product
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    CreateProductView()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
        }
    }
}
