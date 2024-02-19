import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = TakeoverViewModel()

    var body: some View {
        let sheet = TakeoverSheet(takeover: viewModel.takeover)
        VStack {
            Button(action: loadGroqData) {
                Text("Load via GROQ data")
            }
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(10)
                .border(.black, width: 1)
                .sheet(isPresented: $viewModel.showGroqTakeover, content: {
                    sheet
                })
            Button(action: loadGraphQLData) {
                Text("Load via graphQL data")
            }
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(10)
                .border(.black, width: 1)
                .sheet(isPresented: $viewModel.showGraphTakeover, content: {
                    sheet
                })
        }
    }

    private func loadGroqData() {
        viewModel.getGroqData()
    }

    private func loadGraphQLData() {
        viewModel.getGraphQLData()
    }
}

struct TakeoverSheet: View {
    @State var takeover: Takeover?

    var body: some View {
        VStack {
            Text(takeover?.title ?? "")
                .font(.headline)
                .foregroundColor(.black)
            Text(takeover?.description ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ContentView()
}
