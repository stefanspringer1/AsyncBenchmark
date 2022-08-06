import Foundation

public class Execution {

    public func effectuate(work: () -> ()) {
        work()
    }
    
}

public actor AsyncExecution {

    public func effectuate(work: () async -> ()) async {
        await work()
    }
    
}

public actor AsyncExecutionWithNonAsyncWork {

    public func effectuate(work: () -> ()) async {
        work()
    }
    
}

let execution = Execution()
let asyncExecution = AsyncExecution()
let asyncExecutionWithNonAsyncWork = AsyncExecutionWithNonAsyncWork()

class Counter {
    
    private var _count = 0
    
    var count: Int { _count }
    
    func augment() {
        _count += 1
    }
}

let numberFormat = "%.7f"

func evaluate(info: String, block: () -> ()) -> Double {
    print("Evaluating: \(info)...")

    let start = DispatchTime.now()
    block()
    let end = DispatchTime.now()

    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000

    print("Time for \(info): \(String(format: numberFormat, timeInterval)) seconds")
    return timeInterval
}

func evaluate(info: String, block: () async -> ()) async -> Double {
    print("Evaluating: \(info)...")

    let start = DispatchTime.now()
    await block()
    let end = DispatchTime.now()

    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    
    print("Time for \(info): \(String(format: numberFormat, timeInterval)) seconds")
    return timeInterval
}

func test(loops: Int) async {
    
    print("\n--------------------------\n")
    
    print("\(loops) iterations")
    let counter = Counter()
    
    let timeNonAsync = evaluate(info: "Execution") {
        for _ in 1...loops {
            execution.effectuate {
                counter.augment()
            }
        }
    }

    let timeAsync = await evaluate(info: "AsyncExecution") {
        for _ in 1...loops {
            await asyncExecution.effectuate {
                counter.augment()
            }
        }
    }
    
    print("\(counter.count / 2) iterations done")
    print("factor: \(String(format: numberFormat, timeAsync/timeNonAsync))")
    print("difference: \(String(format: numberFormat, timeAsync - timeNonAsync))")
}

func testNonAsyncWork(loops: Int) async {
    
    print("\n--------------------------\n")
    
    print("\(loops) iterations")
    let counter = Counter()
    
    let timeNonAsync = evaluate(info: "Execution") {
        for _ in 1...loops {
            execution.effectuate {
                counter.augment()
            }
        }
    }

    let timeAsync = await evaluate(info: "AsyncExecution") {
        for _ in 1...loops {
            await asyncExecutionWithNonAsyncWork.effectuate {
                counter.augment()
            }
        }
    }
    
    print("\(counter.count / 2) iterations done")
    print("factor: \(String(format: numberFormat, timeAsync/timeNonAsync))")
    print("difference: \(String(format: numberFormat, timeAsync - timeNonAsync))")
}

@main struct Main {

  static func main() async {
      
      await test(loops: 100_000)
      await test(loops:  10_000)
      await test(loops:   1_000)
      await test(loops:     100)
      
      print("\n--- directly in main 1 ---\n")
      
      let loops = 100_000
      
      print("\(loops) iterations")
      let counter = Counter()
      
      let timeNonAsync = evaluate(info: "Execution") {
          for _ in 1...loops {
              execution.effectuate {
                  counter.augment()
              }
          }
      }

      let timeAsync = await evaluate(info: "AsyncExecution") {
          for _ in 1...loops {
              await asyncExecution.effectuate {
                  counter.augment()
              }
          }
      }
      
      print("\(counter.count / 2) iterations done")
      print("factor: \(String(format: numberFormat, timeAsync/timeNonAsync))")
      print("difference: \(String(format: numberFormat, timeAsync - timeNonAsync))")
      
      print("\n===== NON-ASYNC WORK =====\n")
      
      await testNonAsyncWork(loops: 100_000)
      
      print("\n--- directly in main 2 ---\n")
      
      let asyncExecutionWithNonAsyncWork = AsyncExecutionWithNonAsyncWork()
      
      let loops2 = 100_000
      
      print("\(loops2) iterations")
      let counter2 = Counter()
      
      let timeNonAsync2 = evaluate(info: "Execution") {
          for _ in 1...loops2 {
              execution.effectuate {
                  counter2.augment()
              }
          }
      }

      let timeAsync2 = await evaluate(info: "AsyncExecution") {
          for _ in 1...loops2 {
              await asyncExecutionWithNonAsyncWork.effectuate {
                  counter2.augment()
              }
          }
      }
      
      print("\(counter2.count / 2) iterations done")
      print("factor: \(String(format: numberFormat, timeAsync2/timeNonAsync2))")
      print("difference: \(String(format: numberFormat, timeAsync2 - timeNonAsync2))")
  }
}
