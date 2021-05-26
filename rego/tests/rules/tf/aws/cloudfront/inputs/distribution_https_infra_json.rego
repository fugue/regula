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
package tests.rules.tf.aws.cloudfront.inputs.distribution_https_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "configuration": {
    "provider_config": {
      "aws": {
        "expressions": {
          "region": {
            "constant_value": "us-east-1"
          }
        },
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudfront_distribution.allow_all",
          "expressions": {
            "default_cache_behavior": [
              {
                "allowed_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "cached_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "forwarded_values": [
                  {
                    "cookies": [
                      {
                        "forward": {
                          "constant_value": "none"
                        }
                      }
                    ],
                    "query_string": {
                      "constant_value": false
                    }
                  }
                ],
                "target_origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "viewer_protocol_policy": {
                  "constant_value": "allow-all"
                }
              }
            ],
            "enabled": {
              "constant_value": true
            },
            "origin": [
              {
                "domain_name": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "s3_origin_config": [
                  {
                    "origin_access_identity": {
                      "references": [
                        "aws_cloudfront_origin_access_identity.origin_access_identity"
                      ]
                    }
                  }
                ]
              }
            ],
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": {
                      "constant_value": "none"
                    }
                  }
                ]
              }
            ],
            "viewer_certificate": [
              {
                "cloudfront_default_certificate": {
                  "constant_value": true
                }
              }
            ]
          },
          "mode": "managed",
          "name": "allow_all",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution"
        },
        {
          "address": "aws_cloudfront_distribution.https_only",
          "expressions": {
            "default_cache_behavior": [
              {
                "allowed_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "cached_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "forwarded_values": [
                  {
                    "cookies": [
                      {
                        "forward": {
                          "constant_value": "none"
                        }
                      }
                    ],
                    "query_string": {
                      "constant_value": false
                    }
                  }
                ],
                "target_origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "viewer_protocol_policy": {
                  "constant_value": "https-only"
                }
              }
            ],
            "enabled": {
              "constant_value": true
            },
            "origin": [
              {
                "domain_name": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "s3_origin_config": [
                  {
                    "origin_access_identity": {
                      "references": [
                        "aws_cloudfront_origin_access_identity.origin_access_identity"
                      ]
                    }
                  }
                ]
              }
            ],
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": {
                      "constant_value": "none"
                    }
                  }
                ]
              }
            ],
            "viewer_certificate": [
              {
                "cloudfront_default_certificate": {
                  "constant_value": true
                }
              }
            ]
          },
          "mode": "managed",
          "name": "https_only",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution"
        },
        {
          "address": "aws_cloudfront_distribution.redirect_to_https",
          "expressions": {
            "default_cache_behavior": [
              {
                "allowed_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "cached_methods": {
                  "constant_value": [
                    "HEAD",
                    "GET"
                  ]
                },
                "forwarded_values": [
                  {
                    "cookies": [
                      {
                        "forward": {
                          "constant_value": "none"
                        }
                      }
                    ],
                    "query_string": {
                      "constant_value": false
                    }
                  }
                ],
                "target_origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "viewer_protocol_policy": {
                  "constant_value": "redirect-to-https"
                }
              }
            ],
            "enabled": {
              "constant_value": true
            },
            "origin": [
              {
                "domain_name": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "origin_id": {
                  "references": [
                    "aws_s3_bucket.bucket"
                  ]
                },
                "s3_origin_config": [
                  {
                    "origin_access_identity": {
                      "references": [
                        "aws_cloudfront_origin_access_identity.origin_access_identity"
                      ]
                    }
                  }
                ]
              }
            ],
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": {
                      "constant_value": "none"
                    }
                  }
                ]
              }
            ],
            "viewer_certificate": [
              {
                "cloudfront_default_certificate": {
                  "constant_value": true
                }
              }
            ]
          },
          "mode": "managed",
          "name": "redirect_to_https",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution"
        },
        {
          "address": "aws_cloudfront_origin_access_identity.origin_access_identity",
          "mode": "managed",
          "name": "origin_access_identity",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudfront_origin_access_identity"
        },
        {
          "address": "aws_s3_bucket.bucket",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "bucket",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudfront_distribution.allow_all",
          "mode": "managed",
          "name": "allow_all",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution",
          "values": {
            "aliases": null,
            "comment": null,
            "custom_error_response": [],
            "default_cache_behavior": [
              {
                "allowed_methods": [
                  "GET",
                  "HEAD"
                ],
                "cache_policy_id": null,
                "cached_methods": [
                  "GET",
                  "HEAD"
                ],
                "compress": false,
                "field_level_encryption_id": null,
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
                "lambda_function_association": [],
                "min_ttl": 0,
                "origin_request_policy_id": null,
                "realtime_log_config_arn": null,
                "smooth_streaming": null,
                "viewer_protocol_policy": "allow-all"
              }
            ],
            "default_root_object": null,
            "enabled": true,
            "http_version": "http2",
            "is_ipv6_enabled": false,
            "logging_config": [],
            "ordered_cache_behavior": [],
            "origin": [
              {
                "custom_header": [],
                "custom_origin_config": [],
                "origin_path": "",
                "s3_origin_config": [
                  {}
                ]
              }
            ],
            "origin_group": [],
            "price_class": "PriceClass_All",
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": "none"
                  }
                ]
              }
            ],
            "retain_on_delete": false,
            "tags": null,
            "viewer_certificate": [
              {
                "acm_certificate_arn": null,
                "cloudfront_default_certificate": true,
                "iam_certificate_id": null,
                "minimum_protocol_version": "TLSv1",
                "ssl_support_method": null
              }
            ],
            "wait_for_deployment": true,
            "web_acl_id": null
          }
        },
        {
          "address": "aws_cloudfront_distribution.https_only",
          "mode": "managed",
          "name": "https_only",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution",
          "values": {
            "aliases": null,
            "comment": null,
            "custom_error_response": [],
            "default_cache_behavior": [
              {
                "allowed_methods": [
                  "GET",
                  "HEAD"
                ],
                "cache_policy_id": null,
                "cached_methods": [
                  "GET",
                  "HEAD"
                ],
                "compress": false,
                "field_level_encryption_id": null,
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
                "lambda_function_association": [],
                "min_ttl": 0,
                "origin_request_policy_id": null,
                "realtime_log_config_arn": null,
                "smooth_streaming": null,
                "viewer_protocol_policy": "https-only"
              }
            ],
            "default_root_object": null,
            "enabled": true,
            "http_version": "http2",
            "is_ipv6_enabled": false,
            "logging_config": [],
            "ordered_cache_behavior": [],
            "origin": [
              {
                "custom_header": [],
                "custom_origin_config": [],
                "origin_path": "",
                "s3_origin_config": [
                  {}
                ]
              }
            ],
            "origin_group": [],
            "price_class": "PriceClass_All",
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": "none"
                  }
                ]
              }
            ],
            "retain_on_delete": false,
            "tags": null,
            "viewer_certificate": [
              {
                "acm_certificate_arn": null,
                "cloudfront_default_certificate": true,
                "iam_certificate_id": null,
                "minimum_protocol_version": "TLSv1",
                "ssl_support_method": null
              }
            ],
            "wait_for_deployment": true,
            "web_acl_id": null
          }
        },
        {
          "address": "aws_cloudfront_distribution.redirect_to_https",
          "mode": "managed",
          "name": "redirect_to_https",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_cloudfront_distribution",
          "values": {
            "aliases": null,
            "comment": null,
            "custom_error_response": [],
            "default_cache_behavior": [
              {
                "allowed_methods": [
                  "GET",
                  "HEAD"
                ],
                "cache_policy_id": null,
                "cached_methods": [
                  "GET",
                  "HEAD"
                ],
                "compress": false,
                "field_level_encryption_id": null,
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
                "lambda_function_association": [],
                "min_ttl": 0,
                "origin_request_policy_id": null,
                "realtime_log_config_arn": null,
                "smooth_streaming": null,
                "viewer_protocol_policy": "redirect-to-https"
              }
            ],
            "default_root_object": null,
            "enabled": true,
            "http_version": "http2",
            "is_ipv6_enabled": false,
            "logging_config": [],
            "ordered_cache_behavior": [],
            "origin": [
              {
                "custom_header": [],
                "custom_origin_config": [],
                "origin_path": "",
                "s3_origin_config": [
                  {}
                ]
              }
            ],
            "origin_group": [],
            "price_class": "PriceClass_All",
            "restrictions": [
              {
                "geo_restriction": [
                  {
                    "restriction_type": "none"
                  }
                ]
              }
            ],
            "retain_on_delete": false,
            "tags": null,
            "viewer_certificate": [
              {
                "acm_certificate_arn": null,
                "cloudfront_default_certificate": true,
                "iam_certificate_id": null,
                "minimum_protocol_version": "TLSv1",
                "ssl_support_method": null
              }
            ],
            "wait_for_deployment": true,
            "web_acl_id": null
          }
        },
        {
          "address": "aws_cloudfront_origin_access_identity.origin_access_identity",
          "mode": "managed",
          "name": "origin_access_identity",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_cloudfront_origin_access_identity",
          "values": {
            "comment": null
          }
        },
        {
          "address": "aws_s3_bucket.bucket",
          "mode": "managed",
          "name": "bucket",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_s3_bucket",
          "values": {
            "acl": "private",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": true,
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "policy": null,
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": null,
            "website": []
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_cloudfront_distribution.allow_all",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "aliases": null,
          "comment": null,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                "GET",
                "HEAD"
              ],
              "cache_policy_id": null,
              "cached_methods": [
                "GET",
                "HEAD"
              ],
              "compress": false,
              "field_level_encryption_id": null,
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
              "lambda_function_association": [],
              "min_ttl": 0,
              "origin_request_policy_id": null,
              "realtime_log_config_arn": null,
              "smooth_streaming": null,
              "viewer_protocol_policy": "allow-all"
            }
          ],
          "default_root_object": null,
          "enabled": true,
          "http_version": "http2",
          "is_ipv6_enabled": false,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "origin_path": "",
              "s3_origin_config": [
                {}
              ]
            }
          ],
          "origin_group": [],
          "price_class": "PriceClass_All",
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "restriction_type": "none"
                }
              ]
            }
          ],
          "retain_on_delete": false,
          "tags": null,
          "viewer_certificate": [
            {
              "acm_certificate_arn": null,
              "cloudfront_default_certificate": true,
              "iam_certificate_id": null,
              "minimum_protocol_version": "TLSv1",
              "ssl_support_method": null
            }
          ],
          "wait_for_deployment": true,
          "web_acl_id": null
        },
        "after_unknown": {
          "arn": true,
          "caller_reference": true,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                false,
                false
              ],
              "cached_methods": [
                false,
                false
              ],
              "default_ttl": true,
              "forwarded_values": [
                {
                  "cookies": [
                    {
                      "whitelisted_names": true
                    }
                  ],
                  "headers": true,
                  "query_string_cache_keys": true
                }
              ],
              "lambda_function_association": [],
              "max_ttl": true,
              "target_origin_id": true,
              "trusted_key_groups": true,
              "trusted_signers": true
            }
          ],
          "domain_name": true,
          "etag": true,
          "hosted_zone_id": true,
          "id": true,
          "in_progress_validation_batches": true,
          "last_modified_time": true,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "domain_name": true,
              "origin_id": true,
              "s3_origin_config": [
                {
                  "origin_access_identity": true
                }
              ]
            }
          ],
          "origin_group": [],
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "locations": true
                }
              ]
            }
          ],
          "status": true,
          "tags_all": true,
          "trusted_key_groups": true,
          "trusted_signers": true,
          "viewer_certificate": [
            {}
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "allow_all",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudfront_distribution"
    },
    {
      "address": "aws_cloudfront_distribution.https_only",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "aliases": null,
          "comment": null,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                "GET",
                "HEAD"
              ],
              "cache_policy_id": null,
              "cached_methods": [
                "GET",
                "HEAD"
              ],
              "compress": false,
              "field_level_encryption_id": null,
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
              "lambda_function_association": [],
              "min_ttl": 0,
              "origin_request_policy_id": null,
              "realtime_log_config_arn": null,
              "smooth_streaming": null,
              "viewer_protocol_policy": "https-only"
            }
          ],
          "default_root_object": null,
          "enabled": true,
          "http_version": "http2",
          "is_ipv6_enabled": false,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "origin_path": "",
              "s3_origin_config": [
                {}
              ]
            }
          ],
          "origin_group": [],
          "price_class": "PriceClass_All",
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "restriction_type": "none"
                }
              ]
            }
          ],
          "retain_on_delete": false,
          "tags": null,
          "viewer_certificate": [
            {
              "acm_certificate_arn": null,
              "cloudfront_default_certificate": true,
              "iam_certificate_id": null,
              "minimum_protocol_version": "TLSv1",
              "ssl_support_method": null
            }
          ],
          "wait_for_deployment": true,
          "web_acl_id": null
        },
        "after_unknown": {
          "arn": true,
          "caller_reference": true,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                false,
                false
              ],
              "cached_methods": [
                false,
                false
              ],
              "default_ttl": true,
              "forwarded_values": [
                {
                  "cookies": [
                    {
                      "whitelisted_names": true
                    }
                  ],
                  "headers": true,
                  "query_string_cache_keys": true
                }
              ],
              "lambda_function_association": [],
              "max_ttl": true,
              "target_origin_id": true,
              "trusted_key_groups": true,
              "trusted_signers": true
            }
          ],
          "domain_name": true,
          "etag": true,
          "hosted_zone_id": true,
          "id": true,
          "in_progress_validation_batches": true,
          "last_modified_time": true,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "domain_name": true,
              "origin_id": true,
              "s3_origin_config": [
                {
                  "origin_access_identity": true
                }
              ]
            }
          ],
          "origin_group": [],
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "locations": true
                }
              ]
            }
          ],
          "status": true,
          "tags_all": true,
          "trusted_key_groups": true,
          "trusted_signers": true,
          "viewer_certificate": [
            {}
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "https_only",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudfront_distribution"
    },
    {
      "address": "aws_cloudfront_distribution.redirect_to_https",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "aliases": null,
          "comment": null,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                "GET",
                "HEAD"
              ],
              "cache_policy_id": null,
              "cached_methods": [
                "GET",
                "HEAD"
              ],
              "compress": false,
              "field_level_encryption_id": null,
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
              "lambda_function_association": [],
              "min_ttl": 0,
              "origin_request_policy_id": null,
              "realtime_log_config_arn": null,
              "smooth_streaming": null,
              "viewer_protocol_policy": "redirect-to-https"
            }
          ],
          "default_root_object": null,
          "enabled": true,
          "http_version": "http2",
          "is_ipv6_enabled": false,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "origin_path": "",
              "s3_origin_config": [
                {}
              ]
            }
          ],
          "origin_group": [],
          "price_class": "PriceClass_All",
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "restriction_type": "none"
                }
              ]
            }
          ],
          "retain_on_delete": false,
          "tags": null,
          "viewer_certificate": [
            {
              "acm_certificate_arn": null,
              "cloudfront_default_certificate": true,
              "iam_certificate_id": null,
              "minimum_protocol_version": "TLSv1",
              "ssl_support_method": null
            }
          ],
          "wait_for_deployment": true,
          "web_acl_id": null
        },
        "after_unknown": {
          "arn": true,
          "caller_reference": true,
          "custom_error_response": [],
          "default_cache_behavior": [
            {
              "allowed_methods": [
                false,
                false
              ],
              "cached_methods": [
                false,
                false
              ],
              "default_ttl": true,
              "forwarded_values": [
                {
                  "cookies": [
                    {
                      "whitelisted_names": true
                    }
                  ],
                  "headers": true,
                  "query_string_cache_keys": true
                }
              ],
              "lambda_function_association": [],
              "max_ttl": true,
              "target_origin_id": true,
              "trusted_key_groups": true,
              "trusted_signers": true
            }
          ],
          "domain_name": true,
          "etag": true,
          "hosted_zone_id": true,
          "id": true,
          "in_progress_validation_batches": true,
          "last_modified_time": true,
          "logging_config": [],
          "ordered_cache_behavior": [],
          "origin": [
            {
              "custom_header": [],
              "custom_origin_config": [],
              "domain_name": true,
              "origin_id": true,
              "s3_origin_config": [
                {
                  "origin_access_identity": true
                }
              ]
            }
          ],
          "origin_group": [],
          "restrictions": [
            {
              "geo_restriction": [
                {
                  "locations": true
                }
              ]
            }
          ],
          "status": true,
          "tags_all": true,
          "trusted_key_groups": true,
          "trusted_signers": true,
          "viewer_certificate": [
            {}
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "redirect_to_https",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudfront_distribution"
    },
    {
      "address": "aws_cloudfront_origin_access_identity.origin_access_identity",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "comment": null
        },
        "after_unknown": {
          "caller_reference": true,
          "cloudfront_access_identity_path": true,
          "etag": true,
          "iam_arn": true,
          "id": true,
          "s3_canonical_user_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "origin_access_identity",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudfront_origin_access_identity"
    },
    {
      "address": "aws_s3_bucket.bucket",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "acl": "private",
          "bucket_prefix": null,
          "cors_rule": [],
          "force_destroy": true,
          "grant": [],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "policy": null,
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": null,
          "website": []
        },
        "after_unknown": {
          "acceleration_status": true,
          "arn": true,
          "bucket": true,
          "bucket_domain_name": true,
          "bucket_regional_domain_name": true,
          "cors_rule": [],
          "grant": [],
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "region": true,
          "replication_configuration": [],
          "request_payer": true,
          "server_side_encryption_configuration": [],
          "tags_all": true,
          "versioning": true,
          "website": [],
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "bucket",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    }
  ],
  "terraform_version": "0.13.5"
}

