import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserProfilePage(),
  ));
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _userName = 'Michael';
  String _email = 'miketherunner@gmail.com';
  String _phoneNumber = '123-456-7890';
  String _bio = '';
  String _location = '';
  String _interests = '';
  String _socialMedia = '';
  Uint8List? _profileImageData;
  final ScrollController _scrollController = ScrollController();
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _loadInitialImage();
    _scrollController.addListener(_scrollListener);
  }

  void _loadInitialImage() async {
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

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showSaveButton = true;
      });
    } else {
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
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(bottom: 10),
            sliver: SliverAppBar(
              title: Text(
                'My Profile',
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5),
                  bottom: Radius.circular(3),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(40),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  GestureDetector(
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
                              backgroundImage: MemoryImage(_profileImageData!),
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
                  SizedBox(height: 20),
                  _buildProfileField(
                    labelText: 'User Name',
                    initialValue: _userName,
                    onChanged: (value) {
                      setState(() {
                        _userName = value;
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
                  _buildAdditionalProfileFeature(
                    icon: Icons.person,
                    title: 'Bio',
                    subtitle: 'Add a short description about yourself',
                    inputValue: _bio,
                    onTap: (value) {
                      _showInputDialog(_bio, (value) {
                        setState(() {
                          _bio = value;
                        });
                      });
                    },
                  ),
                  _buildAdditionalProfileFeature(
                    icon: Icons.location_on,
                    title: 'Location',
                    subtitle: 'Add or update your current location',
                    inputValue: _location,
                    onTap: (value) {
                      _showInputDialog(_location, (value) {
                        setState(() {
                          _location = value;
                        });
                      });
                    },
                  ),
                  _buildAdditionalProfileFeature(
                    icon: Icons.tag,
                    title: 'Interests',
                    subtitle: 'Add or update your interests or hobbies',
                    inputValue: _interests,
                    onTap: (value) {
                      _showInputDialog(_interests, (value) {
                        setState(() {
                          _interests = value;
                        });
                      });
                    },
                  ),
                  _buildAdditionalProfileFeature(
                    icon: Icons.link,
                    title: 'Social Media',
                    subtitle: 'Connect your social media profiles',
                    inputValue: _socialMedia,
                    onTap: (value) {
                      _showInputDialog(_socialMedia, (value) {
                        setState(() {
                          _socialMedia = value;
                        });
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder action for saving data
                      print('User Information Saved');
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 166, 70, 183),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _confirmDeleteAccount(context);
                    },
                    child: Text('Delete Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildAdditionalProfileFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required String inputValue,
    required ValueChanged<String> onTap,
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
          onTap: () {
            onTap(inputValue);
          },
        ),
        if (inputValue.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              inputValue,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        Divider(color: Colors.grey),
      ],
    );
  }

  void _showInputDialog(String initialValue, Function(String) onSave) {
    String inputValue = initialValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter'),
          content: TextFormField(
            initialValue: initialValue,
            onChanged: (value) => inputValue = value,
            decoration: InputDecoration(
              hintText: 'Enter',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(inputValue);
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Account Deletion'),
          content: Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAccount();
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Navigate back to previous screen after account deletion
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    // Placeholder method for account deletion logic
    // Implement actual account deletion logic here
    print('Account deleted successfully.');
  }
}
