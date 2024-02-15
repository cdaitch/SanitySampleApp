import Foundation

struct Secrets {
    let sanityApiKey: String

    init() {
        guard let sanityApiKey = ProcessInfo.processInfo.environment["SANITY_API_KEY"] else {
            fatalError("Missing environment variable for sanity API key")
        }

        self.sanityApiKey = sanityApiKey
    }
}

class Api {
    let secrets = Secrets()

    lazy var baseApi = {
        return "https://\(secrets.sanityApiKey).api.sanity.io/v2021-10-21/data/query/production?"
    }()

    lazy var baseGraphApi = {
        return "https://\(secrets.sanityApiKey).api.sanity.io/v2023-08-01/graphql/production/default"
    }()

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
            
            let decoder = JSONDecoder()

            do {
                let json = try decoder.decode(TakeoverResponse.self, from: data)
                print(json)
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
        let queryString =
        """
        {
            "query": "\(query)"
        }
        """

        print(queryString)

        guard let url = URL(string: baseGraphApi) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = queryString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            if error != nil {
                print(error)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct TakeoverResponse: Codable {
    let result: [Takeover]
}

struct Takeover: Codable {
    let title: String
    let description: String
}
