import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/ui_state.dart';
import '../../core/utils/debouncer.dart';
import '../../providers/show_provider.dart';
import '../details/details_screen.dart';
import '../../widgets/show_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Debouncer _debouncer = Debouncer();
  String _lastQuery = '';

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search shows...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _lastQuery = value;
                _debouncer.run(() {
                  context.read<ShowProvider>().searchShows(value);
                });
              },
            ),
          ),

          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Consumer<ShowProvider>(
      builder: (_, provider, __) {
        switch (provider.searchState) {
        
          case UIState.loading:
            return const Center(child: CircularProgressIndicator());

        
          case UIState.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error searching"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ShowProvider>().searchShows(_lastQuery);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );

         
          case UIState.success:
            if (provider.searchResults.isEmpty) {
              return const Center(child: Text("No results found"));
            }

            
            return LayoutBuilder(
              builder: (context, constraints) {
                // Tablet  view
                if (constraints.maxWidth > 600) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: provider.searchResults.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (_, i) {
                      final show = provider.searchResults[i];

                      return ShowCard(
                        show: show,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(show: show),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                // mobile view
                return ListView.builder(
                  itemCount: provider.searchResults.length,
                  itemBuilder: (_, i) {
                    final show = provider.searchResults[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: ShowCard(
                        show: show,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(show: show),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );

          
          default:
            return const Center(
              child: Text("Start typing to search"),
            );
        }
      },
    );
  }
}