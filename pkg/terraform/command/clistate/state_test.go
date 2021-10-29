package clistate

import (
	"testing"

	"github.com/fugue/regula/pkg/terraform/command/arguments"
	"github.com/fugue/regula/pkg/terraform/command/views"
	"github.com/fugue/regula/pkg/terraform/states/statemgr"
	"github.com/fugue/regula/pkg/terraform/terminal"
)

func TestUnlock(t *testing.T) {
	streams, _ := terminal.StreamsForTesting(t)
	view := views.NewView(streams)

	l := NewLocker(0, views.NewStateLocker(arguments.ViewHuman, view))
	l.Lock(statemgr.NewUnlockErrorFull(nil, nil), "test-lock")

	diags := l.Unlock()
	if diags.HasErrors() {
		t.Log(diags.Err().Error())
	} else {
		t.Error("expected error")
	}
}
