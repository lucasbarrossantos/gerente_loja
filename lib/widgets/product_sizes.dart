import 'package:flutter/material.dart';

import 'add_size_dialog.dart';

class ProductSize extends FormField<List> {
  ProductSize({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return SizedBox(
                height: 34,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5,
                  ),
                  children: state.value.map((value) {
                    return InkWell(
                      onLongPress: () {
                        state.didChange(state.value..remove(value));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              border: Border.all(
                                  color: Colors.pinkAccent, width: 3.0)),
                          alignment: Alignment.center,
                          child: Text(value,
                              style: TextStyle(color: Colors.white))),
                    );
                  }).toList()
                    ..add(
                      InkWell(
                        onTap: () async {
                          String size = await showDialog(
                              context: context,
                              builder: (context) => AddSizeDialog());

                          if (size != null)
                            state.didChange(state.value..add(size));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              border: Border.all(
                                  color: state.hasError
                                      ? Colors.red
                                      : Colors.pinkAccent,
                                  width: 3.0)),
                          alignment: Alignment.center,
                          child: Text(
                            '+',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ),
              );
            });
}
