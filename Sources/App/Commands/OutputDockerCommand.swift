import Vapor
import Fluent
import AsyncCommandRegister

struct OutputDockerCommand: AsyncCommand {
  struct Signature: CommandSignature {
    @Option(name: "count", short: "c")
    var count: Int?
  }
  
  let help = "Docker statsを出力します。countオプションで出力する個数を指定できます。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    var query = DockerStat.query(on: context.application.db)
      .sort(\.$date, .descending)
    if let count = signature.count {
      query = query.limit(count)
    }
    let stats = try await query.all()
    
    context.console.print("| date | name | cpu_percent | mem_usage | mem_usage_unit | mem_limit | mem_limit_unit | mem_percent | net_in | net_in_unit | net_out | net_out_unit | block_in | block_in_unit | block_out | block_out_unit | pids |")
    for stat in stats {
      context.console.print("| \(stat.date.formatted) | \(stat.name) | \(stat.cpuPercent) | \(stat.memUsage) | \(stat.memUsageUnit) | \(stat.memLimit) | \(stat.memLimitUnit) | \(stat.memPercent) | \(stat.netIn) | \(stat.netInUnit) | \(stat.netOut) | \(stat.netOutUnit) | \(stat.blockIn) | \(stat.blockInUnit) | \(stat.blockOut) | \(stat.blockOutUnit) | \(stat.pids) |")
    }
  }
}
