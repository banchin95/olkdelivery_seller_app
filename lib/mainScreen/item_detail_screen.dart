import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../model/items.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/simple_app_bar.dart';


class ItemDetailsScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}




class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  TextEditingController counterTextEditingController = TextEditingController();


  deleteItem(String itemID)
  {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("category")
        .doc(widget.model!.categoryID!)
        .collection("items")
        .doc(itemID)
        .delete().then((value)
    {
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemID)
          .delete();

      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      Fluttertoast.showToast(msg: "Элемент успешно удален.");
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.width - 40,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  widget.model!.thumbnailUrl.toString(),
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                widget.model!.price.toString() + " ₽",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 10,),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  deleteItem(widget.model!.itemID!);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 25),
                  decoration: const BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 300,
                  height: 70,
                  child: const Center(
                    child: Text(
                      "Удалить этот элемент",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}