const commit = [["https://github.com/leanprover-community/mathlib/blob/master/src/", "https://github.com/leanprover-community/mathlib/blob/32a7e535287f9c73f2e4d2aef306a39190f0b504/src/"], ["https://github.com/leanprover-community/mathlib/blob/master/archive/", "https://github.com/leanprover-community/mathlib/blob/32a7e535287f9c73f2e4d2aef306a39190f0b504/archive/"], ["https://github.com/leanprover-community/mathlib/blob/master/counterexamples/", "https://github.com/leanprover-community/mathlib/blob/32a7e535287f9c73f2e4d2aef306a39190f0b504/counterexamples/"]];
function redirectTo(tgt) {
  let loc = tgt;
  for (const [prefix, replacement] of commit) {
    if (tgt.startsWith(prefix)) {
      loc = tgt.replace(prefix, replacement);
      break;
    }
  }
  window.location.replace(loc);
}
