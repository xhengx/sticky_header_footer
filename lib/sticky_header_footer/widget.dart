// Copyright 2019 Xiaoheng Liu. All rights reserved.
// Use of this source code is governed by a the MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import './render.dart';

class XSticky extends MultiChildRenderObjectWidget {
  XSticky({
    Key key,
    @required this.header,
    @required this.content,
    @required this.footer,
    this.controller,
  }) : super(
          key: key,
          children: [content, footer, header],
        );

  final Widget header;
  final Widget content;
  final Widget footer;

  final ScrollController controller;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scrollPosition =
        this.controller?.position ?? Scrollable.of(context).position;
    assert(scrollPosition != null);
    return XStickyRender(
        scrollPosition: scrollPosition, debugLabel: key.toString());
  }

  @override
  void updateRenderObject(BuildContext context, XStickyRender renderObject) {
    final scrollPosition =
        this.controller?.position ?? Scrollable.of(context).position;
    assert(scrollPosition != null);
    renderObject..scrollPosition = scrollPosition;
  }
}
