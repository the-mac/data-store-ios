# Contributing to The MAC

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

The following is a set of guidelines for contributing to The MAC and its packages, which are hosted in the [The MAC Organization](https://github.com/the-mac) on GitHub.
These are just guidelines, not rules, use your best judgment and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
* [Code of Conduct](#code-of-conduct)
* [The MAC and Packages](#the-mac-and-packages)

[How Can I Contribute?](#how-can-i-contribute)
* [Reporting Bugs](#reporting-bugs)
* [Suggesting Enhancements](#suggesting-enhancements)
* [Your First Code Contribution](#your-first-code-contribution)
* [Pull Requests](#pull-requests)

[Styleguides](#styleguides)
* [Git Commit Messages](#git-commit-messages)
* [CoffeeScript Styleguide](#coffeescript-styleguide)
* [Specs Styleguide](#specs-styleguide)
* [Documentation Styleguide](#documentation-styleguide)

[Additional Notes](#additional-notes)
* [Issue and Pull Request Labels](#issue-and-pull-request-labels)

## What should I know before I get started?

### Code of Conduct

This project adheres to the Contributor Covenant [code of conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code.
Please report unacceptable behavior to [the-mac@github.com](mailto:the-mac@github.com).

### The MAC and Packages

The MAC is a large open source project—it's made up of over [200 repositories](https://github.com/the-mac).
When you initially consider contributing to The MAC, you might be unsure about which of those 200 repositories implements the functionality you want to change or report a bug for.
This section should help you with that.

The MAC is intentionally very modular.
Nearly every non-editor UI element you interact with comes from a package, even fundamental things like tabs and the status-bar.
These packages are packages in the same way that packages in the [package store](https://the-mac.io/packages) are packages, with one difference: they are bundled into the [default distribution](https://github.com/the-mac/the-mac/blob/10b8de6fc499a7def9b072739486e68530d67ab4/package.json#L58).

![the-mac-packages](https://cloud.githubusercontent.com/assets/69169/10472281/84fc9792-71d3-11e5-9fd1-19da717df079.png)

To get a sense for the packages that are bundled with The MAC, you can go to Settings > Packages within The MAC and take a look at the Core Packages section.

Here's a list of the big ones:

* [the-mac/Tool-Kit](https://github.com/the-mac/Tool-Kit) - The MAC Core! The core editor component is responsible for basic text editing (e.g. cursors, selections, scrolling), text indentation, wrapping, and folding, text rendering, editor rendering, file system operations (e.g. saving), and installation and auto-updating. You should also use this repository for feedback related to the [core API](https://the-mac.io/docs/api/latest) and for large, overarching design proposals.
* [tree-view](https://github.com/the-mac/tree-view) - file and directory listing on the left of the UI.
* [fuzzy-finder](https://github.com/the-mac/fuzzy-finder) - the quick file opener.
* [find-and-replace](https://github.com/the-mac/find-and-replace) - all search and replace functionality.
* [tabs](https://github.com/the-mac/tabs) - the tabs for open editors at the top of the UI.
* [status-bar](https://github.com/the-mac/status-bar) - the status bar at the bottom of the UI.
* [markdown-preview](https://github.com/the-mac/markdown-preview) - the rendered markdown pane item.
* [settings-view](https://github.com/the-mac/settings-view) - the settings UI pane item.
* [autocomplete-plus](https://github.com/the-mac/autocomplete-plus) - autocompletions shown while typing. Some languages have additional packages for autocompletion functionality, such as [autocomplete-html](https://github.com/the-mac/autocomplete-html).
* [git-diff](https://github.com/the-mac/git-diff) - Git change indicators shown in the editor's gutter.
* [language-javascript](https://github.com/the-mac/language-javascript) - all bundled languages are packages too, and each one has a separate package `language-[name]`. Use these for feedback on syntax highlighting issues that only appear for a specific language.
* [one-dark-ui](https://github.com/the-mac/one-dark-ui) - the default UI styling for anything but the text editor. UI theme packages (i.e. packages with a `-ui` suffix) provide only styling and it's possible that a bundled package is responsible for a UI issue. There are other other bundled UI themes, such as [one-light-ui](https://github.com/the-mac/one-light-ui).
* [one-dark-syntax](https://github.com/the-mac/one-dark-syntax) - the default syntax highlighting styles applied for all languages. There are other other bundled syntax themes, such as [solarized-dark-syntax](https://github.com/the-mac/solarized-dark-syntax). You should use these packages for reporting issues that appear in many languages, but disappear if you change to another syntax theme.
* [apm](https://github.com/the-mac/apm) - the `apm` command line tool (The MAC Package Manager). You should use this repository for any contributions related to the `apm` tool and to publishing packages.
* [the-mac.io](https://github.com/the-mac/the-mac.io) - the repository for feedback on the [The MAC.io website](https://the-mac.io) and the [The MAC.io package API](https://github.com/the-mac/the-mac/blob/master/docs/apm-rest-api.md) used by [apm](https://github.com/the-mac/apm).

There are many more, but this list should be a good starting point.
For more information on how to work with The MAC's official packages, see [Contributing to The MAC Packages](https://github.com/the-mac/the-mac/blob/master/docs/contributing-to-packages.md).

Also, because The MAC is so extensible, it's possible that a feature you've become accustomed to in The MAC or an issue you're encountering aren't coming from a bundled package at all, but rather a [community package](https://the-mac.io/packages) you've installed.
Each community package has its own repository too, and you should be able to find it in Settings > Packages for the packages you installed and contribute there.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for The MAC. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). If you'd like, you can use [this template](#template-for-submitting-bug-reports) to structure the information.

#### Before Submitting A Bug Report

* **Check the [debugging guide](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/).** You might be able to find the cause of the problem and fix things yourself. Most importantly, check if you can reproduce the problem [in the latest version of The MAC](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#update-to-the-latest-version), if the problem happens when you run The MAC in [safe mode](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#check-if-the-problem-shows-up-in-safe-mode), and if you can get the desired behavior by changing [The MAC's or packages' config settings](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#check-the-mac-and-package-settings).
* **Check the [FAQs on the forum](https://discuss.the-mac.io/c/faq)** for a list of common questions and problems.
* **Determine [which repository the problem should be reported in](#the-mac-and-packages)**.
* **Perform a [cursory search](https://github.com/issues?q=+is%3Aissue+user%3Athe-mac)** to see if the problem has already been reported. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined [which repository](#the-mac-and-packages) your bug is related to, create an issue on that repository and provide the following information.

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible. For example, start by explaining how you started The MAC, e.g. which command exactly you used in the terminal, or how you started The MAC otherwise. When listing steps, **don't just say what you did, but explain how you did it**. For example, if you moved the cursor to the end of a line, explain if you used the mouse, or a keyboard shortcut or an The MAC command, and if so which one?
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. If you use the keyboard while following the steps, **record the GIF with the [Keybinding Resolver](https://github.com/the-mac/keybinding-resolver) shown**. You can use [this tool](http://www.cockos.com/licecap/) to record GIFs on OSX and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **If you're reporting that The MAC crashed**, include a crash report with a stack trace from the operating system. On OSX, the crash report will be available in `Console.app` under "Diagnostic and usage information" > "User diagnostic reports". Include the crash report in the issue in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines), a [file attachment](https://help.github.com/articles/file-attachments-on-issues-and-pull-requests/), or put it in a [gist](https://gist.github.com/) and provide link to that gist.
* **If the problem is related to performance**, include a [CPU profile capture and a screenshot](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#diagnose-performance-problems-with-the-dev-tools-cpu-profiler) with your report.
* **If the Chrome's developer tools pane is shown without you triggering it**, that normally means that an exception was thrown. The Console tab will include an entry for the exception. Expand the exception so that the stack trace is visible, and provide the full exception and stack trace in a [code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines) and as a screenshot.
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* **Can you reproduce the problem in [safe mode](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#diagnose-runtime-performance-problems-with-the-dev-tools-cpu-profiler)?**
* **Did the problem start happening recently** (e.g. after updating to a new version of The MAC) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of The MAC?** What's the most recent version in which the problem doesn't happen? You can download older versions of The MAC from [the releases page](https://github.com/the-mac/the-mac/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.
* If the problem is related to working with files (e.g. opening and editing files), **does the problem happen for all files and projects or only some?** Does the problem happen only when working with local or remote files (e.g. on network drives), with files of a specific type (e.g. only JavaScript or Python files), with large files or files with very long lines, or with files in a specific encoding? Is there anything else special about the files you are using?

Include details about your configuration and environment:

* **Which version of The MAC are you using?** You can get the exact version by running `the-mac -v` in your terminal, or by starting The MAC and running the `Application: About` command from the [Command Palette](https://github.com/the-mac/command-palette).
* **What's the name and version of the OS you're using**?
* **Are you running The MAC in a virtual machine?** If so, which VM software are you using and which operating systems and versions are used for the host and the guest?
* **Which [packages](#the-mac-and-packages) do you have installed?** You can get that list by running `apm list --installed`.
* **Are you using [local configuration files](http://flight-manual.the-mac.io/using-the-mac/sections/basic-customization/)** `config.cson`, `keymap.cson`, `snippets.cson`, `styles.less` and `init.coffee` to customize The MAC? If so, provide the contents of those files, preferably in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines) or with a link to a [gist](https://gist.github.com/).
* **Are you using The MAC with multiple monitors?** If so, can you reproduce the problem when you use a single monitor?
* **Which keyboard layout are you using?** Are you using a US layout or some other layout?

#### Template For Submitting Bug Reports

[Short description of problem here]

**Reproduction Steps:**

1. [First Step]
2. [Second Step]
3. [Other Steps...]

**Expected behavior:**

[Describe expected behavior here]

**Observed behavior:**

[Describe observed behavior here]

**Screenshots and GIFs**

![Screenshots and GIFs which follow reproduction steps to demonstrate the problem](url)

**The MAC version:** [Enter The MAC version here]
**OS and version:** [Enter OS name and version here]

**Installed packages:**

[List of installed packages here]

**Additional information:**

* Problem can be reproduced in safe mode: [Yes/No]
* Problem started happening recently, didn't happen in an older version of The MAC: [Yes/No]
* Problem can be reliably reproduced, doesn't happen randomly: [Yes/No]
* Problem happens with all files and projects, not only some files or projects: [Yes/No]

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for The MAC, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). If you'd like, you can use [this template](#template-for-submitting-enhancement-suggestions) to structure the information.

#### Before Submitting An Enhancement Suggestion

* **Check the [debugging guide](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/)** for tips — you might discover that the enhancement is already available. Most importantly, check if you're using [the latest version of The MAC](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#update-to-the-latest-version) and if you can get the desired behavior by changing [The MAC's or packages' config settings](http://flight-manual.the-mac.io/hacking-the-mac/sections/debugging/#check-the-mac-and-package-settings).
* **Check if there's already [a package](https://the-mac.io/packages) which provides that enhancement.**
* **Determine [which repository the enhancement should be suggested in](#the-mac-and-packages).**
* **Perform a [cursory search](https://github.com/issues?q=+is%3Aissue+user%3Athe-mac)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined [which repository](#the-mac-and-packages) your enhancement suggestions is related to, create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of The MAC which the suggestion is related to. You can use [this tool](http://www.cockos.com/licecap/) to record GIFs on OSX and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful** to most The MAC users and isn't something that can or should be implemented as a [community package](#the-mac-and-packages).
* **List some other text editors or applications where this enhancement exists.**
* **Specify which version of The MAC you're using.** You can get the exact version by running `the-mac -v` in your terminal, or by starting The MAC and running the `Application: About` command from the [Command Palette](https://github.com/the-mac/command-palette).
* **Specify the name and version of the OS you're using.**

#### Template For Submitting Enhancement Suggestions

[Short description of suggestion]

**Steps which explain the enhancement**

1. [First Step]
2. [Second Step]
3. [Other Steps...]

**Current and suggested behavior**

[Describe current and suggested behavior here]

**Why would the enhancement be useful to most users**

[Explain why the enhancement would be useful to most users]

[List some other text editors or applications where this enhancement exists]

**Screenshots and GIFs**

![Screenshots and GIFs which demonstrate the steps or part of The MAC the enhancement suggestion is related to](url)

**The MAC Version:** [Enter The MAC version here]
**OS and Version:** [Enter OS name and version here]

### Your First Code Contribution

Unsure where to begin contributing to The MAC? You can start by looking through these `beginner` and `help-wanted` issues:

* [Beginner issues][beginner] - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues][help-wanted] - issues which should be a bit more involved than `beginner` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

### Pull Requests

* Include screenshots and animated GIFs in your pull request whenever possible.
* Follow the [CoffeeScript](#coffeescript-styleguide),
[JavaScript](https://github.com/styleguide/javascript),
and [CSS](https://github.com/styleguide/css) styleguides.
* Include thoughtfully-worded, well-structured
[Jasmine](http://jasmine.github.io/) specs in the `./spec` folder. Run them using `apm test`. See the [Specs Styleguide](#specs-styleguide) below.
* Document new code based on the
[Documentation Styleguide](#documentation-styleguide)
* End files with a newline.
* Place requires in the following order:
* Built in Node Modules (such as `path`)
* Built in The MAC and The MAC Shell Modules (such as `the-mac`, `shell`)
* Local Modules (using relative paths)
* Place class properties in the following order:
* Class methods and properties (methods starting with a `@`)
* Instance methods and properties
* Avoid platform-dependent code:
* Use `require('fs-plus').getHomeDirectory()` to get the home directory.
* Use `path.join()` to concatenate filenames.
* Use `os.tmpdir()` rather than `/tmp` when you need to reference the
temporary directory.
* Using a plain `return` when returning explicitly at the end of a function.
* Not `return null`, `return undefined`, `null`, or `undefined`

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally
* When only changing documentation, include `[ci skip]` in the commit description
* Consider starting the commit message with an applicable emoji:
* :art: `:art:` when improving the format/structure of the code
* :racehorse: `:racehorse:` when improving performance
* :non-potable_water: `:non-potable_water:` when plugging memory leaks
* :memo: `:memo:` when writing docs
* :penguin: `:penguin:` when fixing something on Linux
* :apple: `:apple:` when fixing something on Mac OS
* :checkered_flag: `:checkered_flag:` when fixing something on Windows
* :bug: `:bug:` when fixing a bug
* :fire: `:fire:` when removing code or files
* :green_heart: `:green_heart:` when fixing the CI build
* :white_check_mark: `:white_check_mark:` when adding tests
* :lock: `:lock:` when dealing with security
* :arrow_up: `:arrow_up:` when upgrading dependencies
* :arrow_down: `:arrow_down:` when downgrading dependencies
* :shirt: `:shirt:` when removing linter warnings

### CoffeeScript Styleguide

* Set parameter defaults without spaces around the equal sign
* `clear = (count=1) ->` instead of `clear = (count = 1) ->`
* Use spaces around operators
* `count + 1` instead of `count+1`
* Use spaces after commas (unless separated by newlines)
* Use parentheses if it improves code clarity.
* Prefer alphabetic keywords to symbolic keywords:
* `a is b` instead of `a == b`
* Avoid spaces inside the curly-braces of hash literals:
* `{a: 1, b: 2}` instead of `{ a: 1, b: 2 }`
* Include a single line of whitespace between methods.
* Capitalize initialisms and acronyms in names, except for the first word, which
should be lower-case:
* `getURI` instead of `getUri`
* `uriToOpen` instead of `URIToOpen`
* Use `slice()` to copy an array
* Add an explicit `return` when your function ends with a `for`/`while` loop and
you don't want it to return a collected array.
* Use `this` instead of a standalone `@`
* `return this` instead of `return @`

### Specs Styleguide

- Include thoughtfully-worded, well-structured
[Jasmine](http://jasmine.github.io/) specs in the `./spec` folder.
- treat `describe` as a noun or situation.
- treat `it` as a statement about state or how an operation changes state.

#### Example

```coffee
describe 'a dog', ->
it 'barks', ->
# spec here
describe 'when the dog is happy', ->
it 'wags its tail', ->
# spec here
```

### Documentation Styleguide

* Use [The MACDoc](https://github.com/the-mac/the-macdoc).
* Use [Markdown](https://daringfireball.net/projects/markdown).
* Reference methods and classes in markdown with the custom `{}` notation:
* Reference classes with `{ClassName}`
* Reference instance methods with `{ClassName::methodName}`
* Reference class methods with `{ClassName.methodName}`

#### Example

```coffee
# Public: Disable the package with the given name.
#
# * `name`    The {String} name of the package to disable.
# * `options` (optional) The {Object} with disable options (default: {}):
#   * `trackTime`     A {Boolean}, `true` to track the amount of time taken.
#   * `ignoreErrors`  A {Boolean}, `true` to catch and ignore errors thrown.
# * `callback` The {Function} to call after the package has been disabled.
#
# Returns `undefined`.
disablePackage: (name, options, callback) ->
```

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests. Most labels are used across all The MAC repositories, but some are specific to `the-mac/the-mac`.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in. For example, you might be interested in [open issues across `the-mac/the-mac` and all The MAC-owned packages which are labeled as bugs, but still need to be reliably reproduced](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Abug+label%3Aneeds-reproduction) or perhaps [open pull requests in `the-mac/the-mac` which haven't been reviewed yet](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+comments%3A0). To help you find issues and pull requests, each label is listed with search links for finding open items with that label in `the-mac/the-mac` only and also across all The MAC repositories. We  encourage you to read about [other search filters](https://help.github.com/articles/searching-issues/) which will help you write more focused queries.

The labels are loosely grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Please open an issue on `the-mac/the-mac` if you have suggestions for new labels, and if you notice some labels are missing on some repositories, then please open an issue on that repository.

#### Type of Issue and Issue State

| Label name | `the-mac/the-mac` :mag_right: | `the-mac`‑org :mag_right: | Description |
| --- | --- | --- | --- |
| `enhancement` | [search][search-the-mac-repo-label-enhancement] | [search][search-the-mac-org-label-enhancement] | Feature requests. |
| `bug` | [search][search-the-mac-repo-label-bug] | [search][search-the-mac-org-label-bug] | Confirmed bugs or reports that are very likely to be bugs. |
| `question` | [search][search-the-mac-repo-label-question] | [search][search-the-mac-org-label-question] | Questions more than bug reports or feature requests (e.g. how do I do X). |
| `feedback` | [search][search-the-mac-repo-label-feedback] | [search][search-the-mac-org-label-feedback] | General feedback more than bug reports or feature requests. |
| `help-wanted` | [search][search-the-mac-repo-label-help-wanted] | [search][search-the-mac-org-label-help-wanted] | The The MAC core team would appreciate help from the community in resolving these issues. |
| `beginner` | [search][search-the-mac-repo-label-beginner] | [search][search-the-mac-org-label-beginner] | Less complex issues which would be good first issues to work on for users who want to contribute to The MAC. |
| `more-information-needed` | [search][search-the-mac-repo-label-more-information-needed] | [search][search-the-mac-org-label-more-information-needed] | More information needs to be collected about these problems or feature requests (e.g. steps to reproduce). |
| `needs-reproduction` | [search][search-the-mac-repo-label-needs-reproduction] | [search][search-the-mac-org-label-needs-reproduction] | Likely bugs, but haven't been reliably reproduced. |
| `blocked` | [search][search-the-mac-repo-label-blocked] | [search][search-the-mac-org-label-blocked] | Issues blocked on other issues. |
| `duplicate` | [search][search-the-mac-repo-label-duplicate] | [search][search-the-mac-org-label-duplicate] | Issues which are duplicates of other issues, i.e. they have been reported before. |
| `wontfix` | [search][search-the-mac-repo-label-wontfix] | [search][search-the-mac-org-label-wontfix] | The The MAC core team has decided not to fix these issues for now, either because they're working as intended or for some other reason. |
| `invalid` | [search][search-the-mac-repo-label-invalid] | [search][search-the-mac-org-label-invalid] | Issues which aren't valid (e.g. user errors). |
| `package-idea` | [search][search-the-mac-repo-label-package-idea] | [search][search-the-mac-org-label-package-idea] | Feature request which might be good candidates for new packages, instead of extending The MAC or core The MAC packages. |
| `wrong-repo` | [search][search-the-mac-repo-label-wrong-repo] | [search][search-the-mac-org-label-wrong-repo] | Issues reported on the wrong repository (e.g. a bug related to the [Settings View package](https://github.com/the-mac/settings-view) was reported on [The MAC core](https://github.com/the-mac/the-mac)). |

#### Topic Categories

| Label name | `the-mac/the-mac` :mag_right: | `the-mac`‑org :mag_right: | Description |
| --- | --- | --- | --- |
| `windows` | [search][search-the-mac-repo-label-windows] | [search][search-the-mac-org-label-windows] | Related to The MAC running on Windows. |
| `linux` | [search][search-the-mac-repo-label-linux] | [search][search-the-mac-org-label-linux] | Related to The MAC running on Linux. |
| `mac` | [search][search-the-mac-repo-label-mac] | [search][search-the-mac-org-label-mac] | Related to The MAC running on OSX. |
| `documentation` | [search][search-the-mac-repo-label-documentation] | [search][search-the-mac-org-label-documentation] | Related to any type of documentation (e.g. [API documentation](https://the-mac.io/docs/api/latest/) and the [flight manual](http://flight-manual.the-mac.io/)). |
| `performance` | [search][search-the-mac-repo-label-performance] | [search][search-the-mac-org-label-performance] | Related to performance. |
| `security` | [search][search-the-mac-repo-label-security] | [search][search-the-mac-org-label-security] | Related to security. |
| `ui` | [search][search-the-mac-repo-label-ui] | [search][search-the-mac-org-label-ui] | Related to visual design. |
| `api` | [search][search-the-mac-repo-label-api] | [search][search-the-mac-org-label-api] | Related to The MAC's public APIs. |
| `uncaught-exception` | [search][search-the-mac-repo-label-uncaught-exception] | [search][search-the-mac-org-label-uncaught-exception] | Issues about uncaught exceptions, normally created from the [Notifications package](https://github.com/the-mac/notifications). |
| `crash` | [search][search-the-mac-repo-label-crash] | [search][search-the-mac-org-label-crash] | Reports of The MAC completely crashing. |
| `auto-indent` | [search][search-the-mac-repo-label-auto-indent] | [search][search-the-mac-org-label-auto-indent] | Related to auto-indenting text. |
| `encoding` | [search][search-the-mac-repo-label-encoding] | [search][search-the-mac-org-label-encoding] | Related to character encoding. |
| `network` | [search][search-the-mac-repo-label-network] | [search][search-the-mac-org-label-network] | Related to network problems or working with remote files (e.g. on network drives). |
| `git` | [search][search-the-mac-repo-label-git] | [search][search-the-mac-org-label-git] | Related to Git functionality (e.g. problems with gitignore files or with showing the correct file status). |

#### `the-mac/the-mac` Topic Categories

| Label name | `the-mac/the-mac` :mag_right: | `the-mac`‑org :mag_right: | Description |
| --- | --- | --- | --- |
| `editor-rendering` | [search][search-the-mac-repo-label-editor-rendering] | [search][search-the-mac-org-label-editor-rendering] | Related to language-independent aspects of rendering text (e.g. scrolling, soft wrap, and font rendering). |
| `build-error` | [search][search-the-mac-repo-label-build-error] | [search][search-the-mac-org-label-build-error] | Related to problems with building The MAC from source. |
| `error-from-pathwatcher` | [search][search-the-mac-repo-label-error-from-pathwatcher] | [search][search-the-mac-org-label-error-from-pathwatcher] | Related to errors thrown by the [pathwatcher library](https://github.com/the-mac/node-pathwatcher). |
| `error-from-save` | [search][search-the-mac-repo-label-error-from-save] | [search][search-the-mac-org-label-error-from-save] | Related to errors thrown when saving files. |
| `error-from-open` | [search][search-the-mac-repo-label-error-from-open] | [search][search-the-mac-org-label-error-from-open] | Related to errors thrown when opening files. |
| `installer` | [search][search-the-mac-repo-label-installer] | [search][search-the-mac-org-label-installer] | Related to the The MAC installers for different OSes. |
| `auto-updater` | [search][search-the-mac-repo-label-auto-updater] | [search][search-the-mac-org-label-auto-updater] | Related to the auto-updater for different OSes. |
| `deprecation-help` | [search][search-the-mac-repo-label-deprecation-help] | [search][search-the-mac-org-label-deprecation-help] | Issues for helping package authors remove usage of deprecated APIs in packages. |
| `electron` | [search][search-the-mac-repo-label-electron] | [search][search-the-mac-org-label-electron] | Issues that require changes to [Electron](https://electron.the-mac.io) to fix or implement. |

#### Core Team Project Management

| Label name | `the-mac/the-mac` :mag_right: | `the-mac`‑org :mag_right: | Description |
| --- | --- | --- | --- |
| `the-mac` | [search][search-the-mac-repo-label-the-mac] | [search][search-the-mac-org-label-the-mac] | Topics discussed for prioritization at the next meeting of The MAC core team members. |

#### Pull Request Labels

| Label name | `the-mac/the-mac` :mag_right: | `the-mac`‑org :mag_right: | Description
| --- | --- | --- | --- |
| `work-in-progress` | [search][search-the-mac-repo-label-work-in-progress] | [search][search-the-mac-org-label-work-in-progress] | Pull requests which are still being worked on, more changes will follow. |
| `needs-review` | [search][search-the-mac-repo-label-needs-review] | [search][search-the-mac-org-label-needs-review] | Pull requests which need code review, and approval from maintainers or The MAC core team. |
| `under-review` | [search][search-the-mac-repo-label-under-review] | [search][search-the-mac-org-label-under-review] | Pull requests being reviewed by maintainers or The MAC core team. |
| `requires-changes` | [search][search-the-mac-repo-label-requires-changes] | [search][search-the-mac-org-label-requires-changes] | Pull requests which need to be updated based on review comments and then reviewed again. |
| `needs-testing` | [search][search-the-mac-repo-label-needs-testing] | [search][search-the-mac-org-label-needs-testing] | Pull requests which need manual testing. |

[search-the-mac-repo-label-enhancement]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aenhancement
[search-the-mac-org-label-enhancement]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aenhancement
[search-the-mac-repo-label-bug]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Abug
[search-the-mac-org-label-bug]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Abug
[search-the-mac-repo-label-question]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aquestion
[search-the-mac-org-label-question]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aquestion
[search-the-mac-repo-label-feedback]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Afeedback
[search-the-mac-org-label-feedback]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Afeedback
[search-the-mac-repo-label-help-wanted]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Ahelp-wanted
[search-the-mac-org-label-help-wanted]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Ahelp-wanted
[search-the-mac-repo-label-beginner]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Abeginner
[search-the-mac-org-label-beginner]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Abeginner
[search-the-mac-repo-label-more-information-needed]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Amore-information-needed
[search-the-mac-org-label-more-information-needed]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Amore-information-needed
[search-the-mac-repo-label-needs-reproduction]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aneeds-reproduction
[search-the-mac-org-label-needs-reproduction]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aneeds-reproduction
[search-the-mac-repo-label-triage-help-needed]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Atriage-help-needed
[search-the-mac-org-label-triage-help-needed]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Atriage-help-needed
[search-the-mac-repo-label-windows]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Awindows
[search-the-mac-org-label-windows]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Awindows
[search-the-mac-repo-label-linux]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Alinux
[search-the-mac-org-label-linux]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Alinux
[search-the-mac-repo-label-mac]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Amac
[search-the-mac-org-label-mac]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Amac
[search-the-mac-repo-label-documentation]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Adocumentation
[search-the-mac-org-label-documentation]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Adocumentation
[search-the-mac-repo-label-performance]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aperformance
[search-the-mac-org-label-performance]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aperformance
[search-the-mac-repo-label-security]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Asecurity
[search-the-mac-org-label-security]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Asecurity
[search-the-mac-repo-label-ui]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aui
[search-the-mac-org-label-ui]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aui
[search-the-mac-repo-label-api]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aapi
[search-the-mac-org-label-api]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aapi
[search-the-mac-repo-label-crash]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Acrash
[search-the-mac-org-label-crash]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Acrash
[search-the-mac-repo-label-auto-indent]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aauto-indent
[search-the-mac-org-label-auto-indent]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aauto-indent
[search-the-mac-repo-label-encoding]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aencoding
[search-the-mac-org-label-encoding]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aencoding
[search-the-mac-repo-label-network]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Anetwork
[search-the-mac-org-label-network]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Anetwork
[search-the-mac-repo-label-uncaught-exception]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Auncaught-exception
[search-the-mac-org-label-uncaught-exception]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Auncaught-exception
[search-the-mac-repo-label-git]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Agit
[search-the-mac-org-label-git]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Agit
[search-the-mac-repo-label-blocked]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Ablocked
[search-the-mac-org-label-blocked]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Ablocked
[search-the-mac-repo-label-duplicate]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aduplicate
[search-the-mac-org-label-duplicate]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aduplicate
[search-the-mac-repo-label-wontfix]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Awontfix
[search-the-mac-org-label-wontfix]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Awontfix
[search-the-mac-repo-label-invalid]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Ainvalid
[search-the-mac-org-label-invalid]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Ainvalid
[search-the-mac-repo-label-package-idea]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Apackage-idea
[search-the-mac-org-label-package-idea]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Apackage-idea
[search-the-mac-repo-label-wrong-repo]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Awrong-repo
[search-the-mac-org-label-wrong-repo]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Awrong-repo
[search-the-mac-repo-label-editor-rendering]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aeditor-rendering
[search-the-mac-org-label-editor-rendering]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aeditor-rendering
[search-the-mac-repo-label-build-error]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Abuild-error
[search-the-mac-org-label-build-error]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Abuild-error
[search-the-mac-repo-label-error-from-pathwatcher]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aerror-from-pathwatcher
[search-the-mac-org-label-error-from-pathwatcher]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aerror-from-pathwatcher
[search-the-mac-repo-label-error-from-save]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aerror-from-save
[search-the-mac-org-label-error-from-save]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aerror-from-save
[search-the-mac-repo-label-error-from-open]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aerror-from-open
[search-the-mac-org-label-error-from-open]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aerror-from-open
[search-the-mac-repo-label-installer]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Ainstaller
[search-the-mac-org-label-installer]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Ainstaller
[search-the-mac-repo-label-auto-updater]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Aauto-updater
[search-the-mac-org-label-auto-updater]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aauto-updater
[search-the-mac-repo-label-deprecation-help]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Adeprecation-help
[search-the-mac-org-label-deprecation-help]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Adeprecation-help
[search-the-mac-repo-label-electron]: https://github.com/issues?q=is%3Aissue+repo%3Athe-mac%2Fthe-mac+is%3Aopen+label%3Aelectron
[search-the-mac-org-label-electron]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Aelectron
[search-the-mac-repo-label-the-mac]: https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3Athe-mac%2Fthe-mac+label%3Athe-mac
[search-the-mac-org-label-the-mac]: https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Athe-mac+label%3Athe-mac
[search-the-mac-repo-label-work-in-progress]: https://github.com/pulls?q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+label%3Awork-in-progress
[search-the-mac-org-label-work-in-progress]: https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Athe-mac+label%3Awork-in-progress
[search-the-mac-repo-label-needs-review]: https://github.com/pulls?q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+label%3Aneeds-review
[search-the-mac-org-label-needs-review]: https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Athe-mac+label%3Aneeds-review
[search-the-mac-repo-label-under-review]: https://github.com/pulls?q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+label%3Aunder-review
[search-the-mac-org-label-under-review]: https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Athe-mac+label%3Aunder-review
[search-the-mac-repo-label-requires-changes]: https://github.com/pulls?q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+label%3Arequires-changes
[search-the-mac-org-label-requires-changes]: https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Athe-mac+label%3Arequires-changes
[search-the-mac-repo-label-needs-testing]: https://github.com/pulls?q=is%3Aopen+is%3Apr+repo%3Athe-mac%2Fthe-mac+label%3Aneeds-testing
[search-the-mac-org-label-needs-testing]: https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Athe-mac+label%3Aneeds-testing

[beginner]:https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+label%3Abeginner+label%3Ahelp-wanted+user%3Athe-mac+sort%3Acomments-desc
[help-wanted]:https://github.com/issues?q=is%3Aopen+is%3Aissue+label%3Ahelp-wanted+user%3Athe-mac+sort%3Acomments-desc