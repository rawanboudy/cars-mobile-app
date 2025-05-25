import 'package:flutter/material.dart';
import 'theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final bool showAvatar;

  const CustomAppBar({
    Key? key,
    this.height = 140,
    this.leading,
    this.actions,
    this.title,
    this.showAvatar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            // Left side - Logo or custom leading widget
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                child: leading ?? Image.asset(
                  'assets/logo.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Center title if provided
            if (title != null)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    title!,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Right side - Avatar or custom actions
            if (showAvatar)
              Positioned(
                right: 20,
                top: 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile'); // Navigate when tapping avatar
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                    radius: 25,
                  ),
                ),
              ),

            // Custom actions if provided
            if (actions != null)
              Positioned(
                right: 20,
                top: 30,
                child: Row(
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}