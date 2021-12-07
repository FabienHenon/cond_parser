Nonterminals or_expression and_expression constraint group arguments.
Terminals '(' ')' or_op and_op arg_float arg_int arg_bool arg_string equal not_equal.
Rootsymbol or_expression.

or_expression -> and_expression                         : '$1'.
or_expression -> or_expression or_op or_expression      : {or_op, '$1', '$3'}.

and_expression -> constraint                            : '$1'.
and_expression -> or_expression and_op or_expression    : {and_op, '$1', '$3'}.

constraint -> group                                     : '$1'.
constraint -> arguments                                 : '$1'.
constraint -> arguments equal arguments                 : {eq_op, '$1', '$3'}.
constraint -> arguments not_equal arguments             : {not_eq_op, '$1', '$3'}.

group -> '(' or_expression ')'                          : '$2'.

arguments -> arg_string                                 : list_to_binary(extract_token('$1')).
arguments -> arg_float                                  : extract_token('$1').
arguments -> arg_int                                    : extract_token('$1').
arguments -> arg_bool                                   : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
