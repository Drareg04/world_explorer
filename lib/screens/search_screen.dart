import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/countries_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = List.from(_searchHistory);
    history.remove(query); // avoid duplicates
    history.insert(0, query);
    if (history.length > 5) history.removeLast();
    await prefs.setStringList('search_history', history);
    _loadSearchHistory();
  }

  Future<void> _searchCountry() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final country = await CountriesService.fetchCountryByName(query);
      await _saveSearchHistory(query);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(country: country)),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('not found')
            ? 'Country "$query" not found. Try the English name (e.g., Spain, Germany).'
            : 'Network error: ${e.toString()}. Please check your connection.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _searchFromHistory(String query) {
    _controller.text = query;
    _searchCountry();
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Explorer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter country name (English)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchCountry,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchCountry(),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            if (_searchHistory.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent searches:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: _clearHistory, child: const Text('Clear')),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _searchHistory.map((query) {
                  return ActionChip(
                    label: Text(query),
                    onPressed: () => _searchFromHistory(query),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}