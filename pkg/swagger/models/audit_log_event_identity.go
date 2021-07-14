// Code generated by go-swagger; DO NOT EDIT.

package models

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"github.com/go-openapi/strfmt"
	"github.com/go-openapi/swag"
)

// AuditLogEventIdentity audit log event identity
//
// swagger:model AuditLogEventIdentity
type AuditLogEventIdentity struct {

	// email
	Email string `json:"email,omitempty"`

	// name
	Name string `json:"name,omitempty"`

	// principal id
	PrincipalID string `json:"principal_id,omitempty"`

	// principal kind
	PrincipalKind string `json:"principal_kind,omitempty"`
}

// Validate validates this audit log event identity
func (m *AuditLogEventIdentity) Validate(formats strfmt.Registry) error {
	return nil
}

// MarshalBinary interface implementation
func (m *AuditLogEventIdentity) MarshalBinary() ([]byte, error) {
	if m == nil {
		return nil, nil
	}
	return swag.WriteJSON(m)
}

// UnmarshalBinary interface implementation
func (m *AuditLogEventIdentity) UnmarshalBinary(b []byte) error {
	var res AuditLogEventIdentity
	if err := swag.ReadJSON(b, &res); err != nil {
		return err
	}
	*m = res
	return nil
}
