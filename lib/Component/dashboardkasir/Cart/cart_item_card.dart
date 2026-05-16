import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';

class CartItemCard extends StatelessWidget {

  final CartItem item;

  final VoidCallback onAdd;

  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(

        children: [

          ClipRRect(

            borderRadius:
                BorderRadius.circular(12),

            child: Image.network(
              item.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Rp ${item.price}",
                  style: const TextStyle(
                    color: Color(0xFFD97706),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Row(

            children: [

              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
              ),

              Text(item.qty.toString()),

              IconButton(
                onPressed: onAdd,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}