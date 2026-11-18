# Contributing

Contribute focused corrections, beginner explanations, tested examples,
and well-scoped infrastructure patterns. Read the code of conduct first.

## Workflow

1. Inspect the current service categories and existing modules.
2. Open an issue describing the learning objective and Azure dependencies.
3. Make a focused branch; preserve the existing GPL-3.0 license.
4. Add real Bicep with described inputs, appropriate constraints, secure
   defaults, non-secret outputs, and supported APIs.
5. Add or update the module's entry in
   `.github/scripts/generate_catalog.py`. Keep its prerequisites, costs,
   runtime limitations, and live verification expectations specific.
6. Generate synchronized README/site views and run the checks below.
7. Submit a PR identifying what was compiled and what was actually tested
   in Azure. Never claim a live test when you only built ARM JSON.

## Required validation

From the repository root, with Azure CLI/Bicep and Python 3.12 installed:

```shell
python -m pip install -r requirements.txt
python .github/scripts/generate_catalog.py
python .github/scripts/validate_bicep.py
python .github/scripts/generate_catalog.py --check
python -m mkdocs build --strict
python .github/scripts/check_site.py
```

Module READMEs and site source-view wrappers are generated from the catalog.
Edit canonical Bicep or the catalog text, not the generated copy.
CI fails on compiler/analyzer warnings, stale views, missing module coverage,
broken local links, and strict website warnings.

## Safety and quality

- Do not add secrets, private keys, real tenant/subscription IDs, or data.
- Do not deploy paid resources in routine CI.
- Do not weaken networking/authentication merely to make a demonstration easy.
- Explain what a module does not provision; include data-plane prerequisites.
- Use deterministic role-assignment names and the narrowest appropriate scope.
- Prefer local reusable modules over copied declarations.
- Include expected results, opt-in commands, cleanup, cost and security notes.
- Link Microsoft guidance; write original educational prose.
- For vulnerability reports, avoid posting exploit details or sensitive data;
  use GitHub's private security reporting where enabled.
