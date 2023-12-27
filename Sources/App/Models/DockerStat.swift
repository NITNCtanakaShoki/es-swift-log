import Vapor
import Fluent

final class DockerStat: Model {
  
  static let schema = "docker_stats"
  
  @ID
  var id: UUID?
  
  @Field(key: "name")
  var name: String
  
  @Field(key: "cpu_percent")
  var cpuPercent: Double
  
  @Field(key: "mem_usage")
  var memUsage: Double
  
  @Field(key: "mem_usage_unit")
  var memUsageUnit: String
  
  @Field(key: "mem_limit")
  var memLimit: Double
  
  @Field(key: "mem_limit_unit")
  var memLimitUnit: String
  
  @Field(key: "mem_percent")
  var memPercent: Double
  
  @Field(key: "net_in")
  var netIn: Double
  
  @Field(key: "net_in_unit")
  var netInUnit: String
  
  @Field(key: "net_out")
  var netOut: Double
  
  @Field(key: "net_out_unit")
  var netOutUnit: String
  
  @Field(key: "block_in")
  var blockIn: Double
  
  @Field(key: "block_in_unit")
  var blockInUnit: String
  
  @Field(key: "block_out")
  var blockOut: Double
  
  @Field(key: "block_out_unit")
  var blockOutUnit: String
  
  @Field(key: "pids")
  var pids: Int
  
  @Field(key: "date")
  var date: Date
  
  init(id: UUID? = nil, name: String, cpuPercent: Double, memUsage: Double, memUsageUnit: String, memLimit: Double, memLimitUnit: String, memPercent: Double, netIn: Double, netInUnit: String, netOut: Double, netOutUnit: String, blockIn: Double, blockInUnit: String, blockOut: Double, blockOutUnit: String, pids: Int, date: Date) {
    self.id = id
    self.name = name
    self.cpuPercent = cpuPercent
    self.memUsage = memUsage
    self.memUsageUnit = memUsageUnit
    self.memLimit = memLimit
    self.memLimitUnit = memLimitUnit
    self.memPercent = memPercent
    self.netIn = netIn
    self.netInUnit = netInUnit
    self.netOut = netOut
    self.netOutUnit = netOutUnit
    self.blockIn = blockIn
    self.blockInUnit = blockInUnit
    self.blockOut = blockOut
    self.blockOutUnit = blockOutUnit
    self.pids = pids
    self.date = date
  }
  
  init() { }
  
}
