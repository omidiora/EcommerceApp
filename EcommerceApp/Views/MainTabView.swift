import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ProductListView()
                .tabItem { Label("Shop", systemImage: "bag") }
            
            OrdersView()
                .tabItem { Label("Orders", systemImage: "list.bullet") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
