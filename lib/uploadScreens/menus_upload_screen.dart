import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olkdelivery_sellers_app/mainScreen/home_screen.dart';
import 'package:olkdelivery_sellers_app/widgets/progress_bar.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;


class MenusUploadScreen extends StatefulWidget
{
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  _MenusUploadScreenState createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen>
{
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        title: const Text(
          "Добавить категории",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Jost",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.grey, size: 200.0,),
              ElevatedButton(
                child: const Text(
                  "Добавить",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Jost",
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: ()
                {
                  takeImage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return SimpleDialog(
          title: const Text("Выберите изображение", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 20,),),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Снять на камеру",
                style: TextStyle(color: Colors.grey, fontSize: 18,),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: const Text(
                "Выбрать из галереи",
                style: TextStyle(color: Colors.grey, fontSize: 18,),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Отмена",
                style: TextStyle(color: Colors.redAccent, fontSize: 18,),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
        ),
        title: const Text(
          "Сохранить категорию",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Jost",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenusUploadForm();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white, size: 35,),
            onPressed: uploading ? null : ()=> validateUploadForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black,),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Описания",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.black,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black,),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Названия",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenusUploadForm()
  {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async
  {
    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //save info to firestore
        saveInfo(downloadUrl);
      }
      else
      {
        showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Пожалуйста, заполните описания категория",
            );
          },
        );
      }
    }
    else
    {
      showDialog(
        context: context,
        builder: (c)
        {
          return ErrorDialog(
            message: "Пожалуйста, выберите изображение",
          );
        },
      );
    }
  }

  saveInfo(String downloadUrl)
  {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("category");

    ref.doc(uniqueIdName).set({
      "categoryID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "categoryInfo": shortInfoController.text.toString(),
      "categoryTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearMenusUploadForm();

    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  uploadImage(mImageFile) async
  {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("category");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context)
  {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}