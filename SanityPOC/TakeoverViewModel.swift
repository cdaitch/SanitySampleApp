import Foundation
import Combine

struct Secrets {
    let sanityApiKey: String

    init() {
        guard let sanityApiKey = ProcessInfo.processInfo.environment["SANITY_API_KEY"] else {
            fatalError("Missing environment variable for sanity API key")
        }

        self.sanityApiKey = sanityApiKey
    }
}

class TakeoverViewModel: ObservableObject {
    private let secrets = Secrets()
    private let decoder = JSONDecoder()

    lazy var baseApi = {
        return "https://\(secrets.sanityApiKey).api.sanity.io/v2021-10-21/data/query/production?"
    }()

    lazy var baseGraphApi = {
        return "https://\(secrets.sanityApiKey).api.sanity.io/v2023-08-01/graphql/production/default"
    }()

    private var subscriptions = Set<AnyCancellable>()

    @Published var takeover: Takeover?
    @Published var showGroqTakeover: Bool = false
    @Published var showGraphTakeover: Bool = false

    func getGroqData() {
        let query =
        """
        *[_type == "takeover"]
        """
        let encoded = URLQueryItem(name: "query", value: query)
        let urlString = "\(baseApi)\(encoded)"

        guard let url = URL(string: urlString) else { return }

        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let json = try self.decoder.decode(TakeoverResponseGroq.self, from: data)
                guard let firstTakeover = json.result.first else { return }
                self.takeover = firstTakeover
                self.showGroqTakeover = true
            } catch {
                print("error: ", error)
            }
        }

        request.resume()
    }

    func getGraphQLData() {
        let query =
        """
        {
            allTakeover {
                title
                description
            }
        }
        """
        let queryDic = ["query": query]

        guard let url = URL(string: baseGraphApi) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let jsonData = try? JSONSerialization.data(withJSONObject: queryDic, options: []) else {
            return
        }

        request.httpBody = jsonData

        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            if let error = error {
                print(error.localizedDescription)
            }

            do {
                let json = try self.decoder.decode(TakeoverResponseGraph.self, from: data)
                guard let firstTakeover = json.data.allTakeover.first else { return }
                DispatchQueue.main.async {
                    self.takeover = firstTakeover
                    self.showGraphTakeover = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        session.resume()
    }
}

struct TakeoverResponseGroq: Codable {
    let result: [Takeover]
}

struct TakeoverResponseGraph: Codable {
    let data: AllTakeover
}

struct AllTakeover: Codable {
    let allTakeover: [Takeover]
}

struct Takeover: Codable {
    let title: String
    let description: String
}
