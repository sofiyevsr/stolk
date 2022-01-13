import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLoading;
  final EdgeInsets? padding;
  final void Function()? onTap;

  const SettingsTile({
    required this.title,
    required this.icon,
    this.isLoading = false,
    this.padding,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    icon,
                    size: 40,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: isLoading == true
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : AutoSizeText(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
