import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollan_movie_verse/core/enums/show_category.dart';
import 'package:smollan_movie_verse/core/enums/ui_state.dart';
import 'package:smollan_movie_verse/providers/show_provider.dart';
import 'package:smollan_movie_verse/providers/theme_provider.dart';
import 'package:smollan_movie_verse/screens/details/details_screen.dart';
import 'package:smollan_movie_verse/screens/search/search_screen.dart';
import 'package:smollan_movie_verse/widgets/show_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<ShowProvider>();
    provider.fetchHomeShows();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        provider.fetchHomeShows(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smollan Movie Verse",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),

          Consumer<ThemeProvider>(
            builder:
                (_, theme, __) => IconButton(
                  icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
                  onPressed: theme.toggleTheme,
                ),
          ),
        ],
      ),
      body: Column(
        children: [_buildFilters(), Expanded(child: _buildContent())],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<ShowProvider>(
      builder: (_, provider, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              ShowCategory.values.map((category) {
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(category.name),
                  selected: provider.currentCategory == category,
                  onSelected: (_) => provider.changeCategory(category),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildContent() {
    return Consumer<ShowProvider>(
      builder: (_, provider, __) {
        if (provider.homeState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.homeState == UIState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Error loading shows"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => provider.fetchHomeShows(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (provider.homeShows.isEmpty) {
          return const Center(child: Text("No shows found"));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;

            return GridView.builder(
              controller: _controller,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 3,
                childAspectRatio: 0.7,
              ),
              itemCount:
                  provider.homeShows.length + (provider.isFetchingMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= provider.homeShows.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final show = provider.homeShows[i];

                return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                 duration: const Duration(milliseconds: 400),
                 builder: (context, value, child) {
                return Opacity(
                 opacity: value,
                         child: Transform.translate(
                     offset: Offset(0, 20 * (1 - value)),
                 child: child,
      ),
    );
  },
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
      },
    );
  }
}
