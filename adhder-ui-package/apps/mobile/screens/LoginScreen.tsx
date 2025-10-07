import React, { useState } from 'react';
import { SafeAreaView, View, Text, TextInput, TouchableOpacity } from 'react-native';
import { api } from '../src/api';
import { setToken } from '../src/auth';

type LoginType = 'email' | 'phone';

export default function LoginScreen({ onLoggedIn }: { onLoggedIn: () => void }) {
  const [loginType, setLoginType] = useState<LoginType>('email');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [code, setCode] = useState('');
  const [sent, setSent] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string|undefined>();

  const request = async () => {
    setLoading(true); setError(undefined);
    try { 
      if (loginType === 'email') {
        await api.requestEmailOtp(email);
      } else {
        await api.requestPhoneOtp(phone);
      }
      setSent(true); 
    } catch (e:any) { setError(e.message); }
    setLoading(false);
  };

  const verify = async () => {
    setLoading(true); setError(undefined);
    try {
      let res;
      if (loginType === 'email') {
        res = await api.verifyEmailOtp(email, code);
      } else {
        res = await api.verifyPhoneOtp(phone, code);
      }
      
      if (res.token) { 
        await setToken(res.token); 
        onLoggedIn(); 
      } else {
        setError('验证失败');
      }
    } catch (e:any) { setError(e.message); }
    setLoading(false);
  };

  const reset = () => {
    setSent(false);
    setCode('');
    setError(undefined);
  };

  return (
    <SafeAreaView style={{ flex: 1, padding: 24 }}>
      <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 16 }}>登录</Text>
      
      {/* 登录方式选择 */}
      <View style={{ flexDirection: 'row', marginBottom: 16, gap: 8 }}>
        <TouchableOpacity 
          onPress={() => { setLoginType('email'); reset(); }}
          style={{ 
            paddingVertical: 8, 
            paddingHorizontal: 16, 
            borderRadius: 20, 
            backgroundColor: loginType === 'email' ? '#4b8' : '#f0f0f0' 
          }}
        >
          <Text style={{ color: loginType === 'email' ? '#fff' : '#666' }}>邮箱</Text>
        </TouchableOpacity>
        <TouchableOpacity 
          onPress={() => { setLoginType('phone'); reset(); }}
          style={{ 
            paddingVertical: 8, 
            paddingHorizontal: 16, 
            borderRadius: 20, 
            backgroundColor: loginType === 'phone' ? '#4b8' : '#f0f0f0' 
          }}
        >
          <Text style={{ color: loginType === 'phone' ? '#fff' : '#666' }}>手机号</Text>
        </TouchableOpacity>
      </View>

      {/* 输入框 */}
      {loginType === 'email' ? (
        <TextInput
          value={email}
          onChangeText={setEmail}
          placeholder="请输入邮箱地址"
          keyboardType="email-address"
          autoCapitalize="none"
          style={{ borderWidth: 1, borderColor: '#ddd', padding: 12, borderRadius: 8, marginBottom: 12 }}
        />
      ) : (
        <TextInput
          value={phone}
          onChangeText={setPhone}
          placeholder="请输入手机号"
          keyboardType="phone-pad"
          maxLength={11}
          style={{ borderWidth: 1, borderColor: '#ddd', padding: 12, borderRadius: 8, marginBottom: 12 }}
        />
      )}

      {/* 验证码输入 */}
      {sent && (
        <TextInput
          value={code}
          onChangeText={setCode}
          placeholder="请输入验证码"
          keyboardType="number-pad"
          maxLength={6}
          style={{ borderWidth: 1, borderColor: '#ddd', padding: 12, borderRadius: 8, marginBottom: 12 }}
        />
      )}

      {/* 错误信息 */}
      {error ? <Text style={{ color: 'red', marginBottom: 12 }}>{error}</Text> : null}

      {/* 按钮 */}
      {!sent ? (
        <TouchableOpacity 
          onPress={request} 
          disabled={loading || (loginType === 'email' ? !email : !phone)} 
          style={{ 
            backgroundColor: (loading || (loginType === 'email' ? !email : !phone)) ? '#ccc' : '#4b8', 
            padding: 14, 
            borderRadius: 10 
          }}
        >
          <Text style={{ color: '#fff', textAlign: 'center', fontSize: 16 }}>
            {loading ? '发送中…' : `获取${loginType === 'email' ? '邮箱' : '短信'}验证码`}
          </Text>
        </TouchableOpacity>
      ) : (
        <TouchableOpacity 
          onPress={verify} 
          disabled={loading || !code} 
          style={{ 
            backgroundColor: (loading || !code) ? '#ccc' : '#48f', 
            padding: 14, 
            borderRadius: 10 
          }}
        >
          <Text style={{ color: '#fff', textAlign: 'center', fontSize: 16 }}>
            {loading ? '验证中…' : '登录'}
          </Text>
        </TouchableOpacity>
      )}

      {/* 重新发送 */}
      {sent && (
        <TouchableOpacity onPress={reset} style={{ marginTop: 12 }}>
          <Text style={{ color: '#666', textAlign: 'center' }}>重新发送</Text>
        </TouchableOpacity>
      )}
    </SafeAreaView>
  );
}


