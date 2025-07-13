import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/presentation/profile/bloc/profile_pegawai_bloc.dart';

class ProfilePegawaiScreen extends StatelessWidget {
  const ProfilePegawaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        foregroundColor: Colors.red,
      ),
      body: BlocBuilder<ProfilePegawaiBloc, ProfilePegawaiState>(
        builder: (context, state) {
          if (state is ProfilePegawaiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfilePegawaiLoaded) {
            final data = state.data.first;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileRow("Nama", data.name ?? "-"),
                  _buildProfileRow("Email", data.email ?? "-"),
                  _buildProfileRow("Nomor Telepon", data.phone ?? "-"),
                  _buildProfileRow("Alamat", data.address ?? "-"),
                ],
              ),
            );
          }

          if (state is ProfilePegawaiError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Tidak ada data profil"));
        },
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
