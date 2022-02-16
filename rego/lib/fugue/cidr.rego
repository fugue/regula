# Copyright 2020-2022 Fugue, Inc.
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
# CIDR manipulation library.  Could be slightly simplified with the
# 'net.cidr_contains' Rego builtin but that isn't in fregot (yet).
package fugue.cidr

zero_cidr(cidr) {
  cidr == "0.0.0.0/0"
} {
  cidr == "::/0"
}

private_cidr(cidr) {
  # Private ipv4 CIDRs.
  private_parsed_ipv4_cidr(parse_ipv4_cidr(cidr))
} {
  # Private ipv6 CIDRs.
  contains(cidr, ":")
  startswith(cidr, "fd")
}

public_cidr(cidr) {
  not private_cidr(cidr)
}

parsenum(str) = ret {
  re_match("^[0-9][0-9]*$", str)
  ret = to_number(str)
}

parse_ipv4_cidr(cidr) = ret {
  [ip, mask] = split(cidr, "/")
  [b1, b2, b3, b4] = split(ip, ".")
  ret = {
    "address": [parsenum(b1), parsenum(b2), parsenum(b3), parsenum(b4)],
    "mask": parsenum(mask)
  }
}

private_parsed_ipv4_cidr(cidr) {
  # 10.0.0.0/8
  cidr.address[0] == 10
  cidr.mask >= 8
} {
  # 172.16.0.0/12
  cidr.address[0] == 172
  cidr.address[1] >= 16
  cidr.address[1] <= 31
  cidr.mask >= 12
} {
  # 192.168.0.0/16
  cidr.address[0] == 192
  cidr.address[1] == 168
  cidr.mask >= 16
}
