import Foundation

struct ApiService: Sendable {

    static let shared = ApiService()

    func fetchApiData<T: Decodable & Sendable>(
        urlString: String,
        completion: @escaping @MainActor @Sendable (T?, ErrorModel?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            Task { @MainActor in
                completion(nil, ErrorModel(code: "invalid_url", message: "Invalid request URL"))
            }
            return
        }
        print("*************")
        print("Endpoint url: \(url)")
        print("*************")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Failed to get data:", error)
                Task { @MainActor in
                    completion(nil, ErrorModel(code: "network_error", message: error.localizedDescription))
                }
                return
            }
            if let error = self.checkResponse(response: response, data: data) {
                Task { @MainActor in
                    completion(nil, error)
                }
                return
            }
            if let responseData: T = self.handleSuccess(data: data) {
                Task { @MainActor in
                    completion(responseData, nil)
                }
            } else {
                Task { @MainActor in
                    completion(nil, ErrorModel(code: "decoding_error", message: "The server response could not be read"))
                }
            }
        }.resume()
    }

    func handleSuccess<T: Decodable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch {
            print("Failed to serialize json:", error)
        }
        return nil
    }

    func checkResponse(response: URLResponse?, data: Data?) -> ErrorModel? {
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            return errorHandle(httpResponse: httpResponse, data: data)
        }
        return nil
    }

    func errorHandle(httpResponse: HTTPURLResponse, data: Data?) -> ErrorModel? {
        print("Status code: \(httpResponse.statusCode)")
        var error: ErrorModel?
        guard let data = data else { return nil }
        do {
            error = try JSONDecoder().decode(ErrorModel.self, from: data)
        } catch {
            print("Failed to serialize error in json:", error)
        }
        let responseError = error ?? ErrorModel(
            code: String(httpResponse.statusCode),
            message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
        )
        print("Error code: \(responseError.code ?? "")")
        print("Message: \(responseError.message ?? "")")
        return responseError
    }

}
