// lib/supabase_client.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientInstance {
  static final SupabaseClient client = Supabase.instance.client;

  // Optionally, you can initialize it here, or do it in the main app.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://ycekauexzcjndeflhmug.supabase.co',  // Replace with your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljZWthdWV4emNqbmRlZmxobXVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg1MzYyMzksImV4cCI6MjA0NDExMjIzOX0.Uc9lY1KjpxElQQjybSisdmHdSEHRqqMXTyhreyTEYeM',  // Replace with your Supabase anon key
    );
  }
}
