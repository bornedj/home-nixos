# global agent instructions

- Try to not be pedantic in your outputted writing and conversations
- Avoid using litotes in your language.
- Do not use emojis in your work: code comments, markdown files, etc.
- Code comments in applications should largely only be used to describe **why**
  a decision was made. They should not be used to describe how code works or
  what it does, in these cases the code should be self documenting &mdash;
  through its variable, function, class, etc names. The main caveat to this is
  public facing or shared code, providing more thorough comments that will
  appear in someones IDE through hover/definition features is a special case.
- When writing markdown do not rely on line wrapping, use line breaks around
  the 80 column.
  > This is a personal preference. This rule only applies to markdown you
  > create. For example, you should not provide /code-review feedback that
  > markdown doesn't wrap around 80 characters unless that commit is signed
  > with my user.
- When writing markdown documentation save it under the /docs directory. The
  `docs/adrs` and `docs/designs` subdirectories are gated by CODEOWNERS where
  present. You should not be adding documents to these directories without
  being explicitly asked to.
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, testability and
  long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting
  as closely aligned with how an end user would experience it as possible. This
  makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be
  obsessed with pixel perfection. If something clearly looks off, even if it is
  not directly related to what you are doing, try to get it fixed along the
  way.
- Apply that same high standard to engineering excellence: lint, test failures,
  and test flakiness. If you see one, even if it is not caused by what you are
  working on right now, still get it fixed.

## Secrets management

I use sops-nix to manage secrets. You are never permitted to decrypt that file,
or read any environment variables set using the sops decrpyt functionality in
my nix-shells. If you need a token/secret to access something prompt me for it.
If you need to enter one of my nix development shells, prompt me for it.

## Profile

When you are working on something that would benefit from understanding who
Daniel is or what opinions he holds, see ~/.config/PROFILE.md

## Agent orchestration

Every plan-mode session should employ subagents as specified by the
~/.config/ORCHESTRATION.md. Tasks deemed simple (e.g. declarative config file
changes, writing small shell scripts, etc) can be completed without the
orchestrator pattern. Complex tasks should follow the orchestrator pattern. If
you are unsure of your classification of the complexity of a task, prompt
Daniel asking if he would like to follow the orchestration pattern.

## Programming paradigms

Daniel heavily prefers the functional programming paradigm over object oriented
programming. That said java and typescript are the primary languages. For those
languages, functional features should be used when possible &mdash; E.g.
streams over procedural, imperative loops in java; "const () => " over
"function"s in typescript. For smaller throwaway scripts and things scoped to
Daniel's machine and dev setup, he prefers haskell and rust scripting/tooling
over python/javascript.

> He prefers "fat struct" programming in certain contexts as well.
