import Vapor
import Fluent
import AsyncCommandRegister

struct OutputLogCommand: AsyncCommand {
  struct Signature: CommandSignature {
    @Option(name: "count", short: "c")
    var count: Int?
  }
  
  let help = "ログを出力します。countオプションで出力する個数を指定できます。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    var query = Measure.query(on: context.application.db)
      .sort(\.$createdAt, .descending)
    if let count = signature.count {
      query = query.limit(count)
    }
    let measures = try await query.all()
    
    context.console.print("| date | cpu_percent | memory_mb | way | chunk | start | end | client_time | server_time | user_event_count | all_event_count | enable_index | point |")
    for measure in measures {
      context.console.print("| \(measure.createdAt!.formatted) | \(measure.cpuPercent) | \(measure.memoryMB) | \(measure.way.rawValue) | \(measure.chunk.map(String.init) ?? "nil") | \(measure.start.formatted) | \(measure.end.formatted) | \(measure.clientTime) | \(measure.serverTime) | \(measure.userEventCount) | \(measure.allEventCount) | \(measure.enableIndex) | \(measure.point) |")
    }
  }
}
