import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/tasbeeh_provider.dart';
import '../../utils/constants.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({Key? key}) : super(key: key);

  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _customTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customTargetController.dispose();
    super.dispose();
  }

  void _onTap() {
    final provider = Provider.of<TasbeehProvider>(context, listen: false);
    if (!provider.isComplete) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      provider.increment();
      HapticFeedback.lightImpact();

      if (provider.isComplete) {
        HapticFeedback.heavyImpact();
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Target Reached!',
          style: TextStyle(color: AppColors.primaryGreen),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 60,
              color: AppColors.primaryGreen,
            ),
            SizedBox(height: 16),
            Text(
              'MashaAllah! You have completed your dhikr.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<TasbeehProvider>(context, listen: false).reset();
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showTargetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final provider = Provider.of<TasbeehProvider>(context, listen: false);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Set Target'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...provider.presetTargets.map((target) => ListTile(
                title: Text('$target'),
                leading: Radio<int>(
                  value: target,
                  groupValue: provider.target,
                  onChanged: (value) {
                    provider.setTarget(value!);
                    Navigator.pop(context);
                  },
                  activeColor: AppColors.primaryGreen,
                ),
              )),
              Divider(),
              ListTile(
                title: TextField(
                  controller: _customTargetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Custom target',
                    border: OutlineInputBorder(),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.check, color: AppColors.primaryGreen),
                  onPressed: () {
                    final value = int.tryParse(_customTargetController.text);
                    if (value != null) {
                      provider.setCustomTarget(value);
                      _customTargetController.clear();
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Consumer<TasbeehProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Dhikr Counter',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        SizedBox(height: 30),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: provider.progress,
                                strokeWidth: 8,
                                backgroundColor: AppColors.lightGreen,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryGreen,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${provider.count}',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'of ${provider.target}',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: _onTap,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: provider.isComplete
                                      ? [AppColors.gold, AppColors.lightGold]
                                      : [AppColors.primaryGreen, AppColors.secondaryGreen],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: provider.isComplete
                                        ? AppColors.gold.withOpacity(0.3)
                                        : AppColors.primaryGreen.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                provider.isComplete ? Icons.check : Icons.touch_app,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: provider.reset,
                              icon: Icon(Icons.refresh, size: 20),
                              label: Text(
                                'Reset',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textDark,
                                side: BorderSide(color: AppColors.textLight.withOpacity(0.3), width: 1.5),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _showTargetDialog,
                              icon: Icon(Icons.flag, size: 20),
                              label: Text(
                                'Target',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        icon: Icons.calculate_outlined,
                        label: 'Total Count',
                        value: '${provider.totalCount}',
                        color: AppColors.primaryGreen,
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: AppColors.textLight.withOpacity(0.2),
                      ),
                      _buildStatCard(
                        icon: Icons.trending_up,
                        label: 'Progress',
                        value: '${(provider.progress * 100).toInt()}%',
                        color: AppColors.secondaryGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}