import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/controllers/reports_controller.dart';
import 'package:green_leaf/modules/admin/views/bills_screen.dart';
import 'package:green_leaf/modules/admin/views/feedback_screen.dart';

class ManageReportsScreen extends StatefulWidget {
  const ManageReportsScreen({super.key});

  @override
  State<ManageReportsScreen> createState() => _ManageReportsScreenState();
}

class _ManageReportsScreenState extends State<ManageReportsScreen> {
  int totalOrders = 0;
  double totalRevenue = 0.0;
  int totalFeedbacks = 0;

  bool isLoading = true;

  final ReportsController _reportsController = ReportsController();

  @override
  void initState() {
    super.initState();
    _loadReports();
    _loadRevenue();
    _loadFeedbackCount();
  }

  Future<void> _loadRevenue() async {
    final revenue = await _reportsController.getTotalRevenue(context);
    setState(() {
      totalRevenue = revenue;
      isLoading = false;
    });
  }

  Future<void> _loadReports() async {
    final count = await _reportsController.getTotalOrdersCount(context);
    setState(() {
      totalOrders = count;
      isLoading = false;
    });
  }

  Future<void> _loadFeedbackCount() async {
    final count = await _reportsController.getTotalFeedbacksCount(context);
    setState(() {
      totalFeedbacks = count;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: Text(
          "Manage Reports",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),

      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 170,
                padding: EdgeInsets.all(12),
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "$totalOrders",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 60,
                              letterSpacing: 2,
                              color: Color(0XFF456B2E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    Spacer(),
                    Text(
                      "Total Products Sold",
                      textAlign: TextAlign.center,

                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF456B2E),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                height: 190,
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                totalRevenue.toStringAsFixed(0), // e.g. 125.6

                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  letterSpacing: 2,
                                  color: Color(0XFF456B2E),
                                  fontSize: 60,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        Text(
                          "OMR",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            letterSpacing: 2,
                            color: Color(0XFF456B2E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      "Total Revenue",
                      textAlign: TextAlign.center,

                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF456B2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return AllFeedbackScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  width: 170,
                  padding: EdgeInsets.all(12),
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      isLoading
                          ? CircularProgressIndicator()
                          : Text(
                        "$totalFeedbacks",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 60,
                                letterSpacing: 2,
                                color: Color(0XFF456B2E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      Spacer(),
                      Text(
                        "All Feedback's",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF456B2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return BillScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  height: 190,
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      isLoading
                          ? CircularProgressIndicator()
                          : Text(
                          "$totalOrders",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                letterSpacing: 2,
                                color: Color(0XFF456B2E),
                                fontSize: 60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      Spacer(),
                      Text(
                        "Invoices/Bills",
                        textAlign: TextAlign.center,

                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF456B2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
