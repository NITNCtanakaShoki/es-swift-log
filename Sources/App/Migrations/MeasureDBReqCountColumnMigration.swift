import Vapor
import Fluent

struct MeasureDBReqCountColumnMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("measures")
      .field("db_cpu_percent", .int, .required, .sql(.default(100)))
      .field("db_memory_mb", .int, .required, .sql(.default(1024)))
      .field("concurrent_req_count", .int, .required, .sql(.default(1)))
      .update()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("measures")
      .deleteField("db_cpu_percent")
      .deleteField("db_memory_mb")
      .deleteField("concurrent_req_count")
      .update()
  }
}
