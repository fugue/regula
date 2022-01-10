package arm

import (
	"github.com/alecthomas/participle/v2"
	"github.com/alecthomas/participle/v2/lexer"
)

var ArmLexer = lexer.MustSimple([]lexer.Rule{
	// {Name: "Comment", Pattern: `(?i)rem[^\n]*`},
	{Name: "String", Pattern: `'(\\'|[^'])*'`},
	{Name: "Number", Pattern: `[-+]?(\d*\.)?\d+`},
	{Name: "Ident", Pattern: `[a-zA-Z_]\w*`},
	{Name: "Punct", Pattern: `[-[!@#$%^&*()+_={}\|:;"'<,>.?/]|]`},
	// {Name: "EOL", Pattern: `[\n\r]+`},
	{Name: "whitespace", Pattern: `[ \t]+`},
})

type ArmProgram struct {
	Pos lexer.Position

	Expression *ArmExpression `"[" @@ "]"`
}

type ArmExpression struct {
	Pos lexer.Position

	ParamAccess    *ArmParamAccess    `( @@`
	VariableAccess *ArmVariableAccess `| @@`
	Call           *ArmCall           `| @@`
	Value          *ArmValue          `| @@`
	Subexpression  *ArmExpression     `| "(" @@ ")" )`
}

type ArmParamAccess struct {
	Args []*ArmExpression `"parameters(" ( @@ ( ","  @@ )* )? ")"`
}

type ArmVariableAccess struct {
	Args []*ArmExpression `"variables(" ( @@ ( ","  @@ )* )? ")"`
}

type ArmCall struct {
	Pos lexer.Position

	Name string           `@Ident`
	Args []*ArmExpression `"(" ( @@ ( ","  @@ )* )? ")"`
}

type ArmValue struct {
	Pos lexer.Position

	Integer  *float64 `  @Number`
	Variable *string  `| @Ident`
	String   *string  `| @String`
}

type ArmParser struct {
	parser *participle.Parser
}

func (p *ArmParser) Parse(s string) (*ArmProgram, error) {
	program := &ArmProgram{}
	if err := p.parser.ParseString("", s, program); err != nil {
		return nil, err
	}
	return program, nil
}

func NewParser() (*ArmParser, error) {
	parser, err := participle.Build(
		&ArmProgram{},
		participle.Lexer(ArmLexer),
		participle.Unquote("String"),
	)
	if err != nil {
		return nil, err
	}
	return &ArmParser{parser}, nil
}
