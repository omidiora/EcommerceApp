

import SwiftUI

struct SwiftUIView: View {
    
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var cartVM = CartViewModel()
    
    var body: some View {
        Group {
                    if authVM.isAuthenticated {
                        MainTabView()
                            .environmentObject(cartVM)
                    } else {
                        AuthView()
                            .environmentObject(authVM)
                    }
                }
    }
}

#Preview {
    SwiftUIView()
}
