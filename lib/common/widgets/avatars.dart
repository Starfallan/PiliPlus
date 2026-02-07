import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:flutter/material.dart';

Widget avatars({
  required ColorScheme colorScheme,
  required Iterable<Owner> users,
}) {
  const gap = 6.0;
  const size = 22.0;
  const padding = 0.8;
  const offset = size - gap;
  const imgSize = size - 2 * padding;
  if (users.length == 1) {
    return NetworkImgLayer(
      src: users.first.face,
      width: imgSize,
      height: imgSize,
      type: .avatar,
    );
  } else {
    final decoration = BoxDecoration(
      shape: .circle,
      border: Border.all(color: colorScheme.surface),
    );
    return SizedBox(
      height: size,
      width: offset * users.length + gap,
      child: Stack(
        clipBehavior: .none,
        children: users.indexed
            .map(
              (e) => Positioned(
                top: 0,
                bottom: 0,
                width: size,
                left: e.$1 * offset,
                child: DecoratedBox(
                  decoration: decoration,
                  child: Padding(
                    padding: const .all(padding),
                    child: NetworkImgLayer(
                      src: e.$2.face,
                      width: imgSize,
                      height: imgSize,
                      type: .avatar,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
