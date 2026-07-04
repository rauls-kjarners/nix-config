# Gemini / Antigravity Rules

## Core operating principles

**Precedence.** When guidance conflicts, correctness and safety win over delegation/efficiency mechanics. On trivial tasks, use judgment instead of ritual.

**Never commit without permission.** NEVER run `git commit` or `git push` unless the user has explicitly requested or approved it.

## Engineering discipline

**Think before coding.** State assumptions explicitly; if uncertain, ask. If multiple interpretations exist, surface them rather than picking silently. If a simpler approach exists, say so. If something's unclear, stop and name it.

**Simplicity first.** Minimum code that solves the problem — no speculative features, no abstractions for single-use code, no error handling for impossible states. If 200 lines could be 50, rewrite. Would a senior engineer call this overcomplicated?

**Surgical changes.** Touch only what the task requires. Don't "improve" adjacent code, reformat, or refactor what isn't broken; match existing style. Remove imports/variables your own changes orphaned; leave pre-existing dead code alone (mention it, don't delete). Every changed line traces directly to the request.

**Goal-driven execution.** Turn tasks into verifiable goals ("fix the bug" → "write a failing test that reproduces it, then make it pass"). For multi-step work, state a brief plan with a verify check per step.

## JetBrains MCP — tool priority (PhpStorm, PyCharm, GoLand)

When `mcp__*__*` tools are exposed, prefer them over text/regex/shell per the rules below. Availability varies by IDE build, plugins, and `idea_mcp_allowed_tools`. **If a tool named here isn't in the current session's exposed list, say so explicitly before falling back to grep/regex.** Names below are illustrative of a PHP/Symfony server — treat unrecognized ones per that escape hatch.

1. **Semantic lookup first.** Begin any class/method/function investigation with `mcp__*__search_symbol` → `mcp__*__get_symbol_info`. Only call `mcp__*__read_file` (or `Read`) once FQN and location are known. Never start with text/regex search for identifiers. `mcp__*__read_file` supports partial reads (line/range/offset/indentation modes, `max_lines`) — read only the known location. `mcp__*__get_file_text_by_path` is the project-relative variant (truncation modes, no fine-grained range).

2. **Never text-replace identifiers.** Use `mcp__*__rename_refactoring` for any rename of a class, method, property, function, or constant. Follow with `mcp__*__search_text` to audit string literals the semantic rename misses — the **old** name in route names, DI container/service IDs, template references (Twig/Jinja), and FQNs in config. _(Some builds expose `search_text`/`search_regex` (glob `paths`, match coordinates — prefer for precision) and `search_in_files_by_text`/`search_in_files_by_regex` (dir+fileMask, `||`-marked snippets). Either satisfies the audit.)_

3. **Structural over regex for code patterns.** For syntax-shaped migrations or repeated shapes (API rewrites, signature changes, decorator wraps), use `mcp__*__search_structural`, not `mcp__*__search_regex` — it respects grammar; regex doesn't. Call `mcp__*__get_structural_patterns` first to discover valid syntax.

4. **Inspections before guessing fixes.** After editing, call `mcp__*__get_inspections` (broad) or `mcp__*__get_file_problems` (single file) on touched files. Inspections run async off the indexer — if results look empty right after a write, re-query once before treating the file as clean. Read diagnostics and patch manually with `Edit`. **Do not call `mcp__*__apply_quick_fix`** — auto-fixes can mass-rewrite imports or silently change semantics without diff preview. **Write path:** always use built-in `Edit`/`Write` so the harness tracks file state; do not switch to `mcp__*__replace_text_in_file`/`mcp__*__create_new_file` to work around inspection lag (rule 4's re-query handles it). Built-in writes land on disk immediately; MCP inspections read the in-memory model and may lag a beat via file-watch — expected.

5. **Bootstrap once per session for non-trivial edits.** Call `mcp__*__get_php_project_config` (PHP level, interpreter, extensions — the only source for remote/Docker interpreter details), `mcp__*__get_composer_dependencies`/`mcp__*__get_project_dependencies`, and `mcp__*__get_run_configurations` (`mcp__*__execute_run_configuration` runs them). Cache version, packages, and run targets mentally.

6. **Framework navigation — narrowest tool.** Prefer dedicated MCP tools over grep; for a known target use the specific lookup, not the full-list tool (token-heavy on large apps). _(PHP/Symfony examples; find your framework's equivalent in PyCharm/GoLand.)_
   - `mcp__*__locate_symfony_service` — single service (prefer over listing all)
   - `mcp__*__list_symfony_routes_url_controllers` — all routes (broad, sparingly)
   - `mcp__*__list_doctrine_entities` — entity discovery
   - `mcp__*__list_doctrine_entity_fields` — one entity's fields/columns/types/relations/enumType as CSV; prefer over reading XML mapping
   - `mcp__*__find_files_by_glob` / `mcp__*__find_files_by_name_keyword` — lightweight file discovery; prefer over shell glob/find
   - `mcp__*__list_directory_tree` — directory tree; prefer over shell `ls`/`find`

7. **Validation ladder after edits.**
   - **PHP/Python (not compiled):** `mcp__*__build_project` is an index/inspection sweep, not a compile check, and is project-wide (slow). Prefer static analysis (PHPStan/Pyright/mypy) via `mcp__*__execute_run_configuration` for cross-file type correctness.
   - **Go (compiled):** `mcp__*__build_project` _is_ a real compile check — use for cross-package build/type errors; pair with `go vet`/staticcheck.
   - **Static edit** (single file): `mcp__*__get_file_problems`/`mcp__*__get_inspections` on touched files.
   - **Cross-file edit** (rename, signature, new dependency): inspections + `mcp__*__execute_run_configuration` (Static Analysis) + `mcp__*__search_text` audit for the **old** name in string literals.
   - **Behavior change** (logic, control flow, feature): `mcp__*__execute_run_configuration` (tests). Static analysis alone is never enough.

8. **Framework component registration.** Use the framework MCP generator (e.g., `generate_symfony_service_definition`) rather than hand-writing service definitions.

9. **Debugging.** Prefer the IDE debugger over print debugging.
   - **PHP (Xdebug):** `xdebug_set_breakpoint` → `xdebug_run`/`xdebug_request` → `xdebug_eval`/`xdebug_context`/`xdebug_stack` → `xdebug_step_*` → `xdebug_stop`. For HTTP/controller behavior, `mcp__*__list_profiler_requests`.
   - **Python/Go:** native PyCharm debugger / Delve. If no `mcp__*__debug_*` tools are exposed, drive a debug run configuration — don't assume `xdebug_*` exists.

10. **Database (read-only).** Start with `mcp__*__list_database_connections` for connection IDs, then `list_database_schemas`/`list_schema_objects`/`get_database_object_description`/`preview_table_data`. `mcp__*__execute_sql_query` for read-only verification only — never writes; writes go through `make db-migrate`/fixtures.

**Avoid:** `mcp__*__reformat_file` (use `php-cs-fixer`/`gofmt`/`black` via shell — IDE reformat causes config drift); `mcp__*__execute_terminal_command` (prefer direct shell unless you need an IDE-managed container); `mcp__*__apply_quick_fix` (rule 4); `mcp__*__invoke_ide_action` (same risk class — use only for safe read-only/navigation actions; pass `filePaths` to avoid global runs).

