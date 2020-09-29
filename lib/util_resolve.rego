# Copyright 2020 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package util.resolve

# Resolves a DAG encoded as an object up to a certain point (currently 16
# indirections).
# See also: <https://github.com/open-policy-agent/opa/issues/947>.

resolve(dag) = ret {
  ret := {k: resolve_term(dag, v) | v := dag[k]}
}

resolve_term   (g, t) = v {v = resolve_term_01(g, g[t])} else = t {true}
resolve_term_01(g, t) = v {v = resolve_term_02(g, g[t])} else = t {true}
resolve_term_02(g, t) = v {v = resolve_term_03(g, g[t])} else = t {true}
resolve_term_03(g, t) = v {v = resolve_term_04(g, g[t])} else = t {true}
resolve_term_04(g, t) = v {v = resolve_term_05(g, g[t])} else = t {true}
resolve_term_05(g, t) = v {v = resolve_term_06(g, g[t])} else = t {true}
resolve_term_06(g, t) = v {v = resolve_term_07(g, g[t])} else = t {true}
resolve_term_07(g, t) = v {v = resolve_term_08(g, g[t])} else = t {true}
resolve_term_08(g, t) = v {v = resolve_term_09(g, g[t])} else = t {true}
resolve_term_09(g, t) = v {v = resolve_term_10(g, g[t])} else = t {true}
resolve_term_10(g, t) = v {v = resolve_term_11(g, g[t])} else = t {true}
resolve_term_11(g, t) = v {v = resolve_term_12(g, g[t])} else = t {true}
resolve_term_12(g, t) = v {v = resolve_term_13(g, g[t])} else = t {true}
resolve_term_13(g, t) = v {v = resolve_term_14(g, g[t])} else = t {true}
resolve_term_14(g, t) = v {v = resolve_term_15(g, g[t])} else = t {true}
resolve_term_15(g, t) = v {v = resolve_term_16(g, g[t])} else = t {true}
resolve_term_16(g, t)                                         = t {true}
