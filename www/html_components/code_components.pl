% Inline prolog code, syntax highlighting client-side with Prism.js
html_write:inline_code(Code) -->
    html(code(class('lang-prolog'), Code)).

% Prolog code block, non-interactive, syntax highlighting client-side with Prism.js
html_write:static_code_block(Code) --> { \+ is_list(Code) },
    html(pre(code(class('lang-prolog'), Code))).
html_write:static_code_block(Code) --> { is_list(Code), atomic_list_concat(Code, '\n', Block) },
    html(pre(code(class('lang-prolog'), Block))).

% Interactive code block
html_write:code_block(ID, Block) -->
    { atomics_to_string(Block, "\n", Code), length(Block, Rows) },
    html(textarea([class([code, 'form-control', 'mb-2', 'text-monospace']), id(ID), rows(Rows)], Code)).

% Interactive code block
html_write:hidden_code_block(ID, Block) -->
    { atomics_to_string(Block, "\n", Code), length(Block, Rows) },
    html(textarea([class([code, 'form-control', 'mb-2', 'text-monospace', collapse]), id(ID), rows(Rows)], Code)).


% A Query for a code block
html_write:code_query(ID, Query) --> {random_id(UID)},
    html(
        div(class('form align-items-center'), [
            div(class('input-group mb-2'), [
                div(class('input-group-prepend'), pre(class('query_prompt input-group-text'), "?-")),
                input([class([query, 'form-control', 'text-monospace']), value(Query), placeholder(Query), type(text), id(UID)]),
                div(class('input-group-append'), [
                    input([class('btn btn-warning'), style='display:none', type(button), id("clear-~q"-[UID]), value("Clear Answers"), onclick("clear_answers(~q)"-[UID])]),
                    input([class('btn btn-primary'), type(button), id("action-~q"-[UID]), data-role='query', value("Run Query"), onclick("onActionBtnClick(this, ~w, ~q)"-[ID, UID]), onkeydown("onActionBtnKeyDown(this, event, ~w, ~q)"-[ID, UID])])
                ])
            ]),
            ul([class('list-group mb-2'), style='display:none', id("results-~q"-[UID])], [
                li(class('list-group-item list-group-item-success template success d-none'), []),
                li(class('list-group-item list-group-item-warning template warning d-none'), [])
            ])
        ]
       )
    ).

% A Query without a code block
html_write:code_query(Query) --> {random_id(UID)},
    html(
        div(class('form align-items-center'), [
            div(class('input-group mb-2'), [
                div(class('input-group-prepend'), pre(class('query_prompt input-group-text'), "?-")),
                input([class([query, 'form-control', 'text-monospace']), value(Query), placeholder(Query), type(text), id(UID)]),
                div(class('input-group-append'), [
                    input([class('btn btn-warning'), style='display:none', type(button), id("clear-~q"-[UID]), value("Clear Answers"), onclick("clear_answers(~q)"-[UID])]),
                    input([class('btn btn-primary'), type(button), id("action-~q"-[UID]), data-role='query', value("Run Query"), onclick("onActionBtnClick(this, undefined, ~q)"-[UID]), onkeydown("onActionBtnKeyDown(this, event, undefined, ~q)"-[UID])])
                ])
            ]),
            ul([class('list-group mb-2'), style='display:none', id("results-~q"-[UID])], [
                li(class('list-group-item list-group-item-success template success d-none'), []),
                li(class('list-group-item list-group-item-warning template warning d-none'), [])
            ])
        ]
       )
    ).

random_id(ID) :-
     length(Codes, 12),
     maplist(random_between(97, 122), Codes),
     atom_codes(ID, Codes).
