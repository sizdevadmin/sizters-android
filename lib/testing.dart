import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [



          
          Text("one"),
          Text("one"),
          Text("one"),
          Text("one"),
    
  
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text("2rgerwgr"),
                Text("2wgrw"),
  
        
                Text("2"),
                Text("2"),
                Text("2"),
                Text("2"),
              ],
            ),
          )
      
        ],
      ),
    );
  }
}