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
package cfn.cloudtrail

import data.fugue.resource_view.cloudformation

test_valid_generic_arn_pattern {
  event_selector := {
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          "arn:aws:s3:::"
        ]
      }
    ]
  }
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_specific_arn {
  event_selector := {
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          "arn:aws:s3:::BucketName"
        ]
      }
    ]
  }
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_specific_arn_slash {
  event_selector := {
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          "arn:aws:s3:::BucketName/"
        ]
      }
    ]
  }
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_specific_arn_prefix {
  event_selector := {
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          "arn:aws:s3:::BucketName/prefix"
        ]
      }
    ]
  }
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_name_uses_join {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::Join": [
              "",
              [
                "arn:aws:s3:::",
                {
                  "Fn::Join": [
                    "-",
                    [
                      "org-name",
                      {"Ref": "AWS::Region"},
                      {"Ref": "AWS::AccountId"}
                    ]
                  ]
                },
                "/"
              ]
            ]
          }
        ]
      }
    ]
  })
  bucket := cloudformation.rewrite_properties({
    "id": "BucketId",
    "BucketName": {
      "Fn::Join": [
        "-",
        [
          "org-name",
          {"Ref": "AWS::Region"},
          {"Ref": "AWS::AccountId"}
        ]
      ]
    }
  })

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_arn_using_sub {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::Sub": "${BucketId.Arn}/"
          }
        ]
      }
    ]
  })
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_valid_arn_using_get_att {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::GetAtt": [
              "BucketId",
              "Arn"
            ]
          }
        ]
      }
    ]
  })
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_invalid_specific_arn {
  event_selector := {
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          "arn:aws:s3:::BucketNameOther/"
        ]
      }
    ]
  }
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  not event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_invalid_name_uses_join {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::Join": [
              "",
              [
                "arn:aws:s3:::",
                {
                  "Fn::Join": [
                    "-",
                    [
                      "org-name",
                      {"Ref": "AWS::Region"},
                      {"Ref": "AWS::AccountId"},
                    ]
                  ]
                },
                "/"
              ]
            ]
          }
        ]
      }
    ]
  })
  bucket := cloudformation.rewrite_properties({
    "id": "BucketId",
    "BucketName": {
      "Fn::Join": [
        "-",
        [
          "org-name",
          {"Ref": "AWS::Region"},
          {"Ref": "AWS::OtherAccountId"}
        ]
      ]
    }
  })

  not event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_invalid_arn_using_sub {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::Sub": "${BucketId2.Arn}/"
          }
        ]
      }
    ]
  })
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  not event_selector_applies_to_bucket(input, bucket) with input as event_selector
}

test_invalid_arn_using_get_att {
  event_selector := cloudformation.rewrite_properties({
    "DataResources": [
      {
        "Type": "AWS::S3::Object",
        "Values": [
          {
            "Fn::GetAtt": [
              "BucketId2",
              "Arn"
            ]
          }
        ]
      }
    ]
  })
  bucket := {
    "id": "BucketId",
    "BucketName": "BucketName"
  }

  not event_selector_applies_to_bucket(input, bucket) with input as event_selector
}
