// Code generated by MockGen. DO NOT EDIT.
// Source: github.com/fugue/regula/v2/pkg/loader (interfaces: ConfigurationDetector)

// Package mocks is a generated GoMock package.
package mocks

import (
	reflect "reflect"

	loader "github.com/fugue/regula/v2/pkg/loader"
	gomock "github.com/golang/mock/gomock"
)

// MockConfigurationDetector is a mock of ConfigurationDetector interface.
type MockConfigurationDetector struct {
	ctrl     *gomock.Controller
	recorder *MockConfigurationDetectorMockRecorder
}

// MockConfigurationDetectorMockRecorder is the mock recorder for MockConfigurationDetector.
type MockConfigurationDetectorMockRecorder struct {
	mock *MockConfigurationDetector
}

// NewMockConfigurationDetector creates a new mock instance.
func NewMockConfigurationDetector(ctrl *gomock.Controller) *MockConfigurationDetector {
	mock := &MockConfigurationDetector{ctrl: ctrl}
	mock.recorder = &MockConfigurationDetectorMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockConfigurationDetector) EXPECT() *MockConfigurationDetectorMockRecorder {
	return m.recorder
}

// DetectDirectory mocks base method.
func (m *MockConfigurationDetector) DetectDirectory(arg0 loader.InputDirectory, arg1 loader.DetectOptions) (loader.IACConfiguration, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "DetectDirectory", arg0, arg1)
	ret0, _ := ret[0].(loader.IACConfiguration)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// DetectDirectory indicates an expected call of DetectDirectory.
func (mr *MockConfigurationDetectorMockRecorder) DetectDirectory(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "DetectDirectory", reflect.TypeOf((*MockConfigurationDetector)(nil).DetectDirectory), arg0, arg1)
}

// DetectFile mocks base method.
func (m *MockConfigurationDetector) DetectFile(arg0 loader.InputFile, arg1 loader.DetectOptions) (loader.IACConfiguration, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "DetectFile", arg0, arg1)
	ret0, _ := ret[0].(loader.IACConfiguration)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// DetectFile indicates an expected call of DetectFile.
func (mr *MockConfigurationDetectorMockRecorder) DetectFile(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "DetectFile", reflect.TypeOf((*MockConfigurationDetector)(nil).DetectFile), arg0, arg1)
}
