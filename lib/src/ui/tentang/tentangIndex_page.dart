import 'package:flutter/material.dart';

import 'Misi_tabbar.dart';
import 'Visi_tabbar.dart';
import 'gallery_tabbar.dart';
import 'sejarahSingkat_tabbar.dart';

class TentangIndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Visi'),
                Tab(text: 'Misi'),
                Tab(text: 'Sejarah Singkat'),
                Tab(text: 'Gallery'),
              ],
            ),
            title: Text('Q_Sm@rt'),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              VisiTabbarItem(),
              MisiTabbarItem(),
              SejarahSingkatTabbarItem(),
              GalleryTabbarItem()
            ],
          ),
        ),
      ),
    );
  }
}
