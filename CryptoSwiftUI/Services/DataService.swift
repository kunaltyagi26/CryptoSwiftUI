//
//  DataService.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 08/11/23.
//

import Combine
import Foundation

enum NetworkingError: Error {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String {
        switch self {
        case .badURLResponse(let url):
            "Bad response from URL: \(url)"
            
        case .unknown:
            "Unknown error occured."
        }
    }
}

class DataService<T: Decodable>: ObservableObject {
    enum Endpoint {
        case getCoins
        case getImage(url: String)
        case getMarketData
        
        var urlString: String {
            switch self {
            case .getCoins:
                return URLConstants.getCoins
                
            case .getImage(let url):
                return url
                
            case .getMarketData:
                return URLConstants.getMarketData
            }
        }
    }
    
    @Published var result: T?
    private var subscription: AnyCancellable?
    
    func getData(for endpoint: Endpoint) {
        guard let url = URL(string: endpoint.urlString) else {
            return
        }
        
        subscription = getPublisher(for: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] result in
                self?.result = result
                self?.subscription?.cancel()
            })
    }
    
    func getImageData(for endpoint: Endpoint) {
        guard let url = URL(string: endpoint.urlString) else {
            return
        }
        
        subscription = getPublisher(for: url)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] imageData in
                if let imageData = imageData as? T {
                    self?.result = imageData
                    self?.subscription?.cancel()
                }
            })
    }
    
    private func getPublisher(for url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryCompactMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...300).contains(response.statusCode) else {
                    throw NetworkingError.badURLResponse(url: url)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

