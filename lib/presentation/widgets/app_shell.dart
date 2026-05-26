import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _totalTabs = 4;

  void _onTap(int index) => widget.navigationShell.goBranch(
    index,
    initialLocation: index == widget.navigationShell.currentIndex,
  );

  void _onSwipeLeft() {
    final next = widget.navigationShell.currentIndex + 1;
    if (next < _totalTabs) _onTap(next);
  }

  void _onSwipeRight() {
    final prev = widget.navigationShell.currentIndex - 1;
    if (prev >= 0) _onTap(prev);
  }

  @override
  Widget build(BuildContext context) {
    final idx = widget.navigationShell.currentIndex;
    return Scaffold(
      body: GestureDetector(
        // Instagram-style: swipe LEFT → next tab, swipe RIGHT → previous tab
        onHorizontalDragEnd: (details) {
          const threshold = 300.0; // velocity px/sec needed to trigger swipe
          final velocity = details.primaryVelocity ?? 0;
          if (velocity < -threshold) {
            _onSwipeLeft();
          } else if (velocity > threshold) {
            _onSwipeRight();
          }
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: _BottomNav(activeIndex: idx, onTap: _onTap),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.activeIndex, required this.onTap});

  final int activeIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.villa_rounded, label: 'Properties'),
    (icon: Icons.support_agent_rounded, label: 'My Leads'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xEB0F0F0F),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Instagram-style animated sliding gold indicator ──
            LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / _items.length;
                return SizedBox(
                  height: 2.5,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        left: tabWidth * activeIndex + tabWidth * 0.22,
                        top: 0,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: tabWidth * 0.56,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.55),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // ── Tab items ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: List.generate(_items.length, (i) {
                  final isActive = i == activeIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedScale(
                              scale: isActive ? 1.18 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              child: Icon(
                                _items[i].icon,
                                size: 24,
                                color: isActive
                                    ? AppColors.gold
                                    : AppColors.textSubtle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.gold
                                    : AppColors.textSubtle,
                              ),
                              child: Text(_items[i].label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
