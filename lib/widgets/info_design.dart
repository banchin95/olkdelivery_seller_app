import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olkdelivery_sellers_app/global/global.dart';
import 'package:olkdelivery_sellers_app/mainScreen/items_screen.dart';
import 'package:olkdelivery_sellers_app/model/category.dart';


class InfoDesignWidget extends StatefulWidget
{
  Category? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}



class _InfoDesignWidgetState extends State<InfoDesignWidget>
{
  deleteCategory(String categoryID)
  {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("category")
        .doc(categoryID)
        .delete();

    Fluttertoast.showToast(msg: "Категория удалено, успешно");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 295,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.categoryTitle!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 16,
                      fontFamily: "Jost",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: ()
                    {
                      //delete menu
                      deleteCategory(widget.model!.categoryID!);
                    },
                  ),
                ],
              ),
              // Text(
              //   widget.model!.categoryInfo!,
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 12,
              //   ),
              // ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
