Definitions.

ARG_DOUBLE_QUOTED_TXT   = "([^"\\]|(\\"))+"
ARG_SINGLE_QUOTED_TXT   = '([^'\\]|(\\'))+'
ARG_INT                 = (\+|-)?[0-9]+
ARG_FLOAT               = (\+|-)?[0-9]+\.[0-9]+((E|e)(\+|-)?[0-9]+)?
ARG_BOOL                = ((t|T)(r|R)(u|U)(e|E))|((f|F)(a|A)(l|L)(s|S)(e|E))
OP_AND                  = ((a|A)(n|N)(d|D))
OP_OR                   = ((o|O)(r|R))
OP_EQ                   = ==
OP_NOT_EQ               = !=
WHITESPACE              = [\s\t\n\r]

Rules.

{ARG_FLOAT}             : {token, {arg_float, TokenLine, list_to_float(TokenChars)}}.
{ARG_INT}               : {token, {arg_int, TokenLine, list_to_integer(TokenChars)}}.
{ARG_BOOL}              : {token, {arg_bool, TokenLine, list_to_bool(TokenChars)}}.
{OP_OR}                 : {token, {or_op,  TokenLine}}.
{OP_AND}                : {token, {and_op,  TokenLine}}.
{ARG_DOUBLE_QUOTED_TXT} : {token, {arg_string, TokenLine, from_double_quoted(TokenChars)}}.
{ARG_SINGLE_QUOTED_TXT} : {token, {arg_string, TokenLine, from_single_quoted(TokenChars)}}.
\(                      : {token, {'(',  TokenLine}}.
\)                      : {token, {')',  TokenLine}}.
{OP_EQ}                 : {token, {equal,  TokenLine}}.
{OP_NOT_EQ}             : {token, {not_equal,  TokenLine}}.
{WHITESPACE}+           : skip_token.

Erlang code.

to_bool(<<"true">>) ->
  true;
to_bool(<<"false">>) ->
  false.

list_to_bool(Chars) ->
  to_bool(string:lowercase(list_to_binary(Chars))).

from_double_quoted(Chars) ->
  binary_to_list(re:replace(string:slice(list_to_binary(Chars), 1, string:length(list_to_binary(Chars))-2), "\\\\\"", "\"", [global, {return, binary}])).

from_single_quoted(Chars) ->
  binary_to_list(re:replace(string:slice(list_to_binary(Chars), 1, string:length(list_to_binary(Chars))-2), "\\\\'", "'", [global, {return, binary}])).
