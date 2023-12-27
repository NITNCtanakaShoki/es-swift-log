extension API {
  func deleteUser(username: String) async throws {
    let response = try await client.delete("\(baseURL)/user/\(username)")
    guard response.status == .noContent else {
      let body = try? response.content.decode(String.self)
      throw DeleteUserError(username: username, body: body)
    }
  }
  
  func deleteAllUsers() async throws {
    let response = try await client.delete("\(baseURL)/user")
    guard response.status == .noContent else {
      let body = try? response.content.decode(String.self)
      throw DeleteAllUsersError(body: body)
    }
  }
  
  struct DeleteAllUsersError: Error {
    let body: String?
  }
  
  struct DeleteUserError: Error {
    let username: String
    let body: String?
  }
}
