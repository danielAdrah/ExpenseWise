import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  bool isEditing = false;
  bool isDarkTheme = true;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => setState(() => isEditing = !isEditing),
            child: Text(
              isEditing ? 'Save' : 'Edit',
              style: const TextStyle(color: Colors.purpleAccent),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Profile Information', style: sectionTitle()),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profileItem(Icons.person, 'Name', 'John Doe'),
                    profileItem(Icons.email, 'E-mail', 'john@example.com'),
                    profileItem(Icons.lock, '*** Password', 'Change It'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // General Section
          Text('General', style: sectionTitle()),
          Card(
            color: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  value: isDarkTheme,
                  onChanged: (val) => setState(() => isDarkTheme = val),
                  title:
                      const Text('Dark Theme', style: TextStyle(color: Colors.white)),
                  secondary: const Icon(Icons.nightlight_round, color: Colors.white),
                  activeColor: Colors.green,
                ),
                listTileItem(Icons.pie_chart, 'Summary'),
                listTileItem(Icons.people, 'My Accounts'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account Actions Section
          Text('Account Actions', style: sectionTitle()),
          Card(
            color: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                listTileItem(Icons.logout, 'Log Out'),
                listTileItem(Icons.delete, 'Delete Account'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileItem(IconData icon, String label, String value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isEditing
          ? Padding(
              key: ValueKey('$label-edit'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: Colors.white),
                  hintText: label,
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          : ListTile(
              key: ValueKey('$label-display'),
              leading: Icon(icon, color: Colors.white),
              title: Text(label, style: const TextStyle(color: Colors.white)),
              trailing: Text(value, style: const TextStyle(color: Colors.white70)),
            ),
    );
  }

  Widget listTileItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  TextStyle sectionTitle() => const TextStyle(
      color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold);
}
