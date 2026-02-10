import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_android/services/auth_service.dart';
import 'package:project_android/screens/auth/login_screen.dart';
import 'package:project_android/screens/home/transaction_screen.dart';
import 'package:project_android/screens/home/categories_screen.dart';
import 'package:project_android/screens/home/profile_screen.dart';

// Transaction Model
class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  String _userName = 'User';
  int _selectedNavIndex = 0;
  String _selectedPeriod = 'Monthly';

  // Financial Data
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _monthlyBudget = 20000.0;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFinancialData();
  }

  void _loadUserData() {
    final metadata = _authService.userMetadata;
    if (metadata != null && metadata['full_name'] != null) {
      setState(() {
        _userName = metadata['full_name'];
      });
    }
  }

  void _loadFinancialData() {
    // TODO: Load from Appwrite database
    // For now, using sample structure that user can edit
    setState(() {
      _transactions = [];
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double income = 0;
    double expenses = 0;

    for (var transaction in _transactions) {
      if (transaction.isIncome) {
        income += transaction.amount;
      } else {
        expenses += transaction.amount;
      }
    }

    setState(() {
      _totalIncome = income;
      _totalExpenses = expenses;
    });
  }

  void _showEditIncomeDialog() async {
    final controller = TextEditingController(text: _totalIncome.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Total Income'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, double.tryParse(controller.text));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _totalIncome = result;
      });
      // TODO: Save to Appwrite database
    }
  }

  void _showEditExpenseDialog() async {
    final controller = TextEditingController(text: _totalExpenses.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Total Expenses'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, double.tryParse(controller.text));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _totalExpenses = result;
      });
      // TODO: Save to Appwrite database
    }
  }

  void _showEditBudgetDialog() async {
    final controller = TextEditingController(text: _monthlyBudget.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, double.tryParse(controller.text));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _monthlyBudget = result;
      });
      // TODO: Save to Appwrite database
    }
  }

  void _showAddTransactionDialog() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final categoryController = TextEditingController();
    bool isIncome = true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹ ',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Type: '),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text('Income'),
                      selected: isIncome,
                      onSelected: (selected) {
                        setDialogState(() => isIncome = true);
                      },
                      selectedColor: Colors.green[100],
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Expense'),
                      selected: !isIncome,
                      onSelected: (selected) {
                        setDialogState(() => isIncome = false);
                      },
                      selectedColor: Colors.red[100],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty) {
                  final transaction = Transaction(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    category: categoryController.text,
                    amount: double.parse(amountController.text),
                    date: DateTime.now(),
                    isIncome: isIncome,
                  );

                  setState(() {
                    _transactions.insert(0, transaction);
                    _calculateTotals();
                  });

                  // TODO: Save to Appwrite database
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                ),
                child: Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hi, Welcome Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: _handleLogout,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Income/Expense Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _showEditIncomeDialog,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white.withOpacity(0.9),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Total Income',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${_totalIncome.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: _showEditExpenseDialog,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white.withOpacity(0.9),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Total Expenses',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${_totalExpenses.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Monthly Budget
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: _showEditBudgetDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jan',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '₹${_monthlyBudget.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Motivation Message
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white.withOpacity(0.9),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Give CV Your Expenses Look Good!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Summary Cards Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B5E20).withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.savings_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Receive Last Week',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '₹0.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.credit_card_outlined,
                                color: Colors.grey[700],
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Last Expenses',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '-₹${_totalExpenses.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Period Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildPeriodChip('Daily'),
                    const SizedBox(width: 8),
                    _buildPeriodChip('Weekly'),
                    const SizedBox(width: 8),
                    _buildPeriodChip('Monthly'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Transactions List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (_transactions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first transaction',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          return _buildTransactionItem(transaction);
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.pie_chart_outline, 1),
                _buildNavItem(Icons.credit_card, 2),
                _buildNavItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B5E20) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    IconData icon;
    Color iconBgColor;

    switch (transaction.category.toLowerCase()) {
      case 'salary':
        icon = Icons.attach_money;
        iconBgColor = Colors.blue[100]!;
        break;
      case 'groceries':
      case 'food':
        icon = Icons.shopping_cart_outlined;
        iconBgColor = Colors.orange[100]!;
        break;
      case 'rent':
        icon = Icons.home_outlined;
        iconBgColor = Colors.purple[100]!;
        break;
      default:
        icon = Icons.receipt_outlined;
        iconBgColor = Colors.grey[200]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[800], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.date.day} - ${_getMonthName(transaction.date.month)} ${transaction.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: transaction.isIncome
                      ? Colors.green[600]
                      : Colors.red[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.category,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Already on home
          return;
        } else if (index == 1) {
          // Categories
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriesScreen(
                totalBalance: _totalIncome - _totalExpenses,
                totalExpenses: _totalExpenses,
                monthlyBudget: _monthlyBudget,
              ),
            ),
          );
        } else if (index == 2) {
          // Wallet/Cards - Coming soon
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wallet feature coming soon!'),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (index == 3) {
          // Profile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coming soon!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1B5E20).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF1B5E20) : Colors.grey[400],
          size: 26,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
