import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/theme_data.dart';
import '../inner_screens/cat_screen.dart';
import '../models/res_model.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/categories_widget.dart';
import '../widgets/text_widget.dart';


class CategoriesScreen extends StatefulWidget {
    static const routeName = "/CategoriesScreen";
   CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
          
          title: const Text("Restaurants",style: TextStyle(
          fontWeight: FontWeight.bold,color: Colors.white)),
        ),
        body: StreamBuilder<QuerySnapshot>(
           stream: FirebaseFirestore.instance.collection('resturants').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                          return
                          Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      height: 190.0,
      child: InkWell(
        onTap: (){
                  Navigator.pushNamed(context, CategoryScreen.routeName,
             arguments: data['title']);
        },
        child:
         Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 160.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 15),
                        blurRadius: 25,
                        color: Colors.black12),
                  ]),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.0),
                child: Image.network(
                  snapshots.data!.docs[index]['imageUrl'],
                     height: 150.0,
                      width: 150.0,
                   fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
                bottom: 0.0,
                right: 0.0,
                child: SizedBox(
                  height: 136.0,
                  width: size.width - 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        child: TextWidget(
                          text: snapshots.data!.docs[index]['title'],
                          textSize: 26,
                          color: Colors.black,
                          isTitle: true,
                        
                        ),
                      ),
                      
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
                  }
                );
          }
        )
        
        );
  }
}
