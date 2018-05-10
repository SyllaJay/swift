// To avoid redundant diagnostics showing up in Xcode, batch-mode must suppress diagnostics in
// non-primary files.
//
// RUN: rm -f %t.*

// RUN: not %target-swift-frontend -typecheck  -primary-file %s  -serialize-diagnostics-path %t.main.dia -primary-file %S/../Inputs/empty.swift  -serialize-diagnostics-path %t.empty.dia %S/Inputs/serialized-diagnostics-batch-mode-suppression-helper.swift    2> %t.stderr.txt
// RUN: c-index-test -read-diagnostics %t.main.dia 2> %t.main.txt
// RUN: c-index-test -read-diagnostics %t.empty.dia 2> %t.empty.txt

// Ensure there was an error:

// RUN: %FileCheck -check-prefix=ERROR %s <%t.stderr.txt
// ERROR: error:

// Ensure the error is not in the serialized diagnostics:

// RUN: %FileCheck -check-prefix=NO-DIAGNOSTICS %s <%t.main.txt
// RUN: %FileCheck -check-prefix=NO-DIAGNOSTICS %s <%t.empty.txt
// NO-DIAGNOSTICS: Number of diagnostics: 0

// RUN: not %FileCheck -check-prefix=ERROR %s <%t.main.txt
// RUN: not %FileCheck -check-prefix=ERROR %s <%t.empty.txt


func test(x: SomeType) {
 // CHECK-MAIN-DAG: serialized-diagnostics-batch-mode.swift:[[@LINE]]:3: error: use of unresolved identifier 'nonexistent'
  // CHECK-STDERR-DAG: serialized-diagnostics-batch-mode.swift:[[@LINE-1]]:3: error: use of unresolved identifier 'nonexistent'

  // The other file has a similar call.
  // CHECK-HELPER-DAG: serialized-diagnostics-batch-mode-helper.swift:{{[0-9]+}}:3: error: use of unresolved identifier 'nonexistent'
  // CHECK-STDERR-DAG: serialized-diagnostics-batch-mode-helper.swift:{{[0-9]+}}:3: error: use of unresolved identifier 'nonexistent'
}
