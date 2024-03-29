import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodmix/components/includes/content_shimmer.dart';
import 'package:foodmix/viewModels/recipe_view_model.dart';
import 'package:stacked/stacked.dart';

class RecipeOverlay extends ViewModelWidget<RecipeViewModel> {
  const RecipeOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, RecipeViewModel viewModel) {
    return Stack(
      children: [
        Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: viewModel.isReady ? CachedNetworkImage(
                  imageUrl: viewModel.$cdn('${viewModel.recipe?.avatar}'),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover
              ) : const _OverlayBackground(),
            )
        ),
        Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: viewModel.isReady ?  const _RecipeAuthor() : const ContentShimmer(child: SizedBox(width: double.infinity, height: 45)),
                    ),
                  ),
                )
            )
        )
      ],
    );
  }
}

class _RecipeAuthor extends ViewModelWidget<RecipeViewModel> {
  const _RecipeAuthor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, RecipeViewModel viewModel) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: viewModel.$cdn(viewModel.recipe?.user?.avatar ?? ''),
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            )),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đăng bởi',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 3),
                Text('${viewModel.recipe?.user?.name}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)
                )
              ],
            )),
        const SizedBox(width: 10),
        Opacity(
          opacity: 0.7,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border:
                Border.all(color: Colors.white, width: 2)),
            child: const Icon(Icons.chevron_right,
                color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }
}


class _OverlayBackground extends StatelessWidget {
  const _OverlayBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentShimmer(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey,
        )
    );
  }
}
