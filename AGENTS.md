# Agent Instructions

## Overview

This repository contains a Flutter project in the `matura_pro_ai/` directory. When you modify any files in this repo, always run static analysis and the unit tests before committing your changes.

## Programmatic Checks

Run the following commands from the `matura_pro_ai` directory:

```bash
flutter pub get
flutter analyze
flutter test
```

These commands must succeed with no errors before you finalize any pull request.

## PR instructions
### Do Not Include OpenAI Conversation Links

To maintain the clarity, privacy, and integrity of this project:

- **Never include direct links to ChatGPT / OpenAI / Codex conversations** in:
  - Commit messages
  - Pull request descriptions
  - Code comments or documentation
- These links are private, non-permanent, and can reveal sensitive information.

If referencing AI-assisted work, summarize the relevant insight or decision in your own words instead.

*Example (preferred):*
> Refactored login flow based on insights from AI regarding token expiration edge cases.

*Avoid:*
> See: <https://chat.openai.com/share/xyz>...
> See: <https://chatgpt.com/codex/tasks>...

### PR Format
Title format: [<project_name>] <Title>