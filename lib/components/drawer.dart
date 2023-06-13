import 'package:flutter/material.dart';
import 'package:samba/components/list_tile.dart';

// Menú lateral
class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;
  final void Function()? onManageCategoriesTap;
  final void Function()? onManageFriendsTap;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignOutTap, required this.onManageCategoriesTap, required this.onManageFriendsTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background),
                child: Expanded(
                  child: Center(
                    child: Image(
                      width: MediaQuery.of(context).size.width * 0.18,
                      image: const AssetImage(
                        'assets/icons/icon.png',
                      ),
                    ),
                  ),
                ),
              ),
              MyListTile(
                icon: Icons.home,
                text: 'I N I C I O',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person,
                text: 'P E R F I L',
                onTap: onProfileTap,
              ),
              MyListTile(
                icon: Icons.bookmarks_outlined,
                text: 'C A T E G O R Í A S',
                onTap: onManageCategoriesTap,
              ),
              MyListTile(
                icon: Icons.group,
                text: 'A M I G O S',
                onTap: onManageFriendsTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: MyListTile(
              icon: Icons.logout,
              text: 'C E R R A R  S E S I Ó N',
              onTap: onSignOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
