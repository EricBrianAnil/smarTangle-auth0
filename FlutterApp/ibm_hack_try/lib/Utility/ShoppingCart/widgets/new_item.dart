import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  final Function addIt;

  NewItem(this.addIt);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final titleController = TextEditingController();

  final quantityController = TextEditingController();

  void submitData(){
    final enteredTitle = titleController.text;
    final enteredQuantity = quantityController.text;

    if(enteredTitle.isEmpty || enteredQuantity.isEmpty){
      return;
    }

    widget.addIt(
      enteredTitle,
      enteredQuantity,
    );   
    Navigator.of(context).pop();  
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Item'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Quantity'),
              controller: quantityController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            RaisedButton(
              child: Text('Add item'),
              color: const Color(0xffdd377b),
              textColor: Colors.white70,
              onPressed: submitData,

            )
          ],
        ),
      ),
    );
  }
}