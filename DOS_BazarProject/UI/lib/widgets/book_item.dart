import 'package:bazar/models/book.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/views/book_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookItem extends StatelessWidget {
  // void selectMeal(BuildContext context) {
  //   Navigator.of(context)
  //       .pushNamed(
  //     BookDetailView.routeName,
  //     arguments: id,
  //   )
  //       .then((resualt) {
  //     if (resualt != null) {
  //       // remveItem(resualt);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Book>(context, listen: false);
    final size = MediaQuery.of(context).size;
    // print(book.name);

    return Consumer<Book>(
      builder: (ctx, bookCon, child) => InkWell(
        onTap: () {
          Navigator.of(ctx)
              .pushNamed(BookDetailView.routeName, arguments: bookCon.id);
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/book-cover.jpg',
                      fit: BoxFit.cover,
                      height: size.height / 4.5,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      width: 300,
                      child: Text(
                        book.name,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      width: 300,
                      color: Colors.black54,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            book.topic,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on),
                          const SizedBox(width: 3),
                          Text('${book.price} \$'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(Icons.storage_rounded),
                          const SizedBox(width: 6),
                          Text('${book.countInStock} In Stock'),
                        ],
                      ),
                      // const SizedBox(width: 10),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.category_rounded),
                      //     const SizedBox(width: 6),
                      //     Text('${book.topic} '),
                      //   ],
                      // ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

//     return Consumer<Book>(
//       builder: (ctx, book, child) => FutureBuilder(
//           future: Provider.of<Books>(ctx, listen: false).findById(book.id),
//           builder: (cx, snap) {
//             return InkWell(
//               onTap: () {
//                 Navigator.of(cx).pushReplacementNamed(
//                   BookDetailView.routeName,
//                 );
//               },
//               child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 4,
//                   margin: const EdgeInsets.all(15),
//                   child: Column(
//                     children: [
//                       Stack(children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15),
//                           ),
//                           child: Image.network(
//                             'assets/book-cover.jpg',
//                             fit: BoxFit.cover,
//                             height: size.height / 4.5,
//                             width: double.infinity,
//                           ),
//                         ),
//                         Positioned(
//                           top: 15,
//                           left: 5,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 5,
//                               horizontal: 20,
//                             ),
//                             width: 300,
//                             child: Text(
//                               book.name,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 color: Colors.white,
//                               ),
//                               softWrap: true,
//                               overflow: TextOverflow.fade,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 5,
//                               horizontal: 20,
//                             ),
//                             width: 300,
//                             color: Colors.black54,
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.category,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   book.topic,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                   ),
//                                   softWrap: true,
//                                   overflow: TextOverflow.fade,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ]),
//                       SizedBox(
//                         height: 40,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.monetization_on),
//                                 const SizedBox(width: 3),
//                                 Text('${book.price} \$'),
//                               ],
//                             ),
//                             const SizedBox(width: 10),
//                             Row(
//                               children: [
//                                 const Icon(Icons.storage_rounded),
//                                 const SizedBox(width: 6),
//                                 Text('${book.countInStock} In Stock'),
//                               ],
//                             ),
//                             // const SizedBox(width: 10),
//                             // Row(
//                             //   children: [
//                             //     const Icon(Icons.category_rounded),
//                             //     const SizedBox(width: 6),
//                             //     Text('${book.topic} '),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       )
//                     ],
//                   )),
//             );
//           }),
//     );
//   }
// }

/*
child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.network(
                            'assets/book-cover.jpg',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        color: Colors.black54,
                        child: Positioned(
                          child: Text(
                            book.name,
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                */
