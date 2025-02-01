// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   context.go('/add_todo');
//                 },
//                 child: Text("Add Todo"))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the whole screen
        children: [
          // Background image widget
          Image.asset(
            'assets/images/todo_background.jpg', // Ensure this image exists in your assets folder
            fit: BoxFit.cover, // This will make the image cover the screen
          ),
          // Content on top of the background
          Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go('/add_todo');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurple, // Button background color
                        foregroundColor: Colors.amber, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12), // Button padding
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold), // Text style
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      child: const Text("Add Todo"),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
