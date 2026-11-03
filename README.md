# Hardik | Flutter Developer

```text
portfolio/
├── lib/
│   ├── main.dart
│   ├── models/project.dart
│   ├── screens/portfolio_screen.dart
│   ├── sections/
│   │   ├── hero_section.dart
│   │   ├── content_sections.dart
│   │   └── contact_section.dart
│   ├── widgets/
│   │   ├── shared.dart
│   │   └── project_card.dart
│   ├── utils/
│   │   ├── portfolio_data.dart
│   │   ├── download.dart
│   │   ├── download_stub.dart
│   │   └── download_web.dart
│   └── theme/app_theme.dart
├── assets/fonts/
│   ├── Inter.ttf
│   └── OFL.txt
├── web/
│   ├── index.html
│   ├── manifest.json
│   ├── favicon.svg
│   └── Hardik_resume.pdf
├── test/widget_test.dart
├── pubspec.yaml
├── pubspec.lock
├── firebase.json
├── SOURCE_CODE.md
└── README.md
```

Complete runnable code is in the files above. SOURCE_CODE.md also presents the folder structure first and the full text of every application/configuration file afterward. Existing generated native platform folders are retained.

## Run

Requires Flutter stable with Dart 3.12.2 or newer. Implemented using installed Flutter 3.44.2 stable / Dart 3.12.2. To update your SDK separately, run `flutter channel stable` and `flutter upgrade`.

```sh
flutter pub get
flutter run -d chrome
```

## Customize

- Edit `lib/utils/portfolio_data.dart` for name, bio, skills, roles, project URLs and contacts. Personal content is based on the supplied Hardik_resume.pdf. Team Pulse links to https://team-pulse-23aee.web.app/ through its Visit live app action. Blocktopus links to its Google Play listing and uses a locally bundled store screenshot and app icon. NovaStrike also links to its Google Play listing with its store screenshot and app icon. Both games use Get on Google Play actions.
- Edit the timeline in `PortfolioData.timeline`. Counters reflect three featured projects, two professional roles, and two degrees.
- Your supplied portrait is bundled at `assets/images/hardik.jpg` and displayed in the About section with a responsive cover crop. Replace this asset to change the photo.
- The Download CV button downloads the supplied `web/Hardik_resume.pdf`. The shared filename is configured in `PortfolioData.cvFile`.
- Update titles in `main.dart`, `web/index.html`, `web/manifest.json`, the favicon and intro initials.
- Change colors/spacing in `lib/theme/app_theme.dart`. Dark background #080D1B, cyan #53F5FF, violet #B69CFF; locally bundled Inter with its OFL license.

Shared application state uses `flutter_riverpod` with `ProviderScope`, `NotifierProvider`, and selective consumers; no account, backend, API keys or external image assets are required. The contact form validates locally and opens an email draft; visitors must send it in their email app. It does not claim to deliver mail from a server.

The layout uses LayoutBuilder: mobile <600, tablet 600–1024, desktop >1024. Internal compositions also adapt to the width available within those layouts. The navigation uses a drawer at tablet and mobile widths. The desktop cursor ring is decorative and never intercepts input. Motion respects reduced-motion settings for hero movement, counters and scroll, with subtle remaining hover/reveal transitions.

## Verify and build

```sh
flutter analyze
flutter test
flutter build web --release
```

Current Flutter builds use CanvasKit by default; the old `--web-renderer canvaskit` option is absent from this installed stable CLI. Use `flutter build web --release` for the CanvasKit build. Optionally use `flutter build web --wasm` for supported browsers with JavaScript fallback. See [Flutter web renderers](https://docs.flutter.dev/platform-integration/web/renderers) and [web deployment](https://docs.flutter.dev/deployment/web).

The output is `build/web/`. To bundle engine resources for hosting without a CDN, add `--no-web-resources-cdn`. Serve the output over HTTP, rather than opening index.html directly.

Widget tests cover overflow, mobile drawer/desktop navigation, theme switching, and invalid form submission across responsive widths. A browser performance/profile review is still recommended before publishing your final content.

## Firebase Hosting

Install Node.js and the Firebase CLI, then select your own Firebase project. A hosting configuration is included.

```sh
npm install -g firebase-tools
firebase login
flutter build web --release
firebase deploy --only hosting --project YOUR_FIREBASE_PROJECT_ID
```

If the project has no Hosting site, enable Hosting in the Firebase console or use `firebase init hosting`, selecting `build/web` as the public directory and keeping the generated index.html intact. No deployment has been performed from this workspace.

## GitHub Pages

For a project repository named `portfolio`:

```sh
flutter build web --release --base-href /portfolio/
```

Publish the **contents** of `build/web` to a `gh-pages` branch. One option is the `gh-pages` npm tool:

```sh
npx gh-pages -d build/web
```

In GitHub repository Settings → Pages, select deployment from the `gh-pages` branch and `/ (root)`. This requires your repository remote and GitHub authorization. For a root site (`USERNAME.github.io`) or a custom domain, use `--base-href /` instead. This single-page site uses internal scroll navigation, so it needs no route rewrite on Pages.


## Animated navbar logo

The navbar uses `AnimatedLogo` from `lib/widgets/animated_logo.dart`. Read [LOGO_GUIDE.md](LOGO_GUIDE.md) for the full source and both variations. The outlined `neon` style is active; set `style: LogoStyle.soft` to compare the quieter version. Colors come from the theme. Sora ExtraBold is loaded through google_fonts from the locally bundled font, with its license at `assets/fonts/Sora-OFL.txt`.


## Animation performance

The typewriter updates only `RotatingRole`, and its timer pauses outside the viewport. Hero orbit motion is painted from its animation listenable instead of rebuilding the scene each frame; it also pauses offscreen. Parallax transforms a cached scene. The pointer ring repaints its own layer without animating page layout. The navbar uses a lighter desktop blur, with no backdrop blur on mobile. The logo has reserved space so name expansion does not reposition neighboring navigation controls.

Judge animation responsiveness in a release build: `flutter build web --release --no-web-resources-cdn`, then serve `build/web` over HTTP. Debug mode remains useful for development. Automated regression tests check that typing/parallax preserve the hero scene and that offscreen animations stop and resume; they do not establish a browser FPS benchmark.


## Technology icons

`SkillIcon` maps skill names to locally bundled SVG/PNG logos in `assets/icons/`. Combined skills show both brand marks. GitHub and Vercel adapt to the theme for contrast. REST APIs, SQL, and Provider use meaningful generic symbols rather than unrelated logos. Asset sources are recorded in `assets/icons/SOURCES.md`; no runtime icon requests are made.

When adding new assets or changing their declarations, stop and rerun `flutter run -d chrome` to regenerate the development asset bundle. Hot reload of widget code can leave an older bundle running. Skill icon placeholders and errors are constrained to their intended dimensions, so failed requests cannot stretch the chips.


## Information structure

The reference https://kulbir-dhiman.vercel.app/ informed the information hierarchy: grouped skill categories, richer project stories, and visible resume access. The portfolio retains its own neon glass identity and uses Hardik's supplied resume and project links for personal content.

Skills are organized in `PortfolioData.skillGroups`. Work experience and education have separate responsive columns. Project cards expose an Explore project details action, opening `ProjectDetails` with contributions, technologies, and expandable technical notes. About includes a View resume action, alongside the existing Download CV button in the hero. Contact offers email, phone, and LinkedIn actions.


## Riverpod state management

`lib/providers/portfolio_providers.dart` contains theme and navigation notifiers, an auto-disposed viewport resource provider, and an auto-disposed contact submission notifier. The app entry point wraps `PortfolioApp` in `ProviderScope`. Theme toggling no longer uses app-level setState, and section/blur changes rebuild only their selected navbar consumers. Riverpod owns and disposes the scroll controller and pointer/parallax listenables. Hover, text-editing, visibility, and animation lifecycle state stays local to its widget; frequent paint updates do not propagate through global state.

The contact notifier prevents duplicate submissions and safely resets pending state after asynchronous completion, errors, or disposal. The form still opens an email draft rather than sending mail from a server. Tests that instantiate PortfolioApp directly wrap it in ProviderScope, allowing providers to be overridden and isolated.


## Neon glass theme

Dark mode is the default, managed by Riverpod. The design uses a navy base, cyan/violet gradient actions, translucent gradient panels, fine luminous borders, and restrained hover glows. The static ambient light/grid backdrop is cached in its own RepaintBoundary. Panels use translucent gradients instead of per-card BackdropFilter effects; only the desktop navbar uses a small blur. Light mode remains available with a corresponding cool-toned palette. The browser loading screen, favicon, and manifest match the new default.


## Vercel

`vercel.json` sets the framework to Other, runs `bash scripts/vercel-build.sh`, and publishes `build/web`. The script provisions Flutter 3.44.2 (Dart 3.12.2), resolves packages, and builds the release application with local CanvasKit resources. The Flutter SDK version and commit are pinned to the version used for development. File-system routes serve real JS, fonts, PDFs, and images before falling back to index.html.

Import the repository into Vercel with the repository root as Root Directory and Framework Preset Other. The checked-in configuration supplies the build command and output directory; remove conflicting dashboard overrides. Deploy the latest main commit containing vercel.json, rather than redeploying the earlier source-only commit.

The project source `web/` directory is a template, not the deployment output. `firebase.json` configures Firebase only. A successful Vercel source upload without the Flutter build can still show 404 at the deployed URL. The No checks configured message refers to optional deployment checks and is not a build failure.

For a local build-script check using an already installed matching SDK, set `PORTFOLIO_FLUTTER_SDK` to its absolute path before running the script. On Windows with Git Bash, use a path such as `/c/flutter/src/flutter`.


## Expanded portfolio

The page has nine navigable sections: Home, About, Expertise, Work, Case studies, Skills, Experience, Resume, and Contact. Expertise describes application, game, and integration capabilities. A pinned, vertically controlled project-story gallery opens full case-study dialogs explaining challenges, approaches, engineering details, and outcomes from the supplied resume. Resume offers direct view/download actions.

The primary desktop navigation remains compact, with the additional sections accessible through More sections. The mobile drawer scrolls so all entries remain reachable on short viewports. Team Pulse, Blocktopus, and NovaStrike retain their requested order, screenshots, and live destinations. The expansion introduces no repeating background timers and retains the offscreen animation safeguards.


## Behind the screens gallery

The case-study section pins below the navbar while native vertical wheel scrolling or upward touch swipes advance through three project stories one at a time. It releases after the final story and reverses when scrolling back. Desktop uses a left introduction, wide cinematic cards, a next-card preview, and a progress line; mobile stacks a compact introduction above a fitted card. Previous/next controls, dot selection on wider layouts, and keyboard arrows also scroll to the selected story. Full stories open in responsive, scrollable dialogs, preserving the selected project when closed. `caseStudyPageProvider` holds selection in Riverpod; the page controller and hover state remain local. The gallery has no autoplay timer or per-frame backdrop blur.
