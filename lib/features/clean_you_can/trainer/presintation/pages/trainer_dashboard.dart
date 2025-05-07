import 'package:flutter/material.dart';

class TrainerDashboardPage extends StatelessWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.book, color: Colors.indigo),
            const SizedBox(width: 8),
            Text(
              'TrainerHub',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.emoji_people),
                  // backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, John Doe 👋',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Text(
                      'Trainer',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2,
              children: [
                _buildStatCard(
                  'Courses',
                  '12',
                  Icons.menu_book,
                  Colors.indigo,
                ),
                _buildStatCard(
                  'Students',
                  '260',
                  Icons.group,
                  Colors.teal,
                ),
                _buildStatCard(
                  'Progress',
                  '78%',
                  Icons.show_chart,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Sessions',
                  '134',
                  Icons.schedule,
                  Colors.pink,
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              'Your Courses',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Course List
            _buildCourseCard(
              context,
              title: 'Flutter UI Mastery',
              badgeText: 'Popular',
              students: '120 Students',
              updated: 'Updated 3 days ago',
              progress: 0.7,
            ),
            const SizedBox(height: 16),
            _buildCourseCard(
              context,
              title: 'Flutter Logic',
              badgeText: 'Popular',
              students: '120 Students',
              updated: 'Updated 3 days ago',
              progress: 0.7,
            ),
            const SizedBox(height: 16),
            _buildCourseCard(
              context,

              title: 'Advanced Dart',
              badgeText: 'New',
              students: '65 Students',
              updated: 'Updated 1 week ago',
              progress: 0.4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {

    required String title,
    required String badgeText,
    required String students,
    required String updated,
    required double progress,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Icon(Icons.people_alt),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$students • $updated',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Manage Course'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';

class TrainerDashboard extends StatelessWidget {
  const TrainerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome, Trainer 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            /// Horizontal stats row wrapped in scroll view to avoid overflow
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard('Centers', '5', Icons.location_city),
                  const SizedBox(width: 16),
                  _buildStatCard('Courses', '12', Icons.menu_book),
                  const SizedBox(width: 16),
                  _buildStatCard('Students', '120', Icons.group),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('My Courses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCourseCard(
              title: 'Flutter for Beginners',
              students: 30,
              date: 'May 10, 2025',
            ),
            _buildCourseCard(
              title: 'Advanced Dart',
              students: 18,
              date: 'May 12, 2025',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 12),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({required String title, required int students, required String date}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.book, size: 40, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$students Students\nStarts: $date'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}


 */