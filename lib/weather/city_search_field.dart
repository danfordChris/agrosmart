import 'dart:async';

import 'package:agrosmart/weather/city_model.dart';
import 'package:flutter/material.dart';

class CitySearchField extends StatefulWidget {
  final Future<List<City>> Function(String) onSearch;
  final void Function(City) onCitySelected;

  const CitySearchField({
    super.key,
    required this.onSearch,
    required this.onCitySelected,
  });

  @override
  _CitySearchFieldState createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final TextEditingController _controller = TextEditingController();
  List<City> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 2) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _isSearching = true);
      try {
        final results = await widget.onSearch(query);
        if (results.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No Tanzanian cities found')),
          );
        }
        setState(() => _suggestions = results);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _suggestions = []);
      } finally {
        setState(() => _isSearching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search for cities in Tanzania...',
            border: const OutlineInputBorder(),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
        ),
        if (_suggestions.isNotEmpty)
          Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final city = _suggestions[index];
                  return ListTile(
                    leading: const Text('🇹🇿'),
                    title: Text(city.name),
                    onTap: () {
                      _controller.text = city.name;
                      widget.onCitySelected(city);
                      setState(() => _suggestions = []);
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}