import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Utility/ShoppingCart/models/items.dart';
//import 'package:intl/intl.dart';

class ItemList extends StatelessWidget {
  final List<Item> items;
  
  ItemList(this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemBuilder: (uit, index) {
          return Dismissible(
            child: Card(
              elevation: 5,
              color: const Color(0xffdd377b),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: ListTile(

                title: Text(
                    items[index].title,
                    style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
                ),
                subtitle: Text('Details',style: TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),

                trailing: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                        child: Text(items[index].quantity, style: TextStyle(color: const Color(0xffdd377b),fontWeight: FontWeight.w700),)
                    ),
                  ),
                ),
              ),
            ),
              key: UniqueKey(),
              onDismissed: (Direction){items.remove(items[index]);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Item Removed from the Cart")));
              },
          );
        },
        itemCount: items.length,

      )
    );
  }
}