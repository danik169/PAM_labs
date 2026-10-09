import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------- colors
const Color kBlue = Color(0xFF465BFA);
const Color kOrange = Color(0xFFEE7B30);
const Color kOrangeLight = Color(0xFFFFF1E7);
const Color kLightBlueCard = Color(0xFFD6EAFB);
const Color kPurpleCard = Color(0xFFEDE0FA);
const Color kPurpleDark = Color(0xFF3B0F7D);
const Color kScreenBg = Color(0xFFF9FAFD);
const Color kTextDark = Color(0xFF14142B);
const Color kTextGray = Color(0xFF9A9AB0);
const Color kTrackGray = Color(0xFFEDEDF4);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------------------------------------------------------------- HOME
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCourse(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CourseOverviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue header + "Learned today" card overlapping its edge
              Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: Container(color: kBlue),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, Kristin',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Let's start learning",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFE3E3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: kBlue,
                                  size: 34,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          _LearnedTodayCard(
                            onMyCourses: () => _openCourse(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Banners
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _BannerCard(
                      title: 'What do you want to learn today?',
                      icon: Icons.school,
                      showButton: true,
                      width: 300,
                      onTap: () => _openCourse(context),
                    ),
                    const SizedBox(width: 14),
                    _BannerCard(
                      title: 'Check your progress',
                      icon: Icons.check_circle,
                      showButton: false,
                      width: 260,
                      onTap: () => _openCourse(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Learning Plan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: kTextDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const _LearningPlanCard(),
              const SizedBox(height: 22),
              const _MeetupCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnedTodayCard extends StatelessWidget {
  final VoidCallback onMyCourses;
  const _LearnedTodayCard({required this.onMyCourses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Learned today',
                style: TextStyle(color: kTextGray, fontSize: 14),
              ),
              GestureDetector(
                onTap: onMyCourses,
                child: const Text(
                  'My courses',
                  style: TextStyle(color: kBlue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '46min',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
                const TextSpan(
                  text: ' / 60min',
                  style: TextStyle(fontSize: 13, color: kTextGray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 46 / 60,
              minHeight: 6,
              color: kOrange,
              backgroundColor: kTrackGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool showButton;
  final double width;
  final VoidCallback onTap;

  const _BannerCard({
    required this.title,
    required this.icon,
    required this.showButton,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 160,
      decoration: BoxDecoration(
        color: kLightBlueCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 12,
            child: Icon(icon, size: 96, color: kBlue.withOpacity(0.55)),
          ),
          Positioned(
            left: 18,
            top: 18,
            right: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kTextDark,
                height: 1.3,
              ),
            ),
          ),
          if (showButton)
            Positioned(
              left: 18,
              bottom: 16,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LearningPlanCard extends StatelessWidget {
  const _LearningPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          _PlanRow(name: 'Packaging Design', done: 40, total: 48),
          SizedBox(height: 12),
          _PlanRow(name: 'Product Design', done: 6, total: 24),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String name;
  final int done;
  final int total;

  const _PlanRow({
    required this.name,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            value: done / total,
            strokeWidth: 3,
            color: kTextDark,
            backgroundColor: kTrackGray,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 17, color: kTextDark),
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$done',
                style: const TextStyle(fontSize: 17, color: kTextDark),
              ),
              TextSpan(
                text: '/$total',
                style: const TextStyle(fontSize: 17, color: kTextGray),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeetupCard extends StatelessWidget {
  const _MeetupCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [kPurpleCard, Color(0xFFEBDDF8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 120,
            top: 0,
            bottom: 0,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meetup',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kPurpleDark,
                  ),
                ),
                Text(
                  'Off-line exchange of learning experiences',
                  style: TextStyle(fontSize: 13, color: kPurpleDark),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Icon(Icons.groups, size: 90, color: kBlue),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- COURSE
class Lesson {
  final String title;
  final String duration;
  const Lesson(this.title, this.duration);
}

const List<Lesson> kLessons = [
  Lesson('Introduction to React', '04:28 min'),
  Lesson('Understanding React', '06:12 min'),
  Lesson('Create first React project', '43:58 min'),
  Lesson('Build React', '26:18 min'),
  Lesson('Components and props', '18:40 min'),
  Lesson('State and hooks', '31:05 min'),
  Lesson('Deploy your app', '12:45 min'),
];

class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key});

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: kScreenBg,
        bottomNavigationBar: const _EnrollBar(),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Course Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: kTextDark,
                        ),
                      ),
                    ],
                  ),
                ),

                const _CourseThumbnail(),
                const SizedBox(height: 22),
                const Text(
                  'React Front To back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: kTextGray),
                    const SizedBox(width: 6),
                    const Text(
                      '6h 30min  ·  7 lessons',
                      style: TextStyle(color: kTextGray, fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kOrangeLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 18, color: Color(0xFFFFB400)),
                          SizedBox(width: 4),
                          Text(
                            '4.9',
                            style: TextStyle(color: kOrange, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TabLabel(
                      label: 'Lessons',
                      active: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    _TabLabel(
                      label: 'Description',
                      active: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                if (_selectedTab == 0)
                  for (int i = 0; i < kLessons.length; i++) ...[
                    _LessonRow(lesson: kLessons[i], highlighted: i == 0),
                    const SizedBox(height: 18),
                  ]
                else
                  const Text(
                    'Learn React from the ground up: components, props, state, '
                    'hooks and how to connect your front end to a back end. '
                    'Each lesson is a short video followed by practical '
                    'exercises.',
                    style: TextStyle(
                      color: kTextGray,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  const _CourseThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6B4CE8), Color(0xFFA06CC8), Color(0xFFE48A5C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                'SPOKEN ENGLISH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, size: 36, color: kOrange),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoChip(icon: Icons.video_library, text: '75 Videos'),
                  SizedBox(width: 8),
                  _InfoChip(icon: Icons.class_, text: '35 Class'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kBlue),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabLabel({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: active ? kOrange : kTextGray.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: active ? 76 : 0,
              height: 2,
              color: kOrange,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final bool highlighted;

  const _LessonRow({required this.lesson, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: highlighted ? kOrange : Colors.white,
            shape: BoxShape.circle,
            boxShadow: highlighted
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Icon(
            Icons.play_arrow,
            size: 28,
            color: highlighted ? Colors.white : kOrange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lesson.duration,
                style: const TextStyle(fontSize: 17, color: kTextGray),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 30, color: kOrange),
      ],
    );
  }
}

class _EnrollBar extends StatelessWidget {
  const _EnrollBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kScreenBg,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 94,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kTrackGray),
                ),
                child: const Text(
                  'Free',
                  style: TextStyle(
                    color: kOrange,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Enroll Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
