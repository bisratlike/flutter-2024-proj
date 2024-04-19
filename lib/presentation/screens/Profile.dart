import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminProfilePage(),
  ));
}

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String _adminName = 'Sebastian Goddard';
  String _email = 'Sabastiangoddard12@gmail.com';
  String _phoneNumber = '123-456-7890';
  String _password = '';
  Uint8List? _profileImageData; // Storing image bytes directly
  bool _showSaveButton = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set initial profile image when the page loads
    _loadInitialImage();

    // Add listener to scroll controller to detect scroll position
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Dispose the scroll controller to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialImage() async {
    // Simulate loading the initial image bytes (replace this with your actual logic)
    final initialImageBytes =
        await _loadImageBytesFromPath('images/default_profile.jpg');
    setState(() {
      _profileImageData = initialImageBytes;
    });
  }

  Future<Uint8List> _loadImageBytesFromPath(String path) async {
    final file = File(path);
    return await file.readAsBytes();
  }

  void _updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageData = bytes;
      });
    }
  }

  void _changePassword() {
    // Reset password state
    _password = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    _password.length >= 8
                        ? 'Valid password'
                        : 'Password must be at least 8 characters long',
                    style: TextStyle(
                      color: _password.length >= 8 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _password.length >= 8
                      ? () {
                          // Implement password change logic here
                          print('Password changed');
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Text('Change'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveAdminInformation() {
    print('Admin information saved');
  }

  // Scroll listener to detect scroll position
  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      // If scroll reaches the end, show the save button
      setState(() {
        _showSaveButton = true;
      });
    } else {
      // If scroll position changes, hide the save button
      setState(() {
        _showSaveButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              'Admin Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 166, 70, 183),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            floating: true,
            pinned: false,
            snap: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                    child: GestureDetector(
                      onTap: _updateProfilePicture,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: _profileImageData != null
                            ? CircleAvatar(
                                backgroundImage:
                                    MemoryImage(_profileImageData!),
                                radius: 60,
                              )
                            : Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  _buildProfileField(
                    labelText: 'Admin Name',
                    initialValue: _adminName,
                    onChanged: (value) {
                      setState(() {
                        _adminName = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildProfileField(
                    labelText: 'Email',
                    initialValue: _email,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildProfileField(
                    labelText: 'Phone Number',
                    initialValue: _phoneNumber,
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 10),
                  _buildAdditionalFeatures(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        // Only show the save button when _showSaveButton is true
        visible: _showSaveButton,
        child: ElevatedButton(
          onPressed: _saveAdminInformation,
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 166, 70, 183),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: Icon(Icons.edit, color: Colors.purple),
        labelStyle: TextStyle(
          color: Colors.purple,
          fontFamily: 'Roboto',
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildAdditionalFeatures() {
    return Column(
      children: [
        // Add additional features here
        _buildAdditionalFeature(
          icon: Icons.security,
          title: 'Security Settings',
          subtitle: 'Manage security preferences',
          onTap: () {
            // Implement security settings functionality
          },
        ),
        _buildAdditionalFeature(
          icon: Icons.settings,
          title: 'App Settings',
          subtitle: 'Customize app preferences',
          onTap: () {
            // Implement app settings functionality
          },
        ),
        _buildAdditionalFeature(
          icon: Icons.vpn_key,
          title: 'Change Password',
          subtitle: 'Change your login password',
          onTap: _changePassword,
        ),
        // Add more additional features as needed
      ],
    );
  }

  Widget _buildAdditionalFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.purple),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Roboto',
            ),
          ),
          onTap: onTap,
        ),
        Divider(color: Colors.grey),
      ],
    );
  }
}
