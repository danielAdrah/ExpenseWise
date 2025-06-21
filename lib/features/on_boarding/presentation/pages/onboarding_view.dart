import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/components/custom_button.dart';

import '../widgets/on_boarding_design.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: pages.length,
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                //that means we are in the last page
                isLastPage = (index == 2);
              });
            },
            itemBuilder: ((context, index) {
              return Container(
                // color: Colors.grey.withOpacity(0.1),
                child: Column(children: [
                  const SizedBox(
                    height: 200,
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: SvgPicture.asset(
                          pages[index].image!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ZoomIn(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      pages[index].title!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontFamily: "Arvo",
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ZoomIn(
                    delay: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        pages[index].body!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }),
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: isLastPage
                ? ZoomIn(
                    delay: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: 240,
                      height: 40,
                      child: CustomButton(
                        title: "Get Started",
                        onPressed: () {
                          // Navigate to the sign up page
                          context.go('/'); // Go to root which will show AuthGate
                        },
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text("Next",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

