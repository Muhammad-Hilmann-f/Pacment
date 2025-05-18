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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B38),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (_, index) => OnboardingPage(model: onboardingData[index]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C6BC0),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                // TODO: navigate to dashboard or login
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                _currentPage == onboardingData.length - 1 ? "Get Started" : "Next",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
