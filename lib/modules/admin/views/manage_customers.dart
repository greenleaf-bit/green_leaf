import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/controllers/customer_controller.dart';
import 'package:green_leaf/modules/admin/views/manage_customer_detail.dart';

class ManageCustomers extends StatefulWidget {
  const ManageCustomers({super.key});

  @override
  State<ManageCustomers> createState() => _ManageCustomersState();
}

class _ManageCustomersState extends State<ManageCustomers> {
  final CustomerController _customerController = CustomerController();
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final result = await _customerController.getAllUsers(context);
    setState(() {
      users = result;
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
          "Manage Customers",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    "CustomerID",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Name",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    "Email",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 110),
                  Text(
                    "Phone",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : users.isEmpty
                  ? const Center(child: Text("No Customers Found"))
                  : Padding(
                padding: const EdgeInsets.only(bottom: 70),
                    child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return InkWell(
                            onTap: () {
                              print("User Data: ${user}");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManageCustomerDetail(userData: user),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                color: Color(0XFFE8F5EE),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0XFF3B6C1E).withOpacity(0.6),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      "${user['id'] ?? '-'}",
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0XFF9D9999),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 47),
                                    Text(
                                      "${user['fullname'] ?? '-'}",
                                      overflow: TextOverflow.ellipsis,

                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0XFF9D9999),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Expanded(
                                      child: Text(
                                        "${user['email'] ?? '-'}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: const Color(0XFF9D9999),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 35),
                                    Text(
                                      "${user['phone'] ?? 'null'}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0XFF9D9999),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
