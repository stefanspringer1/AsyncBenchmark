# AsyncBenchmark

Benchmark for Swift's async/await in a special variation.

Note that:

1. In those tests, the factor between an async call and a non-async call is quite low in most cases (near 1).
2. But there are three cases where this factors is quite high (~ 227, ~ 42, and ~ 6703). (In debug mode, only the last one is much highr than one, ~ 22).

Result:

```text

--------------------------

100000 iterations
Evaluating: Execution...
Time for Execution: 0.0001912 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0001919 seconds
100000 iterations done
factor: 1.0037028
difference: 0.0000007

--------------------------

10000 iterations
Evaluating: Execution...
Time for Execution: 0.0000190 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0000190 seconds
10000 iterations done
factor: 1.0000000
difference: 0.0000000

--------------------------

1000 iterations
Evaluating: Execution...
Time for Execution: 0.0000020 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0000020 seconds
1000 iterations done
factor: 0.9794319
difference: -0.0000000

--------------------------

100 iterations
Evaluating: Execution...
Time for Execution: 0.0000002 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0000002 seconds
100 iterations done
factor: 1.0000000
difference: 0.0000000

--- directly in main 1 ---

100000 iterations
Evaluating: Execution...
Time for Execution: 0.0000950 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0215907 seconds
100000 iterations done
factor: 227.2701684
difference: 0.0214957

===== NON-ASYNC WORK =====


--------------------------

100000 iterations
Evaluating: Execution...
Time for Execution: 0.0001334 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.0056509 seconds
100000 iterations done
factor: 42.3553022
difference: 0.0055175

--- directly in main 2 ---

100000 iterations
Evaluating: Execution...
Time for Execution: 0.0000669 seconds
Evaluating: AsyncExecution...
Time for AsyncExecution: 0.4485672 seconds
100000 iterations done
factor: 6703.4372646
difference: 0.4485003
(base) stefan@MacBook-Pro-von-Stefan release % 

```
