# Maintaining this platform

## Build and validate

Use the commands in [Contributing](contributing.md). Python 3.12 and
`requirements.txt` build the website. `az bicep install` installs the current
compiler; Actions records its version. Review upstream compiler changes
when a new analyzer warning appears rather than silently suppressing it.

The compiler validator checks every numbered-category `main.bicep` and
`.bicepparam` file and stores compiled JSON in ignored `build/`.
No Azure login, cloud credentials, validate/what-if call, or resource creation
occurs in routine CI.

## Keep sources synchronized

Edit original Bicep in its category folder. The catalog generator owns the
module READMEs and website wrappers; its explicit catalog supplies service-specific
prerequisites, security/cost notes, limitations, and expected checks.
Run it after changing module inputs. `--check` rejects missing or stale
coverage. Website snippets include those READMEs and canonical sources.

Generated source views are reached through the catalog, search, and breadcrumbs;
they intentionally do not all occupy the main sidebar.

## Pages publication

`validate-and-deploy.yml` runs on PRs and pushes to `main`.
Only validated main builds deploy. Set repository **Settings > Pages > Source**
to **GitHub Actions**. The project URL, non-directory `.html` paths, and
local-link checker use `/Bicep-For-Everyone/`.

The organization avatar is checked in as `docs/assets/cloud2br-logo.png` for
reliable header/favicons without third-party image loading on every page.
Update it intentionally if organization branding changes.
The existing license is not replaced when changing the site.

## Content boundaries

Do not copy an entire third-party manual. Link current Microsoft references.
Describe implemented functionality accurately: an empty vault is not a
backup, a network pattern is not an application, and compilation is not
a deployed integration test. Live sandbox tests require explicit authorization,
budget review, data policy review, and verified cleanup.
