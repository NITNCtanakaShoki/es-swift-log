import Foundation

extension API {
  func createEvent(count: Int, username1: String, username2: String) async throws {
    let response = try await client.post("\(baseURL)/event/random/\(count)/\(username1)/\(username2)")
    guard response.status == .noContent else {
      let body = try? response.content.decode(String.self)
      throw CreateEventsError(count: count, username1: username1, username2: username2, body: body)
    }
  }
  
  struct CreateEventsError: Hashable, Codable, Sendable, Error {
    let count: Int
    let username1: String
    let username2: String
    let body: String?
  }
}
