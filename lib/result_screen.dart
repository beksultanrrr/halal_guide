// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:halal_guide/haram_page_des.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  List halalProducts = [
    "Albeni",
  ];
  List haramProduct = ["VODKA", "skittles", "e120", "beer", "alcohol"];

  String check(text) {
    text = text.toLowerCase();
    List<String> list = text.split(RegExp(r'[\s.,;:]+'));

    final setHalal = halalProducts.toSet();
    final setHaram = haramProduct.toSet();

    final set2 = list.toSet();
    final intersectionHalal = setHalal.intersection(set2);
    final interesctionHaram = setHaram.intersection(set2);
    print(set2);
    print(interesctionHaram);
    if (interesctionHaram.isNotEmpty) {
      return "Haram";
    } else if (intersectionHalal.isNotEmpty && interesctionHaram.isEmpty) {
      return "Halal";
    } else {
      return "Uknown";
    }
  }

  Set getHaramProducts(text) {
    text = text.toLowerCase();
    List<String> list = text.split(RegExp(r'[\s.,;:]+'));

    final setHaram = haramProduct.toSet();

    final set2 = list.toSet();

    final interesctionHaram = setHaram.intersection(set2);
    return interesctionHaram;
  }

  @override
  Widget build(BuildContext context) {
    print("ZZZZZZZZZZ ${check(text)}");
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: check(text) == "Halal"
                    ? Column(
                        children: [
                          Lottie.network(
                              "https://assets8.lottiefiles.com/packages/lf20_vuliyhde.json",
                              width: 300,
                              height: 300),
                          const Text(
                            "Этот продукт является халяльным.",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )
                    : check(text) == "Haram"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.network(
                                "https://assets5.lottiefiles.com/packages/lf20_qpwbiyxf.json",
                                width: 100,
                                height: 100,
                              ),
                              const Text(
                                "This product is haram. ",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "It contains:",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i in getHaramProducts(text).toList())
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HaramDes(
                                              image:
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjprYhKm_RDQr8J-opQeXAJibH2K_FwqDxNw&usqp=CAU",
                                              name: i,
                                              description:
                                                  "E120 is considered haram (forbidden) in Islamic dietary guidelines because it is derived from insects. E120, also known as cochineal extract or carmine, is a red food coloring obtained from the dried bodies of female cochineal insects. These insects are commonly found on cacti in certain regions.Islamic dietary laws, specifically halal guidelines, prohibit the consumption of insects. Therefore, any food or product containing E120 would be considered haram for Muslims. It's important to note that the classification of food additives and ingredients as halal or haram may vary based on different interpretations and cultural practices. It is advisable for individuals seeking halal products to consult reliable sources and certification organizations that adhere to their specific dietary requirements.",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        i,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Lottie.network(
                                  "https://assets2.lottiefiles.com/packages/lf20_dmw3t0vg.json",
                                  width: 300,
                                  height: 300),
                              const Text(
                                "Не могу определить. Попробуйте еще раз...",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ))));
  }
}
