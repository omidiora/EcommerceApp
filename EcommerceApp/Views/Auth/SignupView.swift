import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Sign Up")
                    .font(.largeTitle.bold())
                
                TextField("Email", text: $authVM.email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $authVM.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                Button("Create Account") {
                    Task {
                        await authVM.signUp()
                        if authVM.isAuthenticated { dismiss() }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
