import SwiftUI

struct CreateProductView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ProductListViewModel() // Reuse to refresh list after creation
    
    @State private var name = ""
    @State private var description = ""
    @State private var priceText = ""
    @State private var imageUrl = ""
    @State private var category = ""
    
    @State private var isCreating = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    private let service = ProductService()
    
    private var price: Double? {
        Double(priceText)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Product Details") {
                    TextField("Name *", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(5...10)
                    
                    TextField("Price (₦) *", text: $priceText)
                        .keyboardType(.decimalPad)
                    
                    TextField("Category", text: $category)
                }
                
                Section("Image") {
                    TextField("Image URL", text: $imageUrl)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                    
                    if !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure:
                                Text("Invalid image URL")
                                    .foregroundStyle(.red)
                            default:
                                ProgressView()
                            }
                        }
                    }
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
                
                if let success = successMessage {
                    Text(success)
                        .foregroundStyle(.green)
                }
            }
            .navigationTitle("Add New Product")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task { await createProduct() }
                    }
                    .disabled(isCreating || name.isEmpty || price == nil)
                }
            }
            .disabled(isCreating)
        }
    }
    
    private func createProduct() async {
        isCreating = true
        errorMessage = nil
        successMessage = nil
        
        guard let price = price else {
            errorMessage = "Invalid price"
            isCreating = false
            return
        }
        
        let newProduct = Product(
            id: UUID().uuidString,
            name: name,
            description: description.isEmpty ? nil : description,
            price: price,
            imageUrl: imageUrl.isEmpty ? nil : imageUrl,
            category: category.isEmpty ? nil : category
        )
        
        do {
            try await service.createProduct(newProduct)
            successMessage = "Product created successfully!"
            // Refresh the main list
            await vm.loadProducts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        } catch {
            errorMessage = "Failed to create product: \(error.localizedDescription)"
        }
        
        isCreating = false
    }
}
