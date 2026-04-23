import 'package:flutter/material.dart';
import 'package:smollan_movie_verse/data/models/show_model.dart';

class ShowCard extends StatelessWidget {
  final Show show;
  final VoidCallback onTap;

  const ShowCard({
    super.key,
    required this.show,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: SizedBox(
          height: width * 0.65,
          child: Stack(
            children: [
              /// 🎬 CLEAN IMAGE (FULL)
              Positioned.fill(
                child: Hero(
                  tag: show.id.toString(),
                  child: Image.network(
                    show.image?.isNotEmpty == true
                        ? show.image!
                        : 'https://via.placeholder.com/300x400',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// 🪟 BOTTOM TRANSPARENT PANEL
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                  decoration: BoxDecoration(
                   color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📝 TITLE
                      Text(
                        show.name.isNotEmpty ? show.name : "No Title",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      
                      Text(
                        "⭐ ${show.rating ?? 'N/A'}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}