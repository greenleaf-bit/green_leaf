import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/user_product_controller.dart';
import 'package:green_leaf/modules/user/views/product_detail.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserProductController _productController = UserProductController();
  final TextEditingController _controller = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String searchQuery = "";
  String userName = ""; // <-- yahan store hoga firebase se name

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    fetchUserName();
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          debugPrint('Status: $val');
          // 🟢 Listen start hua to mic red
          if (val == 'listening') {
            setState(() => _isListening = true);
          }
          // 🔴 Stop hone pe mic grey
          else if (val == 'notListening' || val == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) {
          debugPrint('Error: $val');
          setState(() => _isListening = false);
        },
      );

      if (available) {
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
              searchQuery = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }


  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userName = doc["fullname"] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/name_icon.png",
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    "Hey $userName",
                    style: GoogleFonts.lexend(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF336105),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Let’s find your plants!",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFF325A3E),
                ),
              ),
              const SizedBox(height: 20),

              /// 🔎 Search bar
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: SearchBar(
                  controller: _controller,
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                      onPressed: _listen,
                    ),
                  ],                  hintText: "Search plants",
                  hintStyle: WidgetStateProperty.all(
                    GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF999898),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              /// 📦 Products Grid
              StreamBuilder<QuerySnapshot>(
                stream: _productController.getProductsBySearch(
                  search: searchQuery,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemBuilder: (context, index) {
                      final doc = products[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productId: doc.id,
                                data: data,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 155,
                          height: 163,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              data['imageUrl'] != null
                                  ? Image.network(
                                      data["imageUrl"],
                                      width: 85,
                                      height: 110,
                                    )
                                  : const Icon(
                                      Icons.image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                              const SizedBox(height: 5),
                              Text(
                                data["name"] ?? "No Name",
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0XFF325A3E),
                                ),
                              ),
                              Text(
                                "${data["price"] ?? 0} OMR",
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0XFF325A3E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
