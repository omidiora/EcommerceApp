import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isSignup = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bag.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                
                Text("Welcome to EcommerceApp")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 16) {
                    TextField("Email", text: $authVM.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $authVM.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    Button("Login") {
                        Task { await authVM.login() }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(authVM.isLoading)
                    
                    Button("Create Account") {
                        isSignup = true
                    }
                    .foregroundStyle(.blue)
                }
                .padding(.horizontal)
                
                if authVM.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .sheet(isPresented: $isSignup) {
                SignupView()
            }
        }
    }
}

#Preview {
    AuthView()
}

