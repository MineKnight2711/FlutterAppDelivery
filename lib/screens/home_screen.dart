import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:trasua_delivery/widgets/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 120;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: SliverAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              return SliverAppBar(
                expandedHeight: 200,
                floating: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedOpacity(
                    opacity: 0,
                    duration: const Duration(milliseconds: 1000),
                    curve: const Cubic(0.2, 0.0, 0.0, 1.0),
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Hero(
                              tag: "searchTextField",
                              child: Material(
                                type: MaterialType.transparency,
                                child: RoundTextfield(
                                  onTap: () {},
                                  icon: const Icon(Icons.search),
                                  hintText: "Tìm kiếm",
                                  controller: _controller,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Food",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: SlideAction(
        text: "Sẵn sàng nhận đơn",
        onSubmit: () {},
        sliderRotate: false,
        elevation: 24,
      ),
    );
  }
}
