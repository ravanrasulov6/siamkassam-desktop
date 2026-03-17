import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// These should be in .env but initializing basics for now
const supabaseUrl = 'https://wwrahddgifggepxjjvxg.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3cmFoZGRnaWZnZ2VweGpqdnhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMTc2NzksImV4cCI6MjA4ODY5MzY3OX0.77xtcOf1GQejZGcP32wkL3DheyiAEUXMv4Jul76Uz3s';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}
