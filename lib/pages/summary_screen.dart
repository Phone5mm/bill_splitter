import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryScreen extends StatelessWidget {
  final List<String> names;
  final List<Map<String, dynamic>> expenses;

  const SummaryScreen({Key? key, required this.names, required this.expenses})
    : super(key: key);

  Map<String, double> _calculateTotals() {
    final Map<String, double> totals = {for (var name in names) name: 0.0};
    for (var expense in expenses) {
      final name = expense['name'];
      final amount = expense['amount'];
      totals[name] = (totals[name] ?? 0) + amount;
    }
    return totals;
  }

  List<Map<String, dynamic>> _calculateSettlements(Map<String, double> totals) {
    final int peopleCount = names.length;
    final totalAmount = totals.values.fold(0.0, (a, b) => a + b);
    final equalShare = totalAmount / peopleCount;

    final Map<String, double> balances = {
      for (var name in names) name: (totals[name] ?? 0) - equalShare,
    };

    final List<Map<String, dynamic>> settlements = [];
    final creditors = <String, double>{};
    final debtors = <String, double>{};

    for (var entry in balances.entries) {
      if (entry.value > 0) {
        creditors[entry.key] = entry.value;
      } else if (entry.value < 0) {
        debtors[entry.key] = -entry.value;
      }
    }

    for (var debtor in debtors.entries) {
      String debtorName = debtor.key;
      double debtorAmount = debtor.value;

      for (var creditor in creditors.entries.toList()) {
        String creditorName = creditor.key;
        double creditorAmount = creditor.value;

        if (debtorAmount == 0) break;

        double minAmount = debtorAmount < creditorAmount
            ? debtorAmount
            : creditorAmount;

        if (minAmount > 0) {
          settlements.add({
            'from': debtorName,
            'to': creditorName,
            'amount': minAmount,
          });

          debtorAmount -= minAmount;
          creditors[creditorName] = creditorAmount - minAmount;
        }
      }
    }

    return settlements;
  }

  Widget _buildSectionTitle(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);
    final accentColor = Colors.teal.shade600;

    final totals = _calculateTotals();
    final settlements = _calculateSettlements(totals);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Summary',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.teal),
            tooltip: 'Start Over',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/names',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('What each person paid', accentColor),
            ...totals.entries.map(
              (entry) => Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: accentColor,
                    child: Text(
                      entry.key[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Text(
                    '\$${entry.value.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
            ),
            _buildSectionTitle('Settlement', accentColor),
            if (settlements.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '✅ Everyone is settled!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              )
            else
              ...settlements.map(
                (s) => Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      '${s['from']} ➜ ${s['to']}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      '\$${(s['amount'] as double).toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
              ),
            _buildSectionTitle('Original Transactions', accentColor),
            ...expenses.map(
              (e) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    '${e['name']} paid \$${(e['amount'] as double).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  subtitle:
                      e['description'] != null &&
                          (e['description'] as String).isNotEmpty
                      ? Text(
                          e['description'],
                          style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
