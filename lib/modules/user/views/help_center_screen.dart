import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Help Center",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0XFF476C2F),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Information",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF476C2F),
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Call Center",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "77007700",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "greenleaf@info.com",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Color(0XFF476C2F)),
              SizedBox(height: 30),
              Text(
                "Frequently Asked Question",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF476C2F),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What is GreenLeaf?",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "Lorem Ipsum. Neque porro quisquam est qui dolorem Lorem Ipsum. Neque porro quisquam est qui dolore mLorem Ipsum.Neque porro ",

                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF456B2E).withOpacity(0.86),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Color(0XFF476C2F).withOpacity(0.6)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What Does GreenLeaf Do?",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "Lorem Ipsum. Neque porro quisquam est qui dolorem Lorem Ipsum. Neque porro quisquam est qui dolore mLorem Ipsum.Neque porro ",

                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF456B2E).withOpacity(0.86),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Color(0XFF476C2F).withOpacity(0.6)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Why Should I Use GreenLeaf?",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "Lorem Ipsum. Neque porro quisquam est qui dolorem Lorem Ipsum. Neque porro quisquam est qui dolore mLorem Ipsum.Neque porro ",

                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF456B2E).withOpacity(0.86),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Color(0XFF476C2F).withOpacity(0.6)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "If I Placed an Order, How Long Does it Take to Receive the Order?",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    Text(
                      "Lorem Ipsum. Neque porro quisquam est qui dolorem Lorem Ipsum. Neque porro quisquam est qui dolore mLorem Ipsum.Neque porro ",

                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF456B2E).withOpacity(0.86),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Color(0XFF476C2F).withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
