extension API {
  func eventCount(username: String) async throws -> Int {
    let response = try await client.get("\(baseURL)/event/count/\(username)")
    guard response.status == .ok else {
      let body = try? response.content.decode(String.self)
      throw UserEventCountError(username: username, body: body)
    }
    return try response.content.decode(Int.self)
  }
  
  func allEventCount() async throws -> Int {
    let response = try await client.get("\(baseURL)/event/count")
    guard response.status == .ok else {
      let body = try? response.content.decode(String.self)
      throw AllEventCountError(body: body)
    }
    return try response.content.decode(Int.self)
  }
  
  struct UserEventCountError: Error {
    let username: String?
    let body: String?
  }
  
  struct AllEventCountError: Error {
    let body: String?
  }
}
