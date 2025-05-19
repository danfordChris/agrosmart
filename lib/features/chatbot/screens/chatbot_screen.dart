import 'package:flutter/material.dart';
import 'dart:async';

class AgriChatbotScreen extends StatefulWidget {
  const AgriChatbotScreen({super.key});

  @override
  State<AgriChatbotScreen> createState() => _AgriChatbotScreenState();
}

class _AgriChatbotScreenState extends State<AgriChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<UjumbeWaMazungumzo> _messages = [];
  bool _isTyping = false;

  // Mapendekezo ya awali kwa watumiaji
  final List<String> _mapendekezo = [
    "Namna ya kukabiliana na wadudu wa mazao?",
    "Mbolea bora kwa nyanya?",
    "Mahindi yanahitaji maji kiasi gani?",
    "Muda wa kuvuna ngano?",
    "Namna ya kuboresha ubora wa udongo?",
    "Ushauri kuhusu kilimo hai",
  ];

  @override
  void initState() {
    super.initState();
    // Ongeza ujumbe wa karibu
    _ongezaUjumbe(
      "Habari! Mimi ni AgroMsaidizi wako. Niulize maswali yoyote kuhusu kilimo, mazao, au mazoea ya kilimo. Ninaweza kukusaidiaje leo?",
      false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    // Ongeza ujumbe wa mtumiaji
    _ongezaUjumbe(text, true);

    // Weka kiashiria cha kuandika
    setState(() {
      _isTyping = true;
    });

    // Simulate response delay
    Timer(const Duration(milliseconds: 1200), () {
      _pataJibuLaBoti(text);
    });
  }

  void _pataJibuLaBoti(String swali) {
    String jibu = _tengenezaJibu(swali);

    setState(() {
      _isTyping = false;
      _ongezaUjumbe(jibu, false);
    });

    // Scroll to bottom after response
    _scrollToBottom();
  }

  String _tengenezaJibu(String swali) {
    // Hii ingebadilishwa na mfano wa AI/ML au API halisi
    swali = swali.toLowerCase();

    if (swali.contains('wadudu') || swali.contains('mdudu')) {
      return "Kwa usimamizi wa wadudu, napendekeza mbinu zifuatazo:\n\n"
          "1. Tambua aina ya mdudu kwanza - wadudu tofauti huhitaji matibabu tofauti\n"
          "2. Fikiria wadudu wafaidisi kama vile mibwani kabla ya kutumia dawa za kemikali\n"
          "3. Kwa udhibiti wa kilimo hai, jaribu mafuta ya mwarobaini au sabuni ya wadudu\n"
          "4. Tumia dawa za kemikali tu kama mwisho wa mwisho na kufuata maagizo kwa makini\n\n"
          "Je, ungependa ushauri maalum kuhusu mazao au wadudu fulani?";
    } else if (swali.contains('maji') || swali.contains('umwagiliaji')) {
      return "Umwagiliaji sahihi ni muhimu kwa afya ya mazao. Kwa ujumla:\n\n"
          "• Umwagilia maji kwa kina lakini mara chache ili kuhimiza ukuaji wa mizizi\n"
          "• Asubuhi ni wakati bora wa kumwagilia ili kupunguza uvukizi na magonjwa\n"
          "• Fikiria umwagiliaji wa tone kwa kuokoa maji\n"
          "• Kwa mazao mengi, toa inchi 1-1.5 ya maji kwa wiki pamoja na mvua\n\n"
          "Mazao tofauti yana mahitaji tofauti ya maji. Unalima mazao gani?";
    } else if (swali.contains('mbolea') || swali.contains('virutubisho')) {
      return "Mapendekezo ya mbolea yanategemea udongo wako na mahitaji ya mazao:\n\n"
          "• Fanya uchunguzi wa udongo kabla ya kutumia mbolea\n"
          "• Nitrojeni (N) inahimiza ukuaji wa majani\n"
          "• Fosforasi (P) inasaidia ukuaji wa mizizi na maua\n"
          "• Potasiamu (K) inaboresha afya ya mmea na kinga dhidi ya magonjwa\n\n"
          "Chaguo za kilimo hai ni pamoja na mboji, mavi ya wanyama, na mzunguko wa mazao.";
    } else if (swali.contains('udongo') || swali.contains('ardhi')) {
      return "Udongo wenye afya ni msingi wa kilimo bora. Ili kuboresha ubora wa udongo:\n\n"
          "• Ongeza mboji mara kwa mara\n"
          "• Fanya mzunguko wa mazao ili kuzuia upungufu wa virutubisho\n"
          "• Fikiria mazao ya kifuniko wakati wa msimu wa mapumziko\n"
          "• Punguza kulima ili kuhifadhi muundo wa udongo\n"
          "• Weka viwango sahihi vya pH (mazao mengi wanapendelea 6.0-7.0)\n\n"
          "Je, ungependa maelezo kuhusu kuchunguza udongo wako?";
    } else if (swali.contains('kilimo hai') || swali.contains('asilia')) {
      return "Kilimo hai kulenga mbinu endelevu bila kemikali za sintetiki. Mbinu muhimu ni pamoja na:\n\n"
          "• Kuimarisha afya ya udongo kupitia mboji na mavi ya kijani\n"
          "• Kutumia mbinu za udhibiti wa wadudu kwa kibiolojia\n"
          "• Kutekeleza mzunguko wa mazao na mazao mengi pamoja\n"
          "• Kutumia mbolea asilia kama chai ya mboji na emulshioni ya samaki\n"
          "• Kuunda makazi ya wadudu wafaidisi\n\n"
          "Kupata uthibitisho wa kilimo hai kunahitaji kukidhi viwango maalum na kipindi cha mpito.";
    } else if (swali.contains('vuna') || swali.contains('mavuno')) {
      return "Kuvuna kwa wakati sahihi kunahimiza mavuno na ubora. Vidokezo vya jumla:\n\n"
          "• Kuvuna asubuhi mara nyingi ni bora kwa mazao mengi\n"
          "• Angalia viashiria maalum vya ukomaa (rangi, ukubwa, muundo)\n"
          "• Shughulikia mazao kwa uangalifu ili kuepuka kuharibika\n"
          "• Kwa mazao ya hifadhi, yalazwe vizuri kabla ya kuhifadhi\n\n"
          "Unataka kuvuna mazao gani hasa?";
    } else if (swali.contains('habari') ||
        swali.contains('hujambo') ||
        swali.contains('salamu')) {
      return "Habari! Mimi ni msaidizi wako wa kilimo. Ninaweza kukusaidia kwa maswali yoyote kuhusu kilimo, mazao, usimamizi wa udongo, udhibiti wa wadudu, na mengineyo. Je, ungependa kujua nini leo?";
    } else {
      return "Asante kwa swali lako kuhusu '$swali'. Ingawa ninaendelea kujifunza kuhusu kilimo, ningehitaji maelezo zaidi ili kutoa jibu sahihi zaidi. Je, unaweza kuniambia zaidi kuhusu mazao yako maalum, eneo lako la kilimo, au chango unalokumbana nalo?";
    }
  }

  void _ongezaUjumbe(String maandishi, bool niMtumiaji) {
    setState(() {
      _messages.add(
        UjumbeWaMazungumzo(
            maandishi: maandishi,
            niMtumiaji: niMtumiaji,
            muda: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Tumia mchepuko mfupi kuhakikisha orodha imesasishwa
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('AgroMsaidizi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _onyeshaKidirishaChaMaelezo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _jengaHaliTupu()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        // Onyesha kiashiria cha kuandika
                        return const BubbuliYaMazungumzo(
                          maandishi: 'Anaandika...',
                          niMtumiaji: false,
                          anaandika: true,
                        );
                      }
                      return BubbuliYaMazungumzo(
                        maandishi: _messages[index].maandishi,
                        niMtumiaji: _messages[index].niMtumiaji,
                        anaandika: false,
                      );
                    },
                  ),
          ),
          // Vipande vya mapendekezo
          if (_messages.length < 3)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: _mapendekezo.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade200),
                      label: Text(_mapendekezo[index]),
                      onPressed: () {
                        _handleSubmitted(_mapendekezo[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          // Sehemu ya kuingiza
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: Colors.green.shade700,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Uchambuzi wa picha ya mimea unakuja hivi karibuni!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Uliza kuhusu kilimo, mazao, au wadudu...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: Colors.green.shade700),
                  onPressed: () => _handleSubmitted(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jengaHaliTupu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, size: 80, color: Colors.green.shade200),
          const SizedBox(height: 16),
          Text(
            'Msaidizi Wako wa Kilimo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Niulize chochote kuhusu kilimo, mazao, na mazoea ya kilimo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _onyeshaKidirishaChaMaelezo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.agriculture, color: Colors.green.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Kuhusu AgroMsaidizi',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Msaidizi hutoa mwongozo kuhusu:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            NuktaYaOda('Uchaguzi na usimamizi wa mazao'),
            NuktaYaOda('Udhibiti wa wadudu na magonjwa'),
            NuktaYaOda('Afya ya udongo na utumiaji wa mbolea'),
            NuktaYaOda('Mbinu za umwagiliaji'),
            NuktaYaOda('Mbinu endelevu za kilimo'),
            SizedBox(height: 12),
            Text(
              'Ingawa tunajitahidi kutoa taarifa sahihi, tafadhali shauriana na wataalam wa kilimo wa eneo lako kwa ushauri maalum wa eneo lako na hali zake.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Funga',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class NuktaYaOda extends StatelessWidget {
  final String maandishi;

  const NuktaYaOda(this.maandishi, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(maandishi)),
        ],
      ),
    );
  }
}

class UjumbeWaMazungumzo {
  final String maandishi;
  final bool niMtumiaji;
  final DateTime muda;

  UjumbeWaMazungumzo({
    required this.maandishi,
    required this.niMtumiaji,
    required this.muda,
  });
}

class BubbuliYaMazungumzo extends StatefulWidget {
  final String maandishi;
  final bool niMtumiaji;
  final bool anaandika;

  const BubbuliYaMazungumzo({
    super.key,
    required this.maandishi,
    required this.niMtumiaji,
    required this.anaandika,
  });

  @override
  State<BubbuliYaMazungumzo> createState() => _BubbuliYaMazungumzoState();
}

class _BubbuliYaMazungumzoState extends State<BubbuliYaMazungumzo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            widget.niMtumiaji ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.niMtumiaji) ...[
            CircleAvatar(
              backgroundColor: Colors.green.shade700,
              child: const Icon(
                Icons.agriculture,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: widget.niMtumiaji
                    ? Colors.blue.shade100
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.niMtumiaji
                      ? Colors.blue.shade200
                      : Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: widget.anaandika
                  ? SizedBox(
                      width: 50,
                      child: Row(
                        children: [_jengaDoti(1), _jengaDoti(2), _jengaDoti(3)],
                      ),
                    )
                  : Text(
                      widget.maandishi,
                      style: TextStyle(
                        color: widget.niMtumiaji ? Colors.black87 : Colors.black87,
                      ),
                    ),
            ),
          ),
          if (widget.niMtumiaji) const SizedBox(width: 8),
          if (widget.niMtumiaji)
            CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _jengaDoti(int index) {
    return Expanded(
      child: Center(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index - 1) * 0.3,
              index * 0.3,
              curve: Curves.easeIn,
            ),
          ),
          builder: (context, child) {
            return Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.green.shade700.withOpacity(_controller.value),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}