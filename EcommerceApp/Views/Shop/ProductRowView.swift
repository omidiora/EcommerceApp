import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                switch phase {
                case .empty: Color.gray.opacity(0.3)
                case .success(let image): image.resizable().scaledToFill()
                case .failure: Image(systemName: "photo").foregroundStyle(.gray)
                @unknown default: EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                Text(product.category ?? "General")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("₦\(product.price, specifier: "%.2f")")
                    .font(.title3.bold())
                    .foregroundStyle(.green)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
