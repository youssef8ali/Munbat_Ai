import 'package:flutter/material.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final List<Order> orders = [
    Order(
      id: '#1',
      date: '2024-02-05',
      status: 'Delivered',
      total: 250.0,
      items: [
        OrderItem(
          name: 'Paracetamol Medicine',
          quantity: 2,
          price: 50.0,
          type: 'medicine',
        ),
        OrderItem(
          name: 'Aloe Vera Plant',
          quantity: 1,
          price: 150.0,
          type: 'plant',
        ),
      ],
    ),
    Order(
      id: '#2',
      date: '2024-02-03',
      status: 'On the way',
      total: 180.0,
      items: [
        OrderItem(
          name: 'Vitamin D Medicine',
          quantity: 1,
          price: 80.0,
          type: 'medicine',
        ),
        OrderItem(
          name: 'Mint Plant',
          quantity: 2,
          price: 50.0,
          type: 'plant',
        ),
      ],
    ),
    Order(
      id: '#3',
      date: '2024-02-01',
      status: 'Processing',
      total: 320.0,
      items: [
        OrderItem(
          name: 'Omega 3 Medicine',
          quantity: 2,
          price: 120.0,
          type: 'medicine',
        ),
        OrderItem(
          name: 'Basil Plant',
          quantity: 1,
          price: 80.0,
          type: 'plant',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start ordering medicines and plants',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(order.date, style: TextStyle(color: Colors.grey[600])),
              const Divider(),

              ...order.items.take(2).map(
                    (item) => Row(
                      children: [
                        Icon(
                          item.type == 'medicine'
                              ? Icons.medication
                              : Icons.local_florist,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child:
                              Text('${item.name} × ${item.quantity}'),
                        ),
                        Text('${item.price * item.quantity} EGP'),
                      ],
                    ),
                  ),

              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${order.total} EGP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color txt;

    switch (status) {
      case 'Delivered':
        bg = Colors.green[100]!;
        txt = Colors.green[800]!;
        break;
      case 'On the way':
        bg = Colors.blue[100]!;
        txt = Colors.blue[800]!;
        break;
      case 'Processing':
        bg = Colors.orange[100]!;
        txt = Colors.orange[800]!;
        break;
      default:
        bg = Colors.grey[100]!;
        txt = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: txt, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Order Details ${order.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...order.items.map(
              (item) => ListTile(
                title: Text(item.name),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing:
                    Text('${item.price * item.quantity} EGP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String id;
  final String date;
  final String status;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String type;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.type,
  });
}