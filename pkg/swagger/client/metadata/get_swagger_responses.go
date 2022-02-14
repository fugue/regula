// Code generated by go-swagger; DO NOT EDIT.

package metadata

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"fmt"
	"io"

	"github.com/go-openapi/runtime"
	"github.com/go-openapi/strfmt"

	"github.com/fugue/regula/v2/pkg/swagger/models"
)

// GetSwaggerReader is a Reader for the GetSwagger structure.
type GetSwaggerReader struct {
	formats strfmt.Registry
}

// ReadResponse reads a server response into the received o.
func (o *GetSwaggerReader) ReadResponse(response runtime.ClientResponse, consumer runtime.Consumer) (interface{}, error) {
	switch response.Code() {
	case 200:
		result := NewGetSwaggerOK()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return result, nil
	case 500:
		result := NewGetSwaggerInternalServerError()
		if err := result.readResponse(response, consumer, o.formats); err != nil {
			return nil, err
		}
		return nil, result

	default:
		return nil, runtime.NewAPIError("unknown error", response, response.Code())
	}
}

// NewGetSwaggerOK creates a GetSwaggerOK with default headers values
func NewGetSwaggerOK() *GetSwaggerOK {
	return &GetSwaggerOK{}
}

/*GetSwaggerOK handles this case with default header values.

OpenAPI 2.0 specification.
*/
type GetSwaggerOK struct {
	Payload interface{}
}

func (o *GetSwaggerOK) Error() string {
	return fmt.Sprintf("[GET /swagger][%d] getSwaggerOK  %+v", 200, o.Payload)
}

func (o *GetSwaggerOK) GetPayload() interface{} {
	return o.Payload
}

func (o *GetSwaggerOK) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	// response payload
	if err := consumer.Consume(response.Body(), &o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}

// NewGetSwaggerInternalServerError creates a GetSwaggerInternalServerError with default headers values
func NewGetSwaggerInternalServerError() *GetSwaggerInternalServerError {
	return &GetSwaggerInternalServerError{}
}

/*GetSwaggerInternalServerError handles this case with default header values.

InternalServerError
*/
type GetSwaggerInternalServerError struct {
	Payload *models.InternalServerError
}

func (o *GetSwaggerInternalServerError) Error() string {
	return fmt.Sprintf("[GET /swagger][%d] getSwaggerInternalServerError  %+v", 500, o.Payload)
}

func (o *GetSwaggerInternalServerError) GetPayload() *models.InternalServerError {
	return o.Payload
}

func (o *GetSwaggerInternalServerError) readResponse(response runtime.ClientResponse, consumer runtime.Consumer, formats strfmt.Registry) error {

	o.Payload = new(models.InternalServerError)

	// response payload
	if err := consumer.Consume(response.Body(), o.Payload); err != nil && err != io.EOF {
		return err
	}

	return nil
}
