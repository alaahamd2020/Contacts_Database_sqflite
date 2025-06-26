import 'package:database_contacts/helper/constance.dart';
import 'package:database_contacts/model/userModel.dart';
import 'package:database_contacts/views/Widgets/custom_text.dart';
import 'package:database_contacts/views/Widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            final int result = await UserModel().checkAndDelete();
            if (result > 0) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("check & delete"),
                    content: Text(
                      "Done Successfully, $result item${result == 1 ? '' : 's'} is deleted",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              if (mounted) {
                setState(() {});
              }
            }
          },
          child: CustomText(
            text: 'Contacts',
            fontSize: 27,
            alignment: Alignment.center,
            color: primaryColor.isLight ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAlertBox(null),
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: primaryColor.isLight?Colors.black:Colors.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder<List<UserModel>>(
          future: UserModel.getAll(),
          builder: (context, snapshot) {
            final usersList = snapshot.data ?? [];
            return ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: _buildItem(usersList[index], index),
                    onDismissed: (direction) => UserModel().delete(usersList[index].id!),
                    background: Container(color: Colors.redAccent, child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: 25, ),
                          Icon(Icons.delete, color: Colors.white, size: 25,),
                      ]
                        ,)),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: usersList.length,
            );
          },
        ),
      ),
    );
  }

  openAlertBox(UserModel? model) {
    TextEditingController name = TextEditingController(text: model?.name),
        phone = TextEditingController(text: model?.phone),
        email = TextEditingController(text: model?.email);

    void adduser() {
      _key.currentState!.save();
      if (_key.currentState!.validate()) {
        final _model = model ?? UserModel();

        _model
          ..name = name.text
          ..phone = phone.text
          ..email = email.text;

        _model.save().then((value) {
          // print( '${UserModel().save()}');
          Navigator.pop(context);
          setState(() {});
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(
            text: name.text == '' ? 'Add Contact' : 'Edit Contact',
            alignment: Alignment.center,
            fontSize: 18,
          ),
          content: Form(
            key: _key,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFiled(
                    text: 'Add Name',
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 2) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    type: TextInputType.text,
                  ), //name
                  SizedBox(height: 20),
                  CustomTextFiled(
                    text: 'Add Phone',
                    controller: phone,
                    // onsave: ((value) => phone = value!),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Phone';
                      }
                      return null;
                    },
                    type: TextInputType.number,
                  ), //phone
                  SizedBox(height: 20),
                  CustomTextFiled(
                    text: 'Add Email',
                    controller: email,
                    onsave: ((value) => adduser()),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !(value.contains('@') && value.contains('.'))) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    type: TextInputType.emailAddress,
                  ), //email
                  SizedBox(height: 20),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      adduser();
                    },
                    child: CustomText(
                      text: name.text == '' ? 'Add Contact' : 'Edit Contact',
                      alignment: Alignment.center,
                      color: primaryColor.isLight?Colors.black:Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildItem(UserModel model, int index) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        title: Row(
          children: [
            Column(
              children: [
                Container(
                  child: CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.5),
                    radius: 20,
                    child: CustomText(
                      text:
                          model.name!.isNotEmpty
                              ? model.name![0].toLowerCase()
                              : "ↈ",
                      alignment: Alignment.center,
                      fontSize: 20,
                      color: primaryColor.isLight ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            20.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_circle, size: 20),
                    SizedBox(width: 10),
                    Column(children: [CustomText(text: '${model.name}')]),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.phone, size: 20),
                    SizedBox(width: 10),
                    Column(children: [CustomText(text: '${model.phone}')]),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.email, size: 20),
                    SizedBox(width: 10),
                    Column(children: [CustomText(text: '${model.email}')]),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _onEdit(model, index);
          },
          icon: Icon(Icons.edit, size: 20),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  void _onEdit(UserModel model, int index) {
    openAlertBox(model);
  }
}
