import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

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

  var _initialValues = {
    'description': '',
    'imageUrl': '',
    'price': '0',
    'title': '',
  };

  var _isInit = false;
  var title = 'Add Product';

  @override
  void didChangeDependencies() {
    if (!_isInit && ModalRoute.of(context).settings.arguments != null) {
      _prod = ModalRoute.of(context).settings.arguments;
      _initialValues['description'] = _prod.description;
      _initialValues['imageUrl'] = _prod.imageUrl;
      _initialValues['price'] = _prod.price.toString();
      _initialValues['title'] = _prod.title;
      title = 'Edit Product';
      print(_initialValues);
      _imgUrlController.text = _prod.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    if (_prod.id != null) {
      Provider.of<ProductsProvider>(context, listen: false).editProduct(_prod);
    } else {
      Provider.of<ProductsProvider>(context, listen: false).addProduct(_prod);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                initialValue: _initialValues['title'],
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
                  isFavorite: _prod.isFavorite,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Provide a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValues['description'],
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
                  isFavorite: _prod.isFavorite,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Provide a description.';
                  }
                  if (val.length < 10) {
                    return 'Provide a longer description.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValues['price'],
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
                  isFavorite: _prod.isFavorite,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide a price';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Please provide a valid number.';
                  }
                  if (double.parse(val) <= 0) {
                    return 'Please provide a valid price.';
                  }
                  return null;
                },
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
                        isFavorite: _prod.isFavorite,
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
