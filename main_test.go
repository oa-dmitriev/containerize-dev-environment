package main

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestEcho(t *testing.T) {
	err := echo([]string{"bin-name", "hello", "world!"})
	require.NoError(t, err)
}

func TestEchoErrorNoArgs(t *testing.T) {
	err := echo([]string{})
	require.Error(t, err)
}
