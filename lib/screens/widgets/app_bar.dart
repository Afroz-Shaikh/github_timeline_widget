import 'package:flutter/material.dart';
import 'package:github_timeline/horizontal_page.dart';
import 'package:github_timeline/utils/constants.dart';

///
/// Main app bar for the application
///
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  ///
  /// Constructor for the MainAppBar
  ///
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size(600, 10),
        child: Divider(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.orangeAccent,
      title: const Text(
        'Hi, $userName',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Tooltip(
              triggerMode: TooltipTriggerMode.manual,
              message: 'Switch to horizontal view',
              child: GestureDetector(
                onTap: () {
                  // SystemChrome.setPreferredOrientations(
                  //     [DeviceOrientation.landscapeRight]);
                  Navigator.of(context).push(
                    MaterialPageRoute<HorizontalPage>(
                      builder: (builder) {
                        return const HorizontalPage();
                      },
                    ),
                  );
                },
                child: const Icon(
                  Icons.north_east,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
