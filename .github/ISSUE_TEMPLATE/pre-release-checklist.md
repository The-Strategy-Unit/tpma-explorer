---
name: Pre-release checklist
about: Checks required prior to a new release of the app
title: Pre-release checklist (vX.Y.Z)
labels: 'priority: must, qa'
assignees: ''

---

The items here may not be necesary for every release. Some releases may require more checks, depending on new features or underlying changes to data.

Regarding app interactivity:

- [ ] App loads successfully on the 'Visualisation' page.
- [ ] Selecting different geographies from the dropdown works (the statistical-units dropdown updates and plots re-render with corresponding data).
- [ ] Selecting different units from the dropdown works (plots re-render with corresponding data).
- [ ] Selecting different activity-types from the dropdown works (the TPMA dropdown updates and plots re-render with corresponding data).
- [ ] Selecting different TPMAs from the dropdown works (plots re-render with corresponding data).
- [ ] All cards in the 'Visualisation' section (description, rates trend, rates funnel, rates box, diagnoses summary, procedures summary, age-sex pyramid and NEE estimate) populate with the expected content (charts, tables or text, or fall back to a text warning that data is unavailable).
- [ ] All the cards with an 'expand' button (charts and tables) can be expanded.
- [ ] The 'Information' tab loads with expected cards (purpose, data, definitions, navigation, interface, author) and content.
- [ ] Bookmarking works with arbitrary selections from all dropdowns (clicking the button serves a URL and using that URL returns you to the bookmarked state).
- [ ] All tooltips work as expected on hover and contain the appropriate content.
- [ ] Interactive resizing elements (sidebar collapse, accordion collapse, sidebar handle) all work as expected.
- [ ] The 'Give feedback' link opens a new tab with the expected feedback form.
- [ ] The log does not register any errors or warnings during use.

Regarding data:

- [ ] For a given trust, the presentation of their data in the app matches what we show in the NHP outputs app.
- [ ] For a given LA, the data in the app matches what can be wrangled from the inputs data.

This should be run for a few 'live' trusts/LAs at minimum and should include a selection of TPMAs across activity types.
