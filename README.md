# Learning App (Flutter) – Laborator 3

Aplicație Flutter cu **State Management (Cubit / flutter_bloc)**, **programare asincronă**
și **componente UI reutilizabile**. Datele sunt într-un fișier JSON din proiect
(`assets/data/lab_v4.json`) și se încarcă asincron.

## Rulare (o singură dată pregătirea)

1. Deschide folderul `learning_app` în Android Studio (pluginurile **Flutter** și **Dart**).
2. În Terminal (în folderul proiectului):

       flutter create --project-name learning_app --org com.example --platforms=android .

   (generează doar `android/`; `lib/`, `pubspec.yaml`, `assets/`, `test/` rămân neatinse)
3. Descarcă pachetele (`flutter_bloc`, `equatable`):

       flutter pub get

4. Pornește un emulator / telefon și rulează `flutter run` (sau butonul ▶).

> Avatarul de pe Home se încarcă de pe internet (URL din JSON). Fără internet apare
> iconița de rezervă. Pentru build **release** adaugă în
> `android/app/src/main/AndroidManifest.xml`:
> `<uses-permission android:name="android.permission.INTERNET"/>`

## Navigare

`Home` → (My courses / Get Started) → `Courses` (listă) → `Course details`.
Un element din *Learning Plan* deschide direct detaliile cursului.

## Ce cerințe acoperă

| Cerință | Unde |
|---|---|
| Package de state management | `flutter_bloc` – `HomeCubit`, `CoursesCubit` |
| Date în JSON, încărcate asincron | `assets/data/lab_v4.json`, `data/repositories/course_repository.dart` (`async/await`, `Future`, `rootBundle.loadString`, latență simulată) |
| Stările **Loading / Success / Empty / Error** | `CoursesStatus` în `courses_state.dart`; widgeturi în `core/widgets/state_views.dart` |
| Căutare | `SearchField` + `Debouncer` (350 ms) → `CoursesCubit.search` |
| Filtrare | chip-uri pe categorii (`CategoryChips`) + filtru „doar favorite” |
| Sortare | `SortMenu`: Featured / Title / Rating / Duration |
| Favorite (add / remove) | `CoursesCubit.toggleFavorite`, `FavoriteButton` (în listă și în detalii) |
| Pagină de detalii | `features/course_details/` |
| Modelarea datelor | `data/models/` (`Course`, `Lesson`, `HomeData`, `AppData`, `fromJson`) |
| Componente reutilizabile | `core/widgets/` + `widgets/` din fiecare feature |
| Organizare ca un proiect real | straturi `core` / `data` / `features` |

## Structura proiectului

    lib/
      main.dart, app.dart            punctul de intrare + MultiBlocProvider
      core/
        config/app_config.dart       latență simulată, simulare eroare
        theme/                       culori, temă
        utils/                       Debouncer, mapare iconițe
        widgets/                     LoadingView, ErrorView, EmptyView, SearchField,
                                     CategoryChips, FavoriteButton, RatingBadge ...
      data/
        models/                      Course, Lesson, HomeData, AppData
        repositories/                CourseRepository (abstract) + AssetCourseRepository
      features/
        home/                        cubit/ view/ widgets/
        courses/                     cubit/ view/ widgets/   (lista)
        course_details/              view/ widgets/          (detalii)

Fluxul datelor: `JSON → AssetCourseRepository → Cubit (state) → BlocBuilder → UI`.

## Cum demonstrezi cele 4 stări

* **Loading** – se vede ~1,2 s la pornire (`AppConfig.loadDelay`).
* **Success** – lista de cursuri.
* **Empty** – caută `zzz`, sau apasă inima din bara de sus fără favorite.
* **Error** – în `lib/core/config/app_config.dart` pune `simulateError = true`,
  fă **Hot Restart**; apare ecranul de eroare cu butonul *Try again*.

## Modificări în JSON față de `lab_v4.json` original

Structura originală (`homePage`, `courseOverviewPage`) este păstrată. Am adăugat:
`category`, `level`, `accent`, `icon` și încă 3 lecții + descriere pentru cursul React
(ca să corespundă cu `lessonCount: 7`), plus secțiunea nouă `coursesPage.items`
(11 cursuri) – necesară ca lista să aibă ce căuta, filtra și sorta.

## Teste

    flutter test

`test/courses_cubit_test.dart` testează parsarea JSON și logica Cubit-ului
(Loading → Success, Error, căutare, Empty, categorie, sortare, favorite);
`test/widget_test.dart` testează ecranele.
