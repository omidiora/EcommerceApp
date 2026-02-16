import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    if let email = Auth.auth().currentUser?.email {
                        Text(email)
                    }
                }
                
                Section {
                    Button("Logout", role: .destructive) {
                        authVM.logout()
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
