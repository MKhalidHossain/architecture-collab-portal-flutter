import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pagination.dart';

class PaginatedListWidget<T> extends StatefulWidget {
  final Rx<Pagination<T>> pagination;
  final Widget skeleton;

  /// How many skeletons to show, when there is no data
  final int skeletonCount;
  final VoidCallback? onRefresh;
  final ScrollPhysics physics;
  final Widget Function(int index, T data) builder;
  const PaginatedListWidget({
    super.key,
    required this.pagination,
    this.onRefresh,
    required this.skeleton,
    required this.skeletonCount,
    required this.builder, 
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  State<PaginatedListWidget<T>> createState() => _PaginatedListWidgetState<T>();
}

class _PaginatedListWidgetState<T> extends State<PaginatedListWidget<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async{
          if (widget.onRefresh != null) {
            widget.onRefresh!();
          }
        },
        child: ObxValue((data) {
          return ListView.builder(
            physics: widget.physics,
            itemCount: data.value.data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.value.data.length) {
                debugPrint("pagination type: ${data.value.runtimeType}");
                if ((data.value is LoadingMorePage<T> ||
                    data.value is RefreshingPage<T>)) {
                  return Column(
                    spacing: 8,
                    children: [
                      ...List.generate(
                        widget.skeletonCount,
                        (_) => widget.skeleton,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }
              final element = data.value.data[index];
              return widget.builder(index, element);
            },
          );
        }, widget.pagination),
      ),
    );
  }
}
