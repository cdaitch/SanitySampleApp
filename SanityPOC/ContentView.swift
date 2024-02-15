import SwiftUI
import Combine

private var subscriptions = Set<AnyCancellable>()

struct ContentView: View {
    @ObservedObject private var viewModel = TakeoverViewModel()
    @Binding private var takeoverPresented: Binding<Bool>

    private var takeoverSheet = TakeoverSheet()

    init() {
        bindViewModel()

        sheet(item: takeoverPresented, content: takeoverSheet)
    }

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
        viewModel.getGroqData()
    }

    private func loadGraphQLData() {
        viewModel.getGraphQLData()
    }

    private func bindViewModel() {
        viewModel.$takeover
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                guard let takeover = value else { return }
                takeoverSheet.setTakeoverData(takeover)
            })
            .store(in: &subscriptions)

        viewModel.$showTakeover
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
                self.takeoverPresented = value
            })
            .store(in: &subscriptions)
    }
}

struct TakeoverSheet: View {
    var header = Text("")
        .font(.headline)
        .foregroundColor(.black)

    var subheader = Text("")
        .font(.subheadline)
        .foregroundColor(.gray)

    var body: some View {
        VStack {
            header
            subheader
        }
    }

    func setTakeoverData(_ takeover: Takeover) {
        print(takeover)
    }
}

#Preview {
    ContentView()
}
