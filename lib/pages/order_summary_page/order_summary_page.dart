import 'package:flutter/material.dart';
import '../../repositories/order_repository.dart';
import '../../models/order.dart';
import './page_1.dart';
import './page_2.dart';

var orderRepository = OrderRepository();

MaterialPageRoute createOrderSummaryRoute(BuildContext context, int orderId) {
  return OrderSummaryPageRoute(builder: (context) => OrderSummaryPage(title: "Resumo da conta", orderId: orderId));
}

class OrderSummaryPageRoute extends MaterialPageRoute<void> {
  OrderSummaryPageRoute({required super.builder});
}

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage({ required this.title, required this.orderId });

  final String title;
  final int orderId;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState(orderId);
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  _OrderSummaryPageState(this.orderId) {
    order = orderRepository.get(orderId) ?? Order();
  }

  final int orderId;
  late Order order;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {

    var pages = [createPage1(context, order), createPage2(context, order)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Resumo da comanda")
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: pages
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.black87 : Colors.black54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
