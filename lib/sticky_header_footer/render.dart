// Copyright 2019 Xiaoheng Liu. All rights reserved.
// Use of this source code is governed by a the MIT license that can be
// found in the LICENSE file.

import 'dart:math' show min, max;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class XStickyRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  ScrollPosition _scrollPosition;

  XStickyRender(
      {ScrollPosition scrollPosition,
      RenderBox header,
      RenderBox content,
      RenderBox footer,
      String debugLabel})
      : _scrollPosition = scrollPosition {
    if (header != null) add(header);
    if (content != null) add(content);
    if (footer != null) add(footer);
  }

  set scrollPosition(ScrollPosition newValue) {
    if (newValue == _scrollPosition) {
      return;
    }
    final ScrollPosition oldValue = _scrollPosition;
    _scrollPosition = newValue;
    markNeedsLayout();
    if (attached) {
      oldValue?.removeListener(markNeedsLayout);
      newValue?.addListener(markNeedsLayout);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scrollPosition?.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollPosition?.removeListener(markNeedsLayout);
    super.detach();
  }

  RenderBox get _headerBox => lastChild;
  RenderBox get _footerBox => childBefore(_headerBox);
  RenderBox get _contentBox => childBefore(_footerBox);

  @override
  void performLayout() {
    assert(childCount == 3);

    final childConstraints = constraints.loosen();
    _headerBox.layout(childConstraints, parentUsesSize: true);
    _contentBox.layout(childConstraints, parentUsesSize: true);
    _footerBox.layout(childConstraints, parentUsesSize: true);

    final headerHeight = _headerBox.size.height;
    final contentHeight = _contentBox.size.height;
    final footerHeight = _footerBox.size.height;

    final contentWidth = _contentBox.size.width;

    final width = max(constraints.minWidth, contentWidth);
    final height =
        max(constraints.minHeight, headerHeight + contentHeight + footerHeight);
    size = Size(width, height);

    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));
    assert(size.isFinite);

    final scrollOffset = _contentOffset();
    // 布局控件
    // header
    // 控制header的最大偏移                             /* 减去footer */
    final double maxOffset = height - headerHeight - footerHeight;
    final headerParentData =
        _headerBox.parentData as MultiChildLayoutParentData;

    headerParentData.offset =
        Offset(0.0, max(0.0, min(-scrollOffset, maxOffset)));

    // content
    final contentParentData =
        _contentBox.parentData as MultiChildLayoutParentData;
    contentParentData.offset = Offset(0.0, headerHeight);

    // footer
    // 计算footer的最大偏移
    final double footerMaxOffset = height - contentHeight - footerHeight;
    final footerParentData =
        _footerBox.parentData as MultiChildLayoutParentData;
    // 计算footer的原始位置
    final double footerMinOffset = height - footerHeight;
    // 获取footer控件的位置，保证能贴在底部
    final footerOffset =
        _scrollPosition.viewportDimension ?? 0.0 - footerHeight - scrollOffset;

    footerParentData.offset =
        Offset(0.0, max(min(footerOffset, footerMinOffset), footerMaxOffset));
  }

  double _contentOffset() {
    final scrollBox =
        _scrollPosition.context.notificationContext.findRenderObject();
    if (scrollBox?.attached ?? false) {
      try {
        return localToGlobal(Offset.zero, ancestor: scrollBox).dy;
      } catch (e) {}
    }
    return 0.0;
  }

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _contentBox.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _contentBox.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _headerBox.getMaxIntrinsicHeight(width) +
        _contentBox.getMaxIntrinsicHeight(width) +
        _footerBox.getMaxIntrinsicHeight(width);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _headerBox.getMinIntrinsicHeight(width) +
        _contentBox.getMinIntrinsicHeight(width) +
        _footerBox.getMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  // @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
