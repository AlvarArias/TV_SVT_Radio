//
//  APIClient.swift
//  TV_SVT_Radio
//
//  Created by Alvar Arias on 2025-09-01.
//

import Foundation

/// Error types for API operations
enum APIError: LocalizedError, Sendable {
    case invalidURL(String)
    case networkError(URLError)
    case decodingError(DecodingError)
    case httpError(statusCode: Int)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "HTTP Error \(statusCode)"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

/// API Client for SVT Radio/TV services
@MainActor
final class APIClient: Sendable {
    static let shared = APIClient()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        self.session = URLSession.shared
        self.decoder = JSONDecoder()
    }
    
    /// Fetch radio stations from local JSON file
    /// - Parameter fileName: Name of the JSON file (without extension)
    /// - Returns: Result containing array of RadioStation or APIError
    func fetchLocalStations(fileName: String = "radios23") async -> Result<[RadioStation], APIError> {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return .failure(.invalidURL(fileName))
        }
        
        do {
            let data = try Data(contentsOf: url)
            let stations = try decoder.decode([RadioStation].self, from: data)
            return .success(stations)
        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch {
            return .failure(.unknownError(error))
        }
    }
    
    /// Fetch a single radio station by ID from the API
    /// - Parameter id: The station ID
    /// - Returns: Result containing RadioStation or APIError
    func fetchStation(id: String) async -> Result<RadioStation, APIError> {
        // Example implementation - adjust URL based on actual API
        let urlString = "https://api.svt.se/stations/\(id)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL(urlString))
        }
        
        return await performRequest(url: url, responseType: RadioStation.self)
    }
    
    /// Perform a generic GET request
    /// - Parameters:
    ///   - url: The URL to request
    ///   - responseType: The expected response type (must conform to Decodable)
    /// - Returns: Result containing the decoded response or APIError
    private func performRequest<T: Decodable>(
        url: URL,
        responseType: T.Type
    ) async -> Result<T, APIError> {
        do {
            let (data, response) = try await session.data(from: url)
            
            // Check HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    return .failure(.httpError(statusCode: httpResponse.statusCode))
                }
            }
            
            let decodedResponse = try decoder.decode(T.self, from: data)
            return .success(decodedResponse)
        } catch let error as URLError {
            return .failure(.networkError(error))
        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch {
            return .failure(.unknownError(error))
        }
    }
}
