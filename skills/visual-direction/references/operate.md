# Operate

The visitor came to get work done, often every day. The screen is a working product of its category before it is anything else, and the direction works for it. A regular user of similar tools finds their way at once; the style is something they notice later, if at all.

## What the direction may and may not touch

- Its reach stops at type, palette, density and one signature detail, such as a delivery queue laid out like a dispatch board or stock levels drawn as shelf rows. Name that detail concretely in the contract.
- Layout, navigation and controls stay out of its hands. Buttons, tabs, inputs, selects, filters and tables are the standard ones of the platform, the ones the user already knows.
- Imitating a tool the audience already handles (a terminal, a cockpit, a control panel) turns a working screen into fancy dress. Borrow from it only the type, palette, density and the one detail.

## The screen

Plan the first screen as a map of regions: how the user moves around, what each work area does, which data they look at first and how it looks while loading or empty. Then place the signature detail.

- **No hero,** no marketing text, no mosaic of cards. The page opens on the work.
- **Navigation:** a top bar by default. Use a sidebar only once there are more than about seven places to go, and fold it into a menu on narrow screens.
- **Tables before cards** for anything people compare, sort or scan. Cards suit items that each have their own actions, or that differ in kind from their neighbours.
- **Filters, tabs and pagination live in the URL,** so a view can be shared and survives a reload.
- **A destructive action** is undone, or confirmed in words that name what will be lost. Prefer editing in place or expanding a row; open a modal only when neither works.
- **Metrics** show the value and what it measures. Decoration around them (icon badges, gradients, up or down arrows with no measured change behind them) goes.
- **Motion reports state** (opening, saving, selecting), never decoration. `devorb:motion` decides how.
- **No standout component** from the owner's list: a system's identity lives in its details.

## Colour

Restraint wins here. Spend the accent on what the user can act on or has selected, on status (error, warning, success) and on the one data series a chart is about. The shell (sidebar, toolbar, panels) sits on a slightly different neutral from the work area. Status colours appear only where they mean something. A screen that is grey everywhere except one accent is still the category default unless the type, density and signature detail make it this product's own.

## States are the design

Every region that loads, submits or depends on access gets its row in the contract's state table. Loading holds the layout steady so nothing jumps when data lands. Empty explains what will appear here and offers the action that creates the first item. An error says what broke, keeps what the user typed, and says what to do. Partly loaded shows what arrived and marks what did not. No permission says where the boundary is and how to ask. Designing only the screen full of data leaves most of the user's real moments undesigned.

## Sample data in a mock

When the screen is built before real data exists, the sample must look like real use: varied values (not 100, 200, 300), plausible units, uneven dates and names that are clearly examples (`exemplo.com`, "Cliente Exemplo"). Never a figure that a visitor could take as a claim, and never the same few placeholder people.

## Existing systems

On a project with an identity, the screen extends it: its components, tokens and patterns first. A new pattern enters only when nothing existing does the job, and the contract says so.
