import SwiftUI

struct ContentView: View {
    let api = Api()

    var body: some View {
        VStack {
            Button(action: loadGroqData) {
                Text("Load via GROQ data")
            }
            .font(.subheadline)
            .foregroundColor(.black)
            .padding(10)
            .border(.black, width: 1)

            Button(action: loadGraphQLData) {
                Text("Load via graphQL data")
            }
            .font(.subheadline)
            .foregroundColor(.black)
            .padding(10)
            .border(.black, width: 1)
        }
    }

    private func loadGroqData() {
        api.getGroqData()
    }

    private func loadGraphQLData() {
        api.getGraphQLData()
    }
}

#Preview {
    ContentView()
}
