// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package fugue

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/fugue/regula/v3/pkg/reporter"
	"github.com/fugue/regula/v3/pkg/swagger/client/scans"
	"github.com/sirupsen/logrus"
)

func (c *fugueClient) UploadScan(ctx context.Context, environmentID string, scanView reporter.ScanView) error {
	// Create scan.
	logrus.Debugf("Creating scan for environment %s...", environmentID)
	createScanParams := &scans.CreateScanParams{
		EnvironmentID: environmentID,
		Context:       ctx,
	}
	createScanResponse, err := c.client.Scans.CreateScan(createScanParams, c.auth)
	if err != nil {
		return err
	}
	// Get presigned S3 URL for scan view upload.
	scanId := createScanResponse.Payload.ID
	logrus.Debugf("Retrieving presigned URL for scan %s...", scanId)
	uploadScanViewParams := &scans.UploadRegulaScanViewParams{
		ScanID:  scanId,
		Context: ctx,
	}
	uploadScanViewResponse, err := c.client.Scans.UploadRegulaScanView(uploadScanViewParams, c.auth)
	if err != nil {
		return err
	}
	// Use presigned URL to upload scan view.
	logrus.Debugf("Uploading to presigned URL...")
	uploadUrl := uploadScanViewResponse.Payload.URL
	httpClient := &http.Client{}

	// Marshal and upload scan view
	buf := &bytes.Buffer{}
	enc := json.NewEncoder(buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(scanView); err != nil {
		return err
	}
	uploadRequest, err := http.NewRequestWithContext(ctx, http.MethodPut, uploadUrl, buf)
	if err != nil {
		return err
	}
	uploadRequest.Header.Set("Content-Type", "application/json")
	uploadResponse, err := httpClient.Do(uploadRequest)
	if err != nil {
		return err
	}
	if uploadResponse.StatusCode != 200 {
		return fmt.Errorf("Upload response: %s", uploadResponse.Status)
	}
	return nil
}
