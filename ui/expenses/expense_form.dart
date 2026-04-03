import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
 
  final _titleController = TextEditingController();

  @override
  void dispose(){
    super.dispose();

    _titleController.dispose();
  }

  void onCreate() {
    //  1 Build an expense
    String  title = _titleController.text;
    double amount = 0;             // for now..
    Category category =Category.food;   // for now..
    DateTime date = DateTime.now();

    // ignore: unused_local_variable
    Expense newExpense = Expense(title: title, amount: amount, date: date, category: category);


    // TODO YOUR CODE HERE
  }
  
  void onCancel() {
   
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
           ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
           SizedBox(width: 10,),
          ElevatedButton(onPressed: onCreate, child: Text("Create")),
        ],
      ),
    );
  }
}
