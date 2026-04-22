<!--- Please ensure that the WIP label is not being applied if ready for review -->
<!--- If the WIP label is applied to your PR, no one will look at it -->
<!--- Please feel free to ask for help -->

## ✔️ Type of Change

- [ ] 🚀 New feature (new Terraform resource/module file, new HCL logic)
- [ ] 🐛 Bug fix (corrects an issue in module HCL, dependencies, or locals)
- [ ] ⚠️ Breaking change (modifies existing module interface or variable structure)
- [ ] 📄 Documentation update (README, examples)
- [ ] 🛠️ Refactoring / tech debt (internal improvements, no user-facing changes)
- [ ] ⚙️ Other (please describe):

## 🔗 Related Issue(s)

<!--- Link the relevant issue(s). Use "Fixes #123" to auto-close on merge. -->

## 📝 Proposed Changes

<!--- Describe what this PR does and why. -->

---

## 🧪 Testing Evidence

> **⚠️ PRs without testing evidence will not be reviewed** (unless this is a docs-only or chore-only change — check N/A below).

- [ ] N/A — this PR does not touch `.tf` files (e.g., docs-only, CI, chore)

### Terraform Validation

<!--- Confirm that the module compiles and plans correctly -->

```bash
# Paste `terraform init` + `terraform plan` or `terraform apply` output
```

- [ ] `terraform validate` passes
- [ ] `terraform plan` produces expected changes (or `terraform apply` on a test device)

---

## 🔗 Cross-Repo Links

<!--- Module PRs often depend on a provider release. Link related PRs/issues. -->

- Provider PR/release this depends on: <!-- e.g., CiscoDevNet/terraform-provider-iosxe#456 or v0.16.0 -->
- Schema PR: <!-- e.g., netascode/nac-iosxe#789 -->

## ✅ Checklist

### Pre-Submission

- [ ] I have merged/rebased from `main` and resolved all merge conflicts
- [ ] `terraform validate` passes
- [ ] Module changes have been tested with `terraform plan` or `terraform apply`

### Code Quality

- [ ] New `.tf` file(s) follow existing module patterns (`for_each`, `try()` hierarchy, `depends_on`)
- [ ] Variable references use the `local.device_config` → `local.defaults` fallback pattern
- [ ] No hardcoded values — all config comes from the YAML data model

### Labels & Assignment

- [ ] I have assigned at least one label that aligns with `release.yaml` categories: `feature`, `enhancement`, `bug`, `fix`, `breaking-change`, `documentation`, `refactor`, `tech-debt`, `chore`, or `dependencies`
- [ ] Label(s) match the linked GitHub issue label(s) where applicable
- [ ] PR is assigned to myself
- [ ] One or more reviewers are assigned
