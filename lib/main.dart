import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/* ─── 根应用 ─── */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mobile Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const SplashScreen(),
    );
  }
}

/* ─── 启动页（3 秒） ─── */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset('assets/images/image_0.png', fit: BoxFit.cover),
      ),
    );
  }
}

/* ─── 主页面─── */
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  /* 商品数据 */
  final List<Product> _products = [
    Product(
        name: 'SQEQE Axolotl Plush Axolotl Stuffed Animal',
        price: 2.5,
        imageAsset: 'assets/images/image_1.jpg',
        sales: 1200,
        description: 'Soft Cotton Plushies Animal Pillow Gifts for Kids(Pink)'),
    Product(
        name: 'Emotional Support Strawberries',
        price: 1.8,
        imageAsset: 'assets/images/image_2.jpg',
        sales: 980,
        description:
        'Cuddly Strawberries with Carrying Basket, gift for all ages'),
    Product(
        name: 'Walking and Talking Penguin Plush Toy',
        price: 3.2,
        imageAsset: 'assets/images/image_3.jpg',
        sales: 760,
        description:
        'Repeats what you say; fun penguin plush for boys and girls'),
    Product(
        name: 'Emotional Support Dumplings',
        price: 5.0,
        imageAsset: 'assets/images/image_4.jpg',
        sales: 430,
        description: 'Set of 5 dumpling plushies with basket'),
    Product(
        name: 'Stuffed Animal Throw Plushie Pillow Doll',
        price: 4.5,
        imageAsset: 'assets/images/image_5.jpg',
        sales: 1020,
        description: 'Fluffy corgi cushion for every occasion'),
  ];

  /* 购物车 */
  final List<Product> _cart = [];
  double get _totalPrice => _cart.fold(0, (s, p) => s + p.price);

  void _addToCart(Product p) => setState(() => _cart.add(p));

  /* 新增：减少 / 移除 */
  void _removeFromCart(Product p) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.name == p.name);
      if (idx != -1) _cart.removeAt(idx);
    });
  }

  void _clearCart() => setState(() => _cart.clear());

  @override
  Widget build(BuildContext context) {
    final pages = [
      ShopPage(
        products: _products,
        cart: _cart,
        onAdd: _addToCart,
        onRemove: _removeFromCart, // 传递删除回调
        totalPrice: _totalPrice,
      ),
      CartPage(
        cart: _cart,
        totalPrice: _totalPrice,
        onRemove: _removeFromCart, // 传递删除回调
        onClear: _clearCart,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration:
                      const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/* ─── 商店页 ─── */
class ShopPage extends StatelessWidget {
  final List<Product> products;
  final List<Product> cart;
  final void Function(Product) onAdd;
  final void Function(Product) onRemove; // 新增
  final double totalPrice;

  const ShopPage({
    required this.products,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.totalPrice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mobile Shop',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Total: ¥${totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/image_6.png',
                    width: double.infinity, fit: BoxFit.fitWidth),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                  final p = products[i];
                  final count = cart.where((e) => e.name == p.name).length;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailPage(product: p, onAdd: onAdd),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(p.imageAsset, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(p.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('¥${p.price.toStringAsFixed(2)}'),
                          ],
                        ),
                        // 加号
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon:
                              const Icon(Icons.add, size: 16, color: Colors.white),
                              onPressed: () => onAdd(p),
                            ),
                          ),
                        ),
                        // 减号
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey.shade400,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.remove,
                                  size: 16, color: Colors.white),
                              onPressed: () => onRemove(p),
                            ),
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text('$count',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ─── 购物车页 ─── */
class CartPage extends StatelessWidget {
  final List<Product> cart;
  final double totalPrice;
  final VoidCallback onClear;
  final void Function(Product) onRemove; // 新增

  const CartPage({
    required this.cart,
    required this.totalPrice,
    required this.onClear,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {};
    for (var p in cart) {
      counts[p.name] = (counts[p.name] ?? 0) + 1;
    }

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text('Your Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: counts.entries.map((e) {
                final product = cart.firstWhere((p) => p.name == e.key);
                return ListTile(
                  leading: Image.asset(product.imageAsset,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle:
                  Text('¥${product.price.toStringAsFixed(2)} × ${e.value}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => onRemove(product),
                      ),
                      Text(
                        '¥${(product.price * e.value).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ¥${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: onClear,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ─── 商品详情页（仅加号） ─── */
class ProductDetailPage extends StatelessWidget {
  final Product product;
  final void Function(Product) onAdd;
  const ProductDetailPage({required this.product, required this.onAdd, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(product.imageAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Price: ¥${product.price.toStringAsFixed(2)}',
                    style:
                    const TextStyle(fontSize: 18, color: Colors.orange)),
                const SizedBox(height: 4),
                Text('Sales: ${product.sales}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                const Text('Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: () {
            onAdd(product);
            Navigator.pop(context);
          },
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}

/* ─── Profile 占位页 ─── */
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}

/* ─── 商品模型 ─── */
class Product {
  final String name;
  final double price;
  final String imageAsset;
  final int sales;
  final String description;
  Product({
    required this.name,
    required this.price,
    required this.imageAsset,
    required this.sales,
    required this.description,
  });
}
