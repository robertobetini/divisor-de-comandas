import 'package:divisao_contas/factories/order_pdf_factory.dart';
import 'package:divisao_contas/factories/page_indicator_factory.dart';
import 'package:divisao_contas/pages/order_summary_page/pdf_preview_page.dart';
import 'package:flutter/material.dart';
import '../../repositories/order_repository.dart';
import '../../models/order.dart';
import '../../themes.dart';
import './page_1.dart';
import './page_2.dart';

final orderRepository = OrderRepository();

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
          PageIndicatorFactory.create(pages.length, _currentPage)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var orderPdfFactory = OrderPdfFactory(currentTheme);
          var pdf = orderPdfFactory.create(order);
          var route = createPdfPreviewRoute(context, pdf);
          Navigator.push(context, route);
        },
        child: Icon(Icons.picture_as_pdf)
      )
    );
  }
}
