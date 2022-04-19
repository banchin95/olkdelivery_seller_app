import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olkdelivery_sellers_app/global/global.dart';
import 'package:olkdelivery_sellers_app/model/category.dart';
import 'package:olkdelivery_sellers_app/uploadScreens/menus_upload_screen.dart';
import 'package:olkdelivery_sellers_app/widgets/info_design.dart';
import 'package:olkdelivery_sellers_app/widgets/my_drawer.dart';
import 'package:olkdelivery_sellers_app/widgets/progress_bar.dart';
import 'package:olkdelivery_sellers_app/widgets/text_widget_header.dart';

import '../splashScreen/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  RestrictBlockedSellersFromUsingApp() async
  {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot)
    {
      if(snapshot.data()!["status"] != "approved")
      {
        Fluttertoast.showToast(msg: "Вы были заблокированы.");

        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
      }
    });
  }

  @override
  void initState()
  {
    super.initState();
    RestrictBlockedSellersFromUsingApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: "Jost",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add, color: Colors.white,),
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MenusUploadScreen()));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Каталог")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("category")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                    child: Center(child: circularProgress(),),
                  )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index)
                      {
                        Category model = Category.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                      );
                      return InfoDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                      itemCount: snapshot.data!.docs.length,
                  );
            },
          ),
        ],
      ),
    );
  }
}
