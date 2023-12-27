import Vapor
import Fluent

extension DockerStat {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema("docker_stats")
        .id()
        .field("name", .string, .required)
        .field("cpu_percent", .double, .required)
        .field("mem_usage", .double, .required)
        .field("mem_usage_unit", .string, .required)
        .field("mem_limit", .double, .required)
        .field("mem_limit_unit", .string, .required)
        .field("mem_percent", .double, .required)
        .field("net_in", .double, .required)
        .field("net_in_unit", .string, .required)
        .field("net_out", .double, .required)
        .field("net_out_unit", .string, .required)
        .field("block_in", .double, .required)
        .field("block_in_unit", .string, .required)
        .field("block_out", .double, .required)
        .field("block_out_unit", .string, .required)
        .field("pids", .int, .required)
        .field("date", .datetime, .required)
        .create()
    }
    
    func revert(on database: Database) async throws {
      try await database.schema("docker_stats").delete()
    }
  }
}
