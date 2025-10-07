import { getToken } from './auth';

const BASE_URL = process.env.EXPO_PUBLIC_API_BASE || 'http://localhost:3000';

async function request(path: string, options: RequestInit = {}) {
  const token = await getToken();
  const headers: any = { 'Content-Type': 'application/json', ...(options.headers || {}) };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(`${BASE_URL}${path}`, { ...options, headers });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

export const api = {
  // 邮箱登录
  requestEmailOtp: (email: string) => request('/api/auth/request-otp', { method: 'POST', body: JSON.stringify({ email }) }),
  verifyEmailOtp: (email: string, code: string) => request('/api/auth/verify-otp', { method: 'POST', body: JSON.stringify({ email, code }) }),
  
  // 手机号登录
  requestPhoneOtp: (phone: string) => request('/api/auth/request-phone-otp', { method: 'POST', body: JSON.stringify({ phone }) }),
  verifyPhoneOtp: (phone: string, code: string) => request('/api/auth/verify-phone-otp', { method: 'POST', body: JSON.stringify({ phone, code }) }),
  
  // 任务管理
  listTasks: () => request('/api/tasks'),
  createTask: (title: string, type: 'free'|'ddl', due?: string) => request('/api/tasks', { method: 'POST', body: JSON.stringify({ title, type, due }) }),
  
  // 专注会话
  createFocusSession: (mode: 25|45|60, startIso: string) => request('/api/focus-sessions', { method: 'POST', body: JSON.stringify({ mode, start: startIso, interrupts: 0 }) }),
  finishFocusSession: (endIso: string, interrupts: number) => request('/api/focus-sessions', { method: 'POST', body: JSON.stringify({ end: endIso, interrupts }) }),
  
  // 其他功能
  logEvent: (name: string, data?: any) => request('/api/events', { method: 'POST', body: JSON.stringify({ name, data }) }),
  search: (q: string) => request('/api/search?q=' + encodeURIComponent(q)),
};


