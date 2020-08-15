import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imgUrlFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _prod = Product(
    id: null,
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
  );

  @override
  void dispose() {
    _imgUrlFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    print(_prod.title +
        _prod.description +
        _prod.imageUrl +
        _prod.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                onSaved: (newValue) => _prod = Product(
                  description: _prod.description,
                  id: _prod.id,
                  imageUrl: _prod.imageUrl,
                  price: _prod.price,
                  title: newValue,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Provide a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                textInputAction: TextInputAction.next,
                focusNode: _descFocusNode,
                onSaved: (newValue) => _prod = Product(
                  description: newValue,
                  id: _prod.id,
                  imageUrl: _prod.imageUrl,
                  price: _prod.price,
                  title: _prod.title,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imgUrlFocusNode);
                },
                onSaved: (newValue) => _prod = Product(
                  description: _prod.description,
                  id: _prod.id,
                  imageUrl: _prod.imageUrl,
                  price: double.parse(newValue),
                  title: _prod.title,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imgUrlController.text.isEmpty
                        ? Text(
                            'Enter Image URL.',
                          )
                        : FittedBox(
                            child: Image.network(
                              _imgUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imgUrlFocusNode,
                      controller: _imgUrlController,
                      onFieldSubmitted: (value) {
                        setState(() {});
                      },
                      onSaved: (newValue) => _prod = Product(
                        description: _prod.description,
                        id: _prod.id,
                        imageUrl: newValue,
                        price: _prod.price,
                        title: _prod.title,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
