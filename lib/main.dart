import 'package:flutter/material.dart';

void main() {
  runApp(ScoreCalculatorApp());
}

class ScoreCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'American Domino Calculator',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: ScoreHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScoreHomePage extends StatefulWidget {
  @override
  _ScoreHomePageState createState() => _ScoreHomePageState();
}

class _ScoreHomePageState extends State<ScoreHomePage> {
  int lanaScore = 0;
  int lahoomScore = 0;
  int lanaWins = 0;
  int lahoomWins = 0;

  final TextEditingController _lanaController = TextEditingController();
  final TextEditingController _lahoomController = TextEditingController();

  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _lanaController.addListener(() => setState(() {}));
    _lahoomController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _lanaController.dispose();
    _lahoomController.dispose();
    super.dispose();
  }

  void addScores() {
    int lana = int.tryParse(_lanaController.text) ?? 0;
    int lahoom = int.tryParse(_lahoomController.text) ?? 0;

    setState(() {
      lanaScore += lana;
      lahoomScore += lahoom;

      if (lana != 0) {
        history.add({'team': 'لنا', 'score': lana});
      }
      if (lahoom != 0) {
        history.add({'team': 'لهم', 'score': lahoom});
      }

      _lanaController.clear();
      _lahoomController.clear();
    });
  }

  void undoLastAction() {
    if (history.isNotEmpty) {
      final last = history.removeLast();
      setState(() {
        if (last['team'] == 'لنا') {
          lanaScore -= last['score'] as int;
        } else if (last['team'] == 'لهم') {
          lahoomScore -= last['score'] as int;
        }
      });
    }
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'تأكيد الإنهاء',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من إنهاء الجولة؟',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              String message = '';
              if (lanaScore > lahoomScore) {
                lanaWins += 1;
                message = 'الفريق الفائز: لنا 🎉';
              } else if (lahoomScore > lanaScore) {
                lahoomWins += 1;
                message = 'الفريق الفائز: لهم 🎉';
              } else {
                message = 'تعادل بين الفريقين 🤝';
              }

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: Text(
                    'النتيجة النهائية',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          lanaScore = 0;
                          lahoomScore = 0;
                          history.clear();
                          _lanaController.clear();
                          _lahoomController.clear();
                        });
                      },
                      child: Text('حسناً', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            },
            child: Text('تأكيد', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget buildScoreCircle(String team, int score, int wins) {
    final silverColor = Color(0xFFC0C0C0);
    return Column(
      children: [
        Text(
          '$team (فوز: $wins)',
          style: TextStyle(fontSize: 18, color: silverColor),
        ),
        SizedBox(height: 8),
        CircleAvatar(
          radius: 45,
          backgroundColor: silverColor.withOpacity(0.2),
          child: Text(
            '$score',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: silverColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Image.asset(
                'assets/new_icon.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                'A  D  C',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildScoreCircle('لنا', lanaScore, lanaWins),
                  buildScoreCircle('لهم', lahoomScore, lahoomWins),
                ],
              ),
              SizedBox(height: 20),

              Card(
                color: Colors.grey[900],
                elevation: 4,
                shadowColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _lanaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: _lanaController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: 'نقاط لنا',
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.white70),
                                  onPressed: () {
                                    setState(() {
                                      if (_lanaController.text.startsWith('-')) {
                                        _lanaController.text =
                                            _lanaController.text.replaceFirst('-', '');
                                      } else {
                                        _lanaController.text = '-${_lanaController.text}';
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _lahoomController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: _lahoomController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: 'نقاط لهم',
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.white70),
                                  onPressed: () {
                                    setState(() {
                                      if (_lahoomController.text.startsWith('-')) {
                                        _lahoomController.text =
                                            _lahoomController.text.replaceFirst('-', '');
                                      } else {
                                        _lahoomController.text = '-${_lahoomController.text}';
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: addScores,
                              child: Text('إضافة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: showWinnerDialog,
                              child: Text('انتهاء'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            onPressed: undoLastAction,
                            icon: Icon(Icons.undo, color: Colors.white),
                            tooltip: 'تراجع',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        'سجل النقاط',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Divider(color: Colors.grey.shade700),
                      Expanded(
                        child: ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final entry = history[history.length - 1 - index];
                            return ListTile(
                              leading: Text(
                                entry['team'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              trailing: Text(
                                '${entry['score'] > 0 ? "+" : ""}${entry['score']}',
                                style: TextStyle(
                                  color: entry['score'] >= 0
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
