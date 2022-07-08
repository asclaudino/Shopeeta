import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductPricingWidget extends StatelessWidget {
  const ProductPricingWidget({
    Key? key,
    required this.rightSideBarWidth,
    required this.product,
  }) : super(key: key);

  final double rightSideBarWidth;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: rightSideBarWidth,
      //height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}",
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 30,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            width: rightSideBarWidth - 20,
            //height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: Colors.black,
                      size: 30,
                    ),
                    Text(
                      "Quer comprar?",
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Entre em contato com o vendedor por meio do seguinte endereço de email: ${product.sellerEmail}",
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: 'Este produto é vendido e entregue por ',
              style: const TextStyle(
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: product.seller,
                  style: const TextStyle(
                    //decoration: TextDecoration.italic,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const TextSpan(
                  text:
                      '. A Shopeeta não garante a sua compra, nem o pedido nem a entrega.',
                ),
                // can add more TextSpans here...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
