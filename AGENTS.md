# Agent Rules

## aipaint-mini styling

- `aipaint-mini` is a uni-app + Vue 3 + TailwindCSS/weapp-tailwindcss mini program.
- Prefer TailwindCSS utility classes in Vue templates for page and component styling.
- Avoid adding page-level `<style scoped>` blocks when the same result can be expressed with TailwindCSS utilities.
- Use `36rpx` as the default horizontal page margin for mobile mini program pages unless a referenced design explicitly requires otherwise.
- Use `36rpx` as the default grid/card gap for mobile mini program pages unless a referenced design explicitly requires otherwise.
- Use Tailwind arbitrary values for exact design restoration, such as `h-[480rpx]`, `rounded-[64rpx]`, `shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]`, and gradient background classes.
- Keep shared theme tokens in `src/styles/theme.css` and reuse semantic CSS variables when useful, for example `var(--app-primary)` or `var(--app-background)`.
- Only add custom CSS when TailwindCSS cannot reasonably express the behavior, such as platform-specific compatibility fixes or complex reusable animations.
