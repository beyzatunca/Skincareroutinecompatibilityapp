# HomeView vs Figma – Top 10 pixel differences

**Status:** All 10 fixes applied.

Based on the web implementation (SkincareRoutineCard.tsx + Home.tsx):

| # | Element | Figma (web) | Current iOS | Fix |
|---|--------|-------------|-------------|-----|
| 1 | Title ↔ subtitle spacing | `mt-1` = 4pt | 2pt | Use 4pt |
| 2 | Subtitle color | `text-gray-700` = #374151 | #6B7280 | Use #374151 |
| 3 | Action button circle | `w-16 h-16` = 64pt | 70pt | Use 64pt |
| 4 | Spacing between action buttons | `gap-6` = 24pt | 32pt | Use 24pt |
| 5 | Action button icon size | `w-6 h-6` = 24pt | 26pt | Use 24pt |
| 6 | Routine card corner radius | `rounded-2xl` = 16pt | 20pt | Use 16pt |
| 7 | Routine card internal padding | `p-5` = 20pt | 24pt | Use 20pt |
| 8 | Routine card shadow | `0 1px 3px rgba(0,0,0,0.05)` | radius 8, opacity 0.08 | y:1, blur:3, 0.05 |
| 9 | Gap between Morning/Evening cards | `gap-4` = 16pt | 20pt | Use 16pt |
| 10 | Routine card "+" button size + header↔row gap | `w-10 h-10` = 40pt, header `mb-4` = 16pt | 44pt, no explicit gap | 40pt buttons, 16pt top on plus row |

Additional: Header container `pt-12` = 48pt top (we had 56pt). Learn section `py-4` = 16pt top (we had 32pt). Content panel top radius: Figma section has no explicit radius; cards are rounded-2xl (16pt). White area top radius set to 24pt for visual balance; can be 16pt to match.
