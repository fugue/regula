// Code generated by go-swagger; DO NOT EDIT.

package environments

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"fmt"
	"io"

	"github.com/go-openapi/runtime"
	"github.com/go-openapi/strfmt"

	"github.com/fugue/regula/v2/pkg/swagger/models"
)

// GetEnvironmentReader is a Reader for the GetEnvironment structure.
type GetEnvironmentReader struct {
	formats strfmt.Registry
}

// ReadResponse reads a server response into the received o.
func (o *GetEnvironmentReader) ReadResponse(response runtime.ClientResponse, consumer runtime.Consumer) (interface{}, error) {
	switch response.Code() {
	case 200:
		result := NewGetEnvironmentOK()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return result, nil
	case 400:
		result := NewGetEnvironmentBadRequest()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result
	case 401:
		result := NewGetEnvironmentUnauthorized()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result
	case 403:
		result := NewGetEnvironmentForbidden()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result
	case 404:
		result := NewGetEnvironmentNotFound()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result
	case 500:
		result := NewGetEnvironmentInternalServerError()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result

	default:
		return nil, runtime.NewAPIError("unknown error", response, response.Code())
	}
}

// NewGetEnvironmentOK creates a GetEnvironmentOK with default headers values
func NewGetEnvironmentOK() *GetEnvironmentOK {
	return &GetEnvironmentOK{}
}

/*GetEnvironmentOK handles this case with default header values.

Environment details.
*/
type GetEnvironmentOK struct {
	Payload *models.EnvironmentWithSummary
}

func (o *GetEnvironmentOK) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentOK  %+v", 200, o.Payload)
}

func (o *GetEnvironmentOK) GetPayload() *models.EnvironmentWithSummary {
	return o.Payload
}

func (o *GetEnvironmentOK) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.EnvironmentWithSummary)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetEnvironmentBadRequest creates a GetEnvironmentBadRequest with default headers values
func NewGetEnvironmentBadRequest() *GetEnvironmentBadRequest {
	return &GetEnvironmentBadRequest{}
}

/*GetEnvironmentBadRequest handles this case with default header values.

BadRequestError
*/
type GetEnvironmentBadRequest struct {
	Payload *models.BadRequestError
}

func (o *GetEnvironmentBadRequest) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentBadRequest  %+v", 400, o.Payload)
}

func (o *GetEnvironmentBadRequest) GetPayload() *models.BadRequestError {
	return o.Payload
}

func (o *GetEnvironmentBadRequest) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.BadRequestError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetEnvironmentUnauthorized creates a GetEnvironmentUnauthorized with default headers values
func NewGetEnvironmentUnauthorized() *GetEnvironmentUnauthorized {
	return &GetEnvironmentUnauthorized{}
}

/*GetEnvironmentUnauthorized handles this case with default header values.

AuthenticationError
*/
type GetEnvironmentUnauthorized struct {
	Payload *models.AuthenticationError
}

func (o *GetEnvironmentUnauthorized) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentUnauthorized  %+v", 401, o.Payload)
}

func (o *GetEnvironmentUnauthorized) GetPayload() *models.AuthenticationError {
	return o.Payload
}

func (o *GetEnvironmentUnauthorized) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.AuthenticationError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetEnvironmentForbidden creates a GetEnvironmentForbidden with default headers values
func NewGetEnvironmentForbidden() *GetEnvironmentForbidden {
	return &GetEnvironmentForbidden{}
}

/*GetEnvironmentForbidden handles this case with default header values.

AuthorizationError
*/
type GetEnvironmentForbidden struct {
	Payload *models.AuthorizationError
}

func (o *GetEnvironmentForbidden) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentForbidden  %+v", 403, o.Payload)
}

func (o *GetEnvironmentForbidden) GetPayload() *models.AuthorizationError {
	return o.Payload
}

func (o *GetEnvironmentForbidden) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.AuthorizationError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetEnvironmentNotFound creates a GetEnvironmentNotFound with default headers values
func NewGetEnvironmentNotFound() *GetEnvironmentNotFound {
	return &GetEnvironmentNotFound{}
}

/*GetEnvironmentNotFound handles this case with default header values.

NotFoundError
*/
type GetEnvironmentNotFound struct {
	Payload *models.NotFoundError
}

func (o *GetEnvironmentNotFound) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentNotFound  %+v", 404, o.Payload)
}

func (o *GetEnvironmentNotFound) GetPayload() *models.NotFoundError {
	return o.Payload
}

func (o *GetEnvironmentNotFound) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.NotFoundError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetEnvironmentInternalServerError creates a GetEnvironmentInternalServerError with default headers values
func NewGetEnvironmentInternalServerError() *GetEnvironmentInternalServerError {
	return &GetEnvironmentInternalServerError{}
}

/*GetEnvironmentInternalServerError handles this case with default header values.

InternalServerError
*/
type GetEnvironmentInternalServerError struct {
	Payload *models.InternalServerError
}

func (o *GetEnvironmentInternalServerError) Error() string {
	return fmt.Sprintf("[GET /environments/{environment_id}][%d] getEnvironmentInternalServerError  %+v", 500, o.Payload)
}

func (o *GetEnvironmentInternalServerError) GetPayload() *models.InternalServerError {
	return o.Payload
}

func (o *GetEnvironmentInternalServerError) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.InternalServerError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}
