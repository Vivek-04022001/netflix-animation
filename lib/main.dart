import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AnimatedHeroWithinScreen());
  }
}

class AnimatedHeroWithinScreen extends StatefulWidget {
  const AnimatedHeroWithinScreen({super.key});

  @override
  State<AnimatedHeroWithinScreen> createState() =>
      _AnimatedHeroWithinScreenState();
}

class _AnimatedHeroWithinScreenState extends State<AnimatedHeroWithinScreen> {
  final GlobalKey _startKey = GlobalKey();
  final GlobalKey _endKey = GlobalKey();

  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;

  double _currentSize = 60.0;

  bool _isAnimating = false;
  bool _animationDone = false;

  void _startAnimation() async {
    final startBox = _startKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = _endKey.currentContext?.findRenderObject() as RenderBox?;

    if (startBox != null && endBox != null) {
      _startOffset = startBox.localToGlobal(Offset.zero);
      _endOffset = endBox.localToGlobal(Offset.zero);

      setState(() {
        _currentOffset = _startOffset;
        _currentSize = 60.0;
        _isAnimating = true;
        _animationDone = false;
      });

      await WidgetsBinding.instance.endOfFrame;

      setState(() {
        _currentOffset = _endOffset;
        _currentSize = 40.0;
      });
    }
  }

  void _resetAnimation() {
    setState(() {
      _isAnimating = false;
      _animationDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: _isAnimating || _animationDone ? 0.0 : 1.0,
                        child: Container(
                          key: _startKey,
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Use the new BottomNavBar class
                  BottomNavBar(endKey: _endKey, animationDone: _animationDone),
                ],
              ),
              // Floating moving icon
              if (_isAnimating)
                Positioned(
                  left: _startOffset.dx,
                  top: _startOffset.dy,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    width: _currentSize,
                    height: _currentSize,
                    transform: Matrix4.translationValues(
                      _currentOffset.dx - _startOffset.dx,
                      _currentOffset.dy - _startOffset.dy,
                      0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'N',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _currentSize * 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onEnd: () {
                      setState(() {
                        _isAnimating = false;
                        _animationDone = true;
                      });
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animationDone ? _resetAnimation : _startAnimation,
        child: Icon(_animationDone ? Icons.refresh : Icons.play_arrow),
      ),
    );
  }
}
