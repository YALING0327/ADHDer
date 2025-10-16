import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

/// 手机号验证码登录页面
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormFieldState>(); // 单独的手机号验证
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  
  bool _codeSent = false;
  bool _isSending = false; // 是否正在发送
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendCode() async {
    // 只验证手机号，不验证验证码
    if (_phoneKey.currentState == null || !_phoneKey.currentState!.validate()) {
      return;
    }
    
    final phone = _phoneController.text.trim();
    
    // 显示加载状态
    setState(() {
      _isSending = true;
    });
    
    try {
      // 调用发送验证码API
      final success = await context.read<AuthProvider>().sendSmsCode(phone);
      
      if (!mounted) return;
      
      if (success) {
        setState(() {
          _codeSent = true;
          _countdown = 60;
          _isSending = false;
        });

        // 倒计时
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              if (_countdown > 0) {
                _countdown--;
              } else {
                timer.cancel();
              }
            });
          } else {
            timer.cancel();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ 验证码已发送，请查收短信'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _isSending = false;
        });
        
        final error = context.read<AuthProvider>().error ?? '发送失败，请稍后重试';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $error'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ 网络错误: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();

    // 调用手机号登录API
    final success = await context.read<AuthProvider>().loginWithPhone(phone, code);
    
    if (success) {
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      final error = context.read<AuthProvider>().error ?? '验证码错误';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('手机号登录'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // 图标
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('📱', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  '验证码登录',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  '未注册的手机号验证后自动创建账户',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // 手机号输入
                TextFormField(
                  key: _phoneKey, // 添加key用于单独验证
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    prefixIcon: Icon(Icons.phone_outlined),
                    prefixText: '+86 ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入手机号';
                    }
                    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                      return '请输入有效的手机号';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 验证码输入
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        enabled: _codeSent, // 只有发送验证码后才能输入
                        decoration: InputDecoration(
                          labelText: '验证码',
                          hintText: _codeSent ? '请输入6位验证码' : '请先获取验证码',
                          prefixIcon: const Icon(Icons.security_outlined),
                          counterText: '',
                        ),
                        validator: (value) {
                          // 只在登录时验证
                          if (value == null || value.isEmpty) {
                            return '请输入验证码';
                          }
                          if (value.length != 6) {
                            return '验证码为6位数字';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: (_countdown > 0 || _isSending) ? null : _sendCode,
                        child: _isSending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _countdown > 0 ? '${_countdown}秒' : '获取验证码',
                                style: const TextStyle(fontSize: 13),
                              ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // 登录按钮
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return ElevatedButton(
                      onPressed: _codeSent && !authProvider.isLoading 
                          ? _handleLogin 
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.infoColor,
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('登录'),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 协议提示
                Text(
                  '登录即表示同意《用户协议》和《隐私政策》',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

