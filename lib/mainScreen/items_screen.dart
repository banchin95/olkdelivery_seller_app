import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:olkdelivery_sellers_app/model/category.dart';
import 'package:olkdelivery_sellers_app/model/items.dart';
import 'package:olkdelivery_sellers_app/uploadScreens/items_upload_screen.dart';
import 'package:olkdelivery_sellers_app/widgets/items_design.dart';
import 'package:olkdelivery_sellers_app/widgets/my_drawer.dart';
import 'package:olkdelivery_sellers_app/widgets/text_widget_header.dart';
import '../global/global.dart';
import '../uploadScreens/menus_upload_screen.dart';
import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget
{
  final Category? model;
  ItemsScreen({this.model});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(Icons.library_add, color: Colors.white,),
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsUploadScreen(model: widget.model)));
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "" + widget.model!.categoryTitle.toString() + "")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("category")
                .doc(widget.model!.categoryID)
                .collection("items")
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
                  Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ItemsDesignWidget(
                      model: model,
                      context: context,
                    ),
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
