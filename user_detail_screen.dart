import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/user_bloc.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  UserDetailScreen({required this.userId});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadUserById(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return Center(child: CircularProgressIndicator());
          if (state is UserError) return Center(child: Text("Error loading user"));

          if (state is SingleUserLoaded) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundImage: NetworkImage(state.user["avatar"])),
                  SizedBox(height: 20),
                  Text("${state.user["first_name"]} ${state.user["last_name"]}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(state.user["email"], style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return Center(child: Text("User not found"));
        },
      ),
    );
  }
}
