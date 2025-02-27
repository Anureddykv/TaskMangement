import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/user_bloc.dart';
import 'package:task_mangement_project/ui/user_detail_screen.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadUsers());
  }

  Future<void> _refreshUsers() async {
    BlocProvider.of<UserBloc>(context).add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return Center(child: CircularProgressIndicator());
          if (state is UserError) return Center(child: Text("Error loading users"));

          if (state is UserLoaded) {
            return RefreshIndicator(
              onRefresh: _refreshUsers,
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(user["avatar"])),
                    title: Text("${user["first_name"]} ${user["last_name"]}"),
                    subtitle: Text(user["email"]),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(userId: user["id"]),
                        ),
                      );
                      _refreshUsers();
                    },
                  );
                },
              ),
            );
          }
          return Center(child: Text("No users found"));
        },
      ),
    );
  }
}
