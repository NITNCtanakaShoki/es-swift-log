import Vapor

extension API {
  func point(kind: PointKind, username: String) async throws -> PointJSON {
    let response = try await client.get("\(baseURL)/point\(kind.path)/\(username)") { req in
      req.headers.contentType = .json
    }
    guard response.status == .ok else {
      let body = try? response.content.decode(ErrorResponse.self)
      throw PointError(status: response.status, kind: kind, username: username, reason: body?.reason)
    }
    
    return try response.content.decode(PointJSON.self)
  }
  
  struct PointError: Error {
    let status: HTTPStatus
    let kind: PointKind
    let username: String
    let reason: String?
  }
  
  struct PointJSON: Content {
    var time: TimeInterval
    var point: Int
  }
}

enum PointKind {
  case stream
  case chunk(count: Int)
  case pagingOffset(count: Int)
  case pagingLast(count: Int)
  case pagingLastAsync(count: Int)
  
  var path: String {
    switch self {
    case .stream:
      "/stream"
    case let .chunk(count):
      "/chunk/\(count)"
    case let .pagingOffset(count):
      "/paging-offset/\(count)"
    case let .pagingLast(count):
      "/paging-last/\(count)"
    case let .pagingLastAsync(count):
      "/paging-last-async/\(count)"
    }
  }
  
  var count: Int? {
    switch self {
    case .stream: nil
    case let .chunk(count): count
    case let .pagingOffset(count): count
    case let .pagingLast(count): count
    case let .pagingLastAsync(count): count
    }
  }
}
