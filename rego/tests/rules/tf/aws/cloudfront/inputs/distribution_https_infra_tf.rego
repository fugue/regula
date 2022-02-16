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
package tests.rules.tf.aws.cloudfront.inputs.distribution_https_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_cloudfront_distribution.allow_all": {
      "_filepath": "tests/rules/tf/aws/cloudfront/inputs/distribution_https_infra.tf",
      "_provider": "aws",
      "_type": "aws_cloudfront_distribution",
      "default_cache_behavior": [
        {
          "allowed_methods": [
            "HEAD",
            "GET"
          ],
          "cached_methods": [
            "HEAD",
            "GET"
          ],
          "forwarded_values": [
            {
              "cookies": [
                {
                  "forward": "none"
                }
              ],
              "query_string": false
            }
          ],
          "target_origin_id": "aws_s3_bucket.bucket",
          "viewer_protocol_policy": "allow-all"
        }
      ],
      "enabled": true,
      "id": "aws_cloudfront_distribution.allow_all",
      "origin": [
        {
          "domain_name": "aws_s3_bucket.bucket",
          "origin_id": "aws_s3_bucket.bucket",
          "s3_origin_config": [
            {
              "origin_access_identity": "origin-access-identity/cloudfront/aws_cloudfront_origin_access_identity.origin_access_identity"
            }
          ]
        }
      ],
      "restrictions": [
        {
          "geo_restriction": [
            {
              "restriction_type": "none"
            }
          ]
        }
      ],
      "viewer_certificate": [
        {
          "cloudfront_default_certificate": true
        }
      ]
    },
    "aws_cloudfront_distribution.https_only": {
      "_filepath": "tests/rules/tf/aws/cloudfront/inputs/distribution_https_infra.tf",
      "_provider": "aws",
      "_type": "aws_cloudfront_distribution",
      "default_cache_behavior": [
        {
          "allowed_methods": [
            "HEAD",
            "GET"
          ],
          "cached_methods": [
            "HEAD",
            "GET"
          ],
          "forwarded_values": [
            {
              "cookies": [
                {
                  "forward": "none"
                }
              ],
              "query_string": false
            }
          ],
          "target_origin_id": "aws_s3_bucket.bucket",
          "viewer_protocol_policy": "https-only"
        }
      ],
      "enabled": true,
      "id": "aws_cloudfront_distribution.https_only",
      "origin": [
        {
          "domain_name": "aws_s3_bucket.bucket",
          "origin_id": "aws_s3_bucket.bucket",
          "s3_origin_config": [
            {
              "origin_access_identity": "origin-access-identity/cloudfront/aws_cloudfront_origin_access_identity.origin_access_identity"
            }
          ]
        }
      ],
      "restrictions": [
        {
          "geo_restriction": [
            {
              "restriction_type": "none"
            }
          ]
        }
      ],
      "viewer_certificate": [
        {
          "cloudfront_default_certificate": true
        }
      ]
    },
    "aws_cloudfront_distribution.redirect_to_https": {
      "_filepath": "tests/rules/tf/aws/cloudfront/inputs/distribution_https_infra.tf",
      "_provider": "aws",
      "_type": "aws_cloudfront_distribution",
      "default_cache_behavior": [
        {
          "allowed_methods": [
            "HEAD",
            "GET"
          ],
          "cached_methods": [
            "HEAD",
            "GET"
          ],
          "forwarded_values": [
            {
              "cookies": [
                {
                  "forward": "none"
                }
              ],
              "query_string": false
            }
          ],
          "target_origin_id": "aws_s3_bucket.bucket",
          "viewer_protocol_policy": "redirect-to-https"
        }
      ],
      "enabled": true,
      "id": "aws_cloudfront_distribution.redirect_to_https",
      "origin": [
        {
          "domain_name": "aws_s3_bucket.bucket",
          "origin_id": "aws_s3_bucket.bucket",
          "s3_origin_config": [
            {
              "origin_access_identity": "origin-access-identity/cloudfront/aws_cloudfront_origin_access_identity.origin_access_identity"
            }
          ]
        }
      ],
      "restrictions": [
        {
          "geo_restriction": [
            {
              "restriction_type": "none"
            }
          ]
        }
      ],
      "viewer_certificate": [
        {
          "cloudfront_default_certificate": true
        }
      ]
    },
    "aws_cloudfront_origin_access_identity.origin_access_identity": {
      "_filepath": "tests/rules/tf/aws/cloudfront/inputs/distribution_https_infra.tf",
      "_provider": "aws",
      "_type": "aws_cloudfront_origin_access_identity",
      "id": "aws_cloudfront_origin_access_identity.origin_access_identity"
    },
    "aws_s3_bucket.bucket": {
      "_filepath": "tests/rules/tf/aws/cloudfront/inputs/distribution_https_infra.tf",
      "_provider": "aws",
      "_type": "aws_s3_bucket",
      "force_destroy": true,
      "id": "aws_s3_bucket.bucket"
    }
  }
}

