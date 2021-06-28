# Copyright 2020-2021 Fugue, Inc.
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
package rules.aws_rds_multi_az_cluster

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "RDS Aurora cluster multi-AZ should be enabled. An Aurora cluster in a Multi-AZ (availability zone) deployment provides enhanced availability and durability of data. When an Aurora cluster is provisioned, Amazon creates a primary DB instance and replicates the data to a Aurora replica in another availability zone.",
  "id": "FG_R00209",
  "title": "RDS Aurora cluster multi-AZ should be enabled"
}

rds_clusters = fugue.resources("aws_rds_cluster")
rds_cluster_instances[id] = instance {

    # NOTE(jaspervdj): This validation would work a bit better when
    # `aws_rds_cluster_instance` is supported, so we can actually check that
    # they are in different AZs (the code is in this file).  Without this
    # support, we just assume that AWS does the right thing and the user doesn't
    # consciously place all instances in the same AZ.
    #
    # NOTE(jaspervdj): We also ensure that there actually are
    # `aws_rds_cluster_instance` resources in the input in order not to
    # generate wrong "missing resource types" in the rules engine.
    fugue.resource_types_v0["aws_rds_cluster_instance"]
    instances = fugue.resources("aws_rds_cluster_instance")
    instance = instances[id]
}

# Validate clusters.

runtime_bad_cluster(rdsc) {
  # NOTE (jaspervdj): When deselecting multi-AZ in the AWS console, AWS will
  # actually go ahead and add some availability zones silently.  The only way we
  # can really tell them apart is that the non-multi-AZ deployment will have a
  # single cluster instance.
  #
  # When spinning up a multi-AZ cluster using terraform, it takes a while for
  # the cluster instances to be associated with the cluster so I can see this
  # validation temporarily failing but there's not much we can do about that.
  count(rdsc.availability_zones) < 2
} {
  not rdsc.cluster_members
} {
  count(rdsc.cluster_members) < 2
} {
  # If we can see the `aws_rds_cluster_instance`s we can check that they are
  # actually in different availability zones.
  cluster_identifier = rdsc.cluster_identifier
  cluster_azs = {az |
    cluster_instance = rds_cluster_instances[_]
    cluster_instance.cluster_identifier == cluster_identifier
    az = cluster_instance.availability_zone
  }

  # We consider 0 to be valid as well since it means we couldn't find the
  # cluster instances.
  count(cluster_azs) == 1
}

iac_good_cluster(rdsc) {
  count(rdsc.availability_zones) >= 2
}

bad_cluster(rdsc) {
  fugue.input_type == "tf_runtime"
  runtime_bad_cluster(rdsc)
} {
  fugue.input_type != "tf_runtime"
  not iac_good_cluster(rdsc)
}

resource_type = "MULTIPLE"

policy[j] {
  rdsc = rds_clusters[_]
  bad_cluster(rdsc)
  j = fugue.deny_resource(rdsc)
} {
  rdsc = rds_clusters[_]
  not bad_cluster(rdsc)
  j = fugue.allow_resource(rdsc)
}

