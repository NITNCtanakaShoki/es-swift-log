import Foundation
import Vapor

struct DockerStat {
  var name: String
  var cpuPercent: Double
  var memUsage: Double
  var memUsageUnit: String
  var memLimit: Double
  var memLimitUnit: String
  var memPercent: Double
  var netIn: Double
  var netInUnit: String
  var netOut: Double
  var netOutUnit: String
  var blockIn: Double
  var blockInUnit: String
  var blockOut: Double
  var blockOutUnit: String
  var pids: Int
}

struct DockerStatsCommand: AsyncCommand {
  struct Signature: CommandSignature {}
  
  let help = "指定されたusernameのUserを削除します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    let dockerPATH = Environment.get("DOCKER_PATH")!
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = ["-c", "\(dockerPATH) container stats --format \"{{.Name}}, {{.CPUPerc}}, {{.MemUsage}}, {{.MemPerc}}, {{.NetIO}}, {{.BlockIO}}, {{.PIDs}}\""]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    do {
      try process.run()
      let data = pipe.fileHandleForReading
      
      while process.isRunning {
        let output = data.availableData
        if let outputString = String(data: output, encoding: .utf8) {
          outputString.split(separator: "\n").forEach { line in
            if let stat = parseDockerStat(from: String(line)) {
              print(stat)
            }
          }
        }
      }
    } catch {
      print("Failed to start process: \(error)")
    }
    
  }
}


func parseDockerStat(from line: String) -> DockerStat? {
  let components = line.split(separator: ",")
  guard components.count == 7 else { return nil }
  
  let name = String(components[0])
  
  let cpuPercent = Double(components[1].filter("0123456789.".contains)) ?? 0
  let memComponents = components[2].split(separator: "/")
  let memUsage = Double(memComponents[0].filter("0123456789.".contains)) ?? 0
  let memUsageUnit = String(memComponents[0].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  let memLimit = Double(memComponents[1].filter("0123456789.".contains)) ?? 0
  let memLimitUnit = String(memComponents[1].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  let memPercent = Double(components[3].filter("0123456789.".contains)) ?? 0
  
  let netIOComponents = components[4].split(separator: "/")
  let netIn = Double(netIOComponents[0].filter("0123456789.".contains)) ?? 0
  let netInUnit = String(netIOComponents[0].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  let netOut = Double(netIOComponents[1].filter("0123456789.".contains)) ?? 0
  let netOutUnit = String(netIOComponents[1].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  
  let blockIOComponents = components[5].split(separator: "/")
  let blockIn = Double(blockIOComponents[0].filter("0123456789.".contains)) ?? 0
  let blockInUnit = String(blockIOComponents[0].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  let blockOut = Double(blockIOComponents[1].filter("0123456789.".contains)) ?? 0
  let blockOutUnit = String(blockIOComponents[1].filter { !$0.isNumber && $0 != "." }).trimmingCharacters(in: .whitespaces)
  
  let pids = Int(components[6].trimmingCharacters(in: .whitespaces)) ?? 0
  
  return DockerStat(name: name, cpuPercent: cpuPercent, memUsage: memUsage, memUsageUnit: memUsageUnit, memLimit: memLimit, memLimitUnit: memLimitUnit, memPercent: memPercent, netIn: netIn, netInUnit: netInUnit, netOut: netOut, netOutUnit: netOutUnit, blockIn: blockIn, blockInUnit: blockInUnit, blockOut: blockOut, blockOutUnit: blockOutUnit, pids: pids)
}

