import 'dart:ui';
import 'package:flutter/material.dart';

Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withOpacity(0.35),
          child: child,
        ),
      ),
    );
  }