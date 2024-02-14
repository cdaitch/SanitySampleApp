import SwiftUI

struct ContentView: View {
    let groqApi = GroqApi()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button(action: loadData) {
                Text("Load")
            }
        }
        .padding()
    }

    private func loadData() {
        groqApi.getGroqData()
    }
}

#Preview {
    ContentView()
}
