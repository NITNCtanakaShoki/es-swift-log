extension API {
  func createUser(username: String) async throws {
    let response = try await client.post("\(baseURL)/user/\(username)")
    guard response.status == .noContent else {
      let body = try? response.content.decode(ErrorResponse.self)
      throw CreateUserError(username: username, reason: body?.reason)
    }
  }
  
  struct CreateUserError: Error {
    let username: String
    let reason: String?
  }
}
