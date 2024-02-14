import Foundation

class GroqApi {
    let baseApi = "https://TOKEN.api.sanity.io/v2021-10-21/data/query/production?"

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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json)
            } catch {
                print("fail")
            }
        }

        request.resume()
    }
}
