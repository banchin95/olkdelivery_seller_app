import 'package:flutter/material.dart';
import 'package:olkdelivery_sellers_app/mainScreen/item_detail_screen.dart';
import 'package:olkdelivery_sellers_app/mainScreen/items_screen.dart';
import 'package:olkdelivery_sellers_app/model/category.dart';
import 'package:olkdelivery_sellers_app/model/items.dart';


class ItemsDesignWidget extends StatefulWidget
{
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}



class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1,),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "Lobster",
                ),
              ),
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3,),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2.0,),
              // Divider(
              //   height: 5,
              //   thickness: 3,
              //   color: Colors.grey[300],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
