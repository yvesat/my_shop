import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _imageUrlFocusNode = FocusNode();

  var _EditedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        _EditedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _EditedProduct.title,
          'description': _EditedProduct.description,
          'price': _EditedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _EditedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();
    if (_EditedProduct.id != null) {
      setState(() {
        _isLoading = false;
      });
      Provider.of<ProductsProvider>(context, listen: false).updateProduct(_EditedProduct.id!, _EditedProduct);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isLoading = false;
      });
      await Provider.of<ProductsProvider>(context, listen: false).addProduct(_EditedProduct);
      Navigator.of(context).pop();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please provide a title for your product.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _EditedProduct = Product(
                            id: _EditedProduct.id,
                            isFavorite: _EditedProduct.isFavorite,
                            title: value!,
                            description: _EditedProduct.description,
                            price: _EditedProduct.price,
                            imageUrl: _EditedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price.';
                          }

                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }

                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _EditedProduct = Product(
                            id: _EditedProduct.id,
                            isFavorite: _EditedProduct.isFavorite,
                            title: _EditedProduct.title,
                            description: _EditedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _EditedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please provide a description for your product';
                          }
                          if (value.length < 6) {
                            return 'The provided description is too short.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _EditedProduct = Product(
                            id: _EditedProduct.id,
                            isFavorite: _EditedProduct.isFavorite,
                            title: _EditedProduct.title,
                            description: value!,
                            price: _EditedProduct.price,
                            imageUrl: _EditedProduct.imageUrl,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text('Enter a URL'))
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a image URL for your product';
                                }

                                if (!value.startsWith('http') && !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                                  return 'The supported image formats are .png, .jpg and .jpeg';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _EditedProduct = Product(
                                  id: _EditedProduct.id,
                                  isFavorite: _EditedProduct.isFavorite,
                                  title: _EditedProduct.title,
                                  description: _EditedProduct.description,
                                  price: _EditedProduct.price,
                                  imageUrl: value!,
                                );
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: EdgeInsets.all(16),
                        child: InkWell(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                'SAVE PRODUCT',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () {
                            _saveForm();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
