import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Organizer"),
        backgroundColor: Colors.green.shade600,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Приветственное сообщение
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Welcome to your workout organizer!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Список или сетка с элементами (Workout)
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: screenWidth < 600
                      ? ListView(
                          shrinkWrap: true,
                          children: List.generate(
                            10,
                            (index) => Card(
                              child: ListTile(
                                title: Text('Workout ${index + 1}'),
                                subtitle: Text('Details for workout ${index + 1}'),
                                onTap: () {
                                  // Действие при нажатии
                                },
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) => Card(
                            child: GridTile(
                              child: Center(
                                child: Text('Workout ${index + 1}'),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
