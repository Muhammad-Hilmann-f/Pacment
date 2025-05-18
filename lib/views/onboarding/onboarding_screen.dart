import 'package:flutter/material.dart';
import '../../services/onboarding_data.dart';
import '../../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1B38),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // PageView with flexible height
                SizedBox(
                  height: screenHeight * 0.75, // Takes 75% of screen height
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (_, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, // 5% padding on sides
                      ),
                      child: OnboardingPage(model: onboardingData[index]),
                    ),
                  ),
                ),
                
                // Indicators
                SizedBox(
                  height: screenHeight * 0.05, // 5% of screen height
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
                                ? Colors.white 
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Button section
                SizedBox(
                  height: screenHeight * 0.15, // 15% of screen height
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1, // 10% padding on sides
                      vertical: 16,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < onboardingData.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pushNamed(context, '/register');
                        }
                      },
                      child: Text(
                        _currentPage == onboardingData.length - 1 
                            ? "Get Started" 
                            : "Next",
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.white,
                          
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}