export const Colors = {
  // 主色调 - 低饱和，ADHD友好
  primary: '#4C7EFF',      // 主品牌色 - 柔和蓝
  secondary: '#60D394',    // 成功色 - 淡绿
  accent: '#FFC15E',       // 强调色 - 温暖橙
  
  // 状态色
  success: '#60D394',      // 完成/成功
  warning: '#FFB74D',      // 警告/超期
  error: '#FF6B6B',        // 错误 - 仅用于错误状态
  
  // 背景色 - 低饱和
  background: '#F8F9FA',   // 主背景
  backgroundElevated: '#FFFFFF', // 卡片背景
  surface: '#F1F3F4',      // 表面色
  
  // 文字色
  textPrimary: '#1A1A1A',  // 主文字
  textSecondary: '#6B7280', // 辅助文字
  textTertiary: '#9CA3AF', // 三级文字
  
  // 边框和分割线
  border: '#E5E7EB',       // 边框
  divider: '#F3F4F6',      // 分割线
  
  // 交互状态
  hover: '#F3F4F6',        // 悬停
  pressed: '#E5E7EB',      // 按下
  disabled: '#D1D5DB',     // 禁用
  
  // 兼容性保留
  card: '#FFFFFF',
  text: '#1A1A1A',
  textSecondary: '#6B7280',
  dark: '#1A1A1A',
};

export type ColorKeys = keyof typeof Colors;

