
import Foundation
import FirebaseAuth
import Combine

// Removed @MainActor from the class
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isAuthenticated = false
    
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
        // Safe here: currentUser is thread-safe, and init is no longer main-actor-isolated
        isAuthenticated = service.currentUser != nil
    }
    
    @MainActor
    func signUp() async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await service.signUp(email: email, password: password)
            isAuthenticated = true
        } catch {
            
            let nsError = error as NSError
                print("Firebase Error Details:")
                print("Domain: \(nsError.domain)")
                print("Code: \(nsError.code)")
                print("Description: \(nsError.localizedDescription)")
                print("UserInfo: \(nsError.userInfo)")
                
                errorMessage = nsError.localizedDescription
            errorMessage = (error as NSError).localizedDescription
            print((error as NSError).localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await service.login(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func logout() {
        do {
            try service.logout()
            isAuthenticated = false
        } catch {
            errorMessage = "Failed to logout"
        }
    }
}
