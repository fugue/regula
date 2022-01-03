package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/alecthomas/participle/v2"
	"github.com/alecthomas/repr"
	"github.com/fugue/regula/pkg/arm"
)

func main() {
	parser, err := participle.Build(
		&arm.ArmProgram{},
		participle.Lexer(arm.ArmLexer),
		participle.Unquote("String"),
	)
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Fprintf(os.Stdout, ">> ")
		scanned := scanner.Scan()
		if !scanned {
			return
		}

		line := scanner.Text()

		expr := &arm.ArmProgram{}
		if err := parser.ParseString("", line, expr); err != nil {
			panic(err)
		}
		repr.Println(expr, repr.Indent("  "), repr.OmitEmpty(true))
		ctx := arm.NewEvalContext()
		output, err := ctx.Eval(*expr)
		if err != nil {
			fmt.Fprintf(os.Stdout, "Error: %v\n", err)
		} else {
			fmt.Fprintf(os.Stdout, "Output: %v\n", output.GoString())
		}
	}
}
