# Communication

Always respond in Simplified Chinese (简体中文), regardless of the input language.

Conduct your internal reasoning / chain-of-thought thinking in Simplified Chinese as well, not in English.

Keep the following in English / as-is:
- Code, commands, file paths, identifiers, and config keys
- Tool names, error messages, and log output
- Technical terms that have no common Chinese equivalent (keep the English term, optionally gloss in Chinese on first use)

Use code fences for code/commands. Be concise.

# Git workflow

Do **not** run `git commit`, `git push` (including `git push -f` / force-push), or `git reset --hard` automatically. Only make local working-tree edits (edit files, build to verify) and stage nothing unless the user explicitly asks for a commit/push/reset.

When the user asks to commit or push, do exactly that one action and stop — do not chain additional commits/pushes on your own. Wait for the next explicit instruction.
