// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  List halalProducts = [
    "Albeni",
  ];
  List haramProduct = ["VODKA"];
  String check(text) {
    List<String> list = text.split(RegExp(r'[\s.,;:]+'));
    final setHalal = halalProducts.toSet();
    final setHaram = haramProduct.toSet();
    print(text);
    final set2 = list.toSet();
    final intersectionHalal = setHalal.intersection(set2);
    final interesctionHaram = setHaram.intersection(set2);
    print(interesctionHaram);
    print(intersectionHalal);
    if (interesctionHaram.isNotEmpty) {
      return "Haram";
    } else if (intersectionHalal.isNotEmpty && interesctionHaram.isEmpty) {
      return "Halal";
    } else {
      return "Uknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Логика для совместимости списков
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
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
                            children: [
                              Lottie.network(
                                  "https://assets5.lottiefiles.com/packages/lf20_qpwbiyxf.json",
                                  width: 300,
                                  height: 300),
                              const Text(
                                "Этот продукт является харам (недозволенным).",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                                textAlign: TextAlign.center,
                              )
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
