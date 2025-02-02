# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

variable "karpenter_version" {
  description = "Karpenter Version"
  default     = "0.6.5"
  type        = string
}


variable "bottlerocket_k8s_version" {
  description = "Kubernetes version for Bottlerocket AMI"
  default     = "1.22"
  type        = string
}

