import Vapor
import Fluent

extension Measure {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      let waySchema = try await database.enum("measure-way")
        .case("stream")
        .case("chunk")
        .case("paging-offset")
        .case("paging-last")
        .case("paging-last-async")
        .create()
      
      try await database.schema("measures")
        .id()
        .field("cpu_percent", .int, .required)
        .field("memory_mb", .int, .required)
        .field("way", waySchema, .required)
        .field("chunk", .int)
        .field("start", .datetime, .required)
        .field("end", .datetime, .required)
        .field("user_event_count", .int, .required)
        .field("all_event_count", .int, .required)
        .field("enable_index", .bool, .required)
        .field("point", .int, .required)
        .field("server_time", .double, .required)
        .field("created_at", .datetime, .required)
        .create()
    }
    
    func revert(on database: Database) async throws {
      try await database.schema("measures").delete()
      try await database.enum("measure-way").delete()
    }
  }
}
