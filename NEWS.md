# whesApp 9.0.2 _2023-04-05_

- Fix ind_052

# whesApp 9.0.1 _2023-04-05_

- Add accessibility statement

# whesApp 9.0.0 _2023-04-05_

- Data refresh for 2023

# whesApp 8.1.1 _2023-03-13_

- Increase focus border contrasts and sizes.
- fix: table column sort indicator for "value" now gets focus border.
- Swap back to `focus-visible`.

# whesApp 8.1.0 _2023-03-08_

- Change focus-visible to focus for browser compatability
- Major bump as ready for DAC

# whesApp 8.0.41 _2023-03-07_

- Fix #261: Use title in plot alt text, and present table first

# whesApp 8.0.40 _2023-03-06_

- Fix #259: Trap focus on disconnection dialog
- Fix #260: More distinctive disconnection button focus indicator.

# whesApp 8.0.39 _2023-02-28_

- Fix #258: make radiogroup manually to avoid label pointing to no input.

# whesApp 8.0.38 _2023-02-28_

- Use ellipsis for overflowing text in select menus

# whesApp 8.0.37 _2023-02-28_

- Make focus highlighting of table-sort buttons clearer

# whesApp 8.0.36 _2023-02-28_

- Remove "Opens in new window" from download button.
- Open footer URL in new tab

# whesApp 8.0.35 _2023-02-28_

- Resolve #256: Right-align value column in table.

# whesApp 8.0.34 _2023-02-28_

- Fix #252: Imports fontawesome icons.

# whesApp 8.0.33 _2023-02-28_

- Set default text-colour to #000000 to meet minimum contrast standards.

# whesApp 8.0.32 _2023-02-28_

- Resolves #251: Removes horizontal scroll from outer container.
- Allows unlimited height tables.
- Stop table header word wrapping.
- Add margin to top of output well panel on screens < `lg` size.

# whesApp 8.0.31 _2023-02-27_

- Resolve #249: Left align valuebox

# whesApp 8.0.30 _2023-02-27_

- Resolve #248: Remove aria-label from download icon

# whesApp 8.0.29 _2023-02-27_

- Resolve #181 and #231: Fix height and width of plots

# whesApp 8.0.28 _2023-02-24_

- Change language of aria-label for language switcher

# whesApp 8.0.27 _2023-02-24_

- Reduce number of allowed notes from 2 to 1.

# whesApp 8.0.26 _2023-02-24_

- Resolve #245: Switch colours to avoid accidental stereotype

# whesApp 8.0.25 _2023-02-24_

- Fixes #208, #209: Add descriptive label for download button and translations.

# whesApp 8.0.24 _2023-02-24_

- Resolve #200: Move asterisk text to table only

# whesApp 8.0.23 _2023-02-24_

- Descriptive hyperlink text in footer and an "Opens in new window" message.

# whesApp 8.0.22 _2023-02-24_

- Resolve #202: Add alt text for plots. 

# whesApp 8.0.21 _2023-02-24_

- Add translations for the disconnection warning/message.

# whesApp 8.0.20 _2023-02-24_

- Add translation for skip link

# whesApp 8.0.19 _2023-02-24_

- Resolve #247: Remove y-axis label when displaying percentage values.

# whesApp 8.0.18 _2023-02-24_

- Resolve #224 & #225: Reword and translate select labels and "Outcome". 

# whesApp 8.0.17 _2023-02-24_

- Resolve #201: Add logo alt text and make it update with language changes.

# whesApp 8.0.16 _2023-02-20_

- Replace `navbarPage()` with `fluidPage()`
- Fix #223: Provide minimum contrast on focus of download button.
- Allow width of select box to fit content or page width.
- Redesign header to be responsive for different viewport widths.

# whesApp 8.0.15 _2023-02-20_

- Resolve #244: Fix the bug caused by have `disag_choices = "None"` when
checking for number of available disags.
- Add a test to check `disag_choices = "None"` is handled correctly.

# whesApp 8.0.14 _2023-02-16_

- Resolve #222: Contrast in plots

# whesApp 8.0.13 _2023-02-09_

- Resolve #230: Content pushed down page when skiplink appears

# whesApp 8.0.12 _2023-02-08_

- Resolve #242: Contrast of buttons in timeout warning

# whesApp 8.0.11 _2023-02-08_

- Update README.md with correct deployment links

# whesApp 8.0.10 _2023-02-08_

- Fixes #240: Contrast colour for language selection radio buttons

# whesApp 8.0.9 _2023-02-08_

- Remove search indicator functionality

# whesApp 8.0.8 _2023-02-07_

- Resolves #190: Handles some issues with the disconnection dialog box
  - Resolve #191: Make timeout message more prominent, informative, and bilingual
  - Resolve #192: Redirect focus to the overlay
  - Resolve #193: Warn of imminent disconnection after 14 minutes of inactivity.

# whesApp 8.0.7 _2023-02-01_

- Fixes #206: Remove selectize and dependency on ShinyWidgets
- fix: Fix bug where changing disag input rapidly would cause
an infinite loop of input updates.

# whesApp 8.0.6 _2023-02-01_

- Resolves #227: Load plots on startup

# whesApp 8.0.5 _2023-02-01_

- Resolves #226: Bug in CY plots
- fix: New versions of {forcats} require that `...` arguments in `forcats::fct_relevel`
are specified by position rather than named.

# whesApp 8.0.4 _2023-02-01_

- Resolves #188: Add a skip link to the page.

# whesApp 8.0.3 _2023-02-01_

- Fixes #197: Input radios no longer nested inside buttons.
- Fixes #228: Focus order no longer jumps on changing this input. This is a side
effect of fixing #197.

# whesApp 8.0.2 _2023-02-01_

- Fix #194, Fix #195, Fix #196: Correct aria grouping and `aria-label` for radio
buttons that change app language.
- Move changetitle Shiny custom handler to JS file

# whesApp 8.0.1 _2023-01-31_

- Fixes #189: Set HTML language of page

# whesApp 8.0.0 _2023-01-31_

- delete all pages no longer required

# whesApp 7.0.68 _2022-07-18_

- update images
- add new resource

# whesApp 7.0.67 _2022-07-18_

- Fixes #184: Inherit position and adjust width of `div#insert_footer`.

# whesApp 7.0.66 _2022-07-15_

- Add PDFs
- Fix links 

# whesApp 7.0.65 _2022-07-15_

- Fix formatting issues in md documents
- Add empty alt text

# whesApp 7.0.64 _2022-07-15_

- Make external links in app open in new window.
- Fix needs_income//A basic income: URL in EN site goes to CY page.

# whesApp 7.0.63 _2022-07-14_

- Disable the report download button while document is generating. Fixes #182.

# whesApp 7.0.62 _2022-07-12_

- Fix typo in CY

# whesApp 7.0.61 _2022-07-11_

- Bugfix: Fix labels for ind_070

# whesApp 7.0.60 _2022-07-11_

- Bugfix: Handle second disag

# whesApp 7.0.59 _2022-07-11_

- add new translations to database

# whesApp 7.0.58 _2022-07-11_

- update report structure
- update report colours

# whesApp 7.0.57 _2022-07-11_

- update link colour
- Add footer
- Add solutions resources
- Add animation links
- Add SVDS resources

# whesApp 7.0.56 _2022-07-08_

- Fix Welsh report

# whesApp 7.0.55 _2022-07-07_

- Finalise resources pages
- Add contact us mailto links

# whesApp 7.0.54 _2022-07-06_

- Add CY resources pages

# whesApp 7.0.53 _2022-07-06_

- Fix landing page links
- Add CY Solutions pages
- Add privacy notice

# whesApp 7.0.52 _2022-07-06_

- Add Welsh overviews

# whesApp 7.0.51 _2022-07-04_

- Add Welsh landing page
- Add Welsh terms of use

# whesApp 7.0.50 _2022-07-04_

- Update metadata

# whesApp 7.0.49 _2022-07-01_

- Remove English from report
- Fix report styling

# whesApp 7.0.48 _2022-06-30_

- Add overview pages

# whesApp 7.0.47 _2022-06-29_

- Add T&Cs

# whesApp 7.0.46 _2022-06-28_

- Update content on landing page

# whesApp 7.0.45 _2022-06-27_

- Rename tabs
- Update translation db

# whesApp 7.0.44 _2022-06-27_

- Move report tab
- Add data explorer overview page

# whesApp 7.0.43 _2022-06-27_

- Add English pages content

# whesApp 7.0.42 _2022-06-14_

- switch language drop down to radio button

# whesApp 7.0.41 _2022-06-13_

- add footer

# whesApp 7.0.40 _2022-06-13_

- crop images on front page

# whesApp 7.0.39 _2022-03-31_

- Remove {emojifont} from Depends
- Add fontawesome font

# whesApp 7.0.38 _2022-03-30_

- Initially set window title as English version

# whesApp 7.0.37 _2022-03-30_

- Adds require statement to table rendering

# whesApp 7.0.36 _2022-03-30_

- Fix order of output type to not depend on order of key

# whesApp 7.0.35 _2022-03-29_

- Fix order of items in legend

# whesApp 7.0.34 _2022-03-29_

- Switch to larger colour palette for bar chart

# whesApp 7.0.33 _2022-03-29_

- Update logo sizes

# whesApp 7.0.32 _2022-03-24_

- Add dates to plot titles

# whesApp 7.0.31 _2022-03-24_

- Update translation database with professional translation

# whesApp 7.0.30 _2022-03-24_

- Data refresh

# whesApp 7.0.29 _2022-03-24_

- Don't debounce (revert 7.0.23)

# whesApp 7.0.28 _2022-03-23_

- prevent modules from loading on start up

# whesApp 7.0.27 _2022-03-23_

- Minor refactoring of a path

# whesApp 7.0.26 _2022-03-22_

- use temp dir for report

# whesApp 7.0.25 _2022-03-21_

- add report styling
- add white WHO logo

# whesApp 7.0.24 _2022-03-16_

- data refresh

# whesApp 7.0.23 _2022-03-07_

- delay plot rendering by half second

# whesApp 7.0.22 _2022-03-07_

- add percentages to facet labels

# whesApp 7.0.21 _2022-02-25_

- refactor disag update
- disable CI button based on chart type

# whesApp 7.0.20 _2022-02-11_

- add logos

# whesApp 7.0.19 _2022-02-08_

- standardise plot download sizes
- fix title wrapping issues for waffle plots

# whesApp 7.0.18 _2022-02-08_

- fix decimal in table

# whesApp 7.0.17 _2022-02-08_

- fix plot type buttons
- fix checkbox colour

# whesApp 7.0.16 _2022-02-03_

- add reporting page

# whesApp 7.0.15 _2022-02-03_

- Move title above navbar
- Fix bslib window_title warnings
- Unstick navbar for now

# whesApp 7.0.14 _2022-02-02_

- Dynamic images added in valuebox
- y-limits fixed for barcharts

# whesApp 7.0.13 _2022-01-27_

- Add dependency on {markdown}

# whesApp 7.0.12 _2022-01-25_

- Remove dependency on {janitor}

# whesApp 7.0.11 _2022-01-25_

- fix missing "search indicator" page

# whesApp 7.0.10 _2022-01-25_

- translate "No results" for pickerInput

# whesApp 7.0.9 _2022-01-25_

- fix facets in infographic

# whesApp 7.0.8 _2022-01-17_

- translate indicators and buttons
- tidy translate functions

# whesApp 7.0.7 _2022-01-14_

- add policy dropdowns
- minor UI tweaks

# whesApp 7.0.6 _2022-01-13_

- Update fonts

# whesApp 7.0.5 _2022-01-12_

- add UI updates
- redesign theme

# whesApp 7.0.4 _2022-01-10_

- Add 6 new covid indicators
- Weight covid indidcators by sample weight
- Add deprivation data for covid indicators
- Remove year from plot caption

# whesApp 7.0.3 _2022-01-05_

- Fix bar chart axes

# whesApp 7.0.2 _2021-12-22_

- Update waffle functions
- Add new value box function
- Remove dependence on waffle, hrbrthemes

# whesApp 7.0.1 _2021-12-09_

- Realign images

# whesApp 7.0.0 _2021-12-07_

- Add pm-check

# whesApp 0.1.4 _2021-11-12_

- Add pm-check

# whesApp 0.1.3 _2021-10-01_

- Update wording

# whesApp 0.1.2 _2021-10-01_

- Refactor
- Update to shiny modules
- Fix missing tables

# whesApp 0.1.1 _2021-03-31_

- Add shiny app test
- Add health economics page

# whesApp 0.1.0 _2021-03-04_

- Add a `NEWS.md` file to track changes to the package.
