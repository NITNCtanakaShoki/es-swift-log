extension API {
  func deleteUser(username: String) async throws {
    let response = try await client.delete("\(baseURL)/user/\(username)")
    guard response.status == .noContent else {
      let body = try? response.content.decode(ErrorResponse.self)
      throw DeleteUserError(username: username, reason: body?.reason)
    }
  }
  
  func deleteAllUsers() async throws {
    let response = try await client.delete("\(baseURL)/user")
    guard response.status == .noContent else {
      let body = try? response.content.decode(ErrorResponse.self)
      throw DeleteAllUsersError(reason: body?.reason)
    }
  }
  
  struct DeleteAllUsersError: Error {
    let reason: String?
  }
  
  struct DeleteUserError: Error {
    let username: String
    let reason: String?
  }
}
