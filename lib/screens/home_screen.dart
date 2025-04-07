import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_techwarelab/screens/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication_screens/login_page.dart';
import '../provider_statemanagement/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {logout(context);
          }, icon: Icon(Icons.logout))],
        title: const Text(
          "Product List",
          style: TextStyle(
            fontFamily: "fontone",
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.white30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextFormField(
            onChanged: provider.searchProducts,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search 'apple'",
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    product['thumbnail'],
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
