package regulatf

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestTfFilePathJoin(t *testing.T) {
	assert.Equal(t, TfFilePathJoin(".", "examples/mssql/"), "examples/mssql/")
	assert.Equal(t, TfFilePathJoin("modules", "./examples/mssql/"), "modules/examples/mssql/")
	assert.Equal(t, TfFilePathJoin("examples/mssql/", "../../"), "examples/mssql/../../")
	assert.Equal(t, TfFilePathJoin("examples/mssql/", "./../../"), "examples/mssql/../../")
}
