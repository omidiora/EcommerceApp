import SwiftUI

struct CartRowView: View {
    let item: CartItem
    @EnvironmentObject var cartVM: CartViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit()
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .font(.headline)
                Text("₦\(item.product.price, specifier: "%.2f") each")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Stepper(value: Binding(
                get: { item.quantity },
                set: { cartVM.updateQuantity(item, quantity: $0) }
            ), in: 1...99) {
                Text("\(item.quantity)")
                    .font(.headline)
            }
            .labelsHidden()
        }
    }
}
