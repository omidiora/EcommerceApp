import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(product.name)
                        .font(.title.bold())
                    
                    Text("₦\(product.price, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundStyle(.green)
                    
                    Text(product.description ?? "No description available.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                Button("Add to Cart") {
                    withAnimation {
                        cartVM.add(product)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
