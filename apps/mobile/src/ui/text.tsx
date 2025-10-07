import { Text, TextProps, TextStyle } from 'react-native';
import React from 'react';
import { Colors } from './colors';

export const TextStyles: { [k: string]: TextStyle } = {
  // 标题层级 - 粗体主标题是视觉主角
  title: { 
    fontSize: 28, 
    fontWeight: '700', 
    lineHeight: 36, 
    color: Colors.textPrimary 
  },
  heading: { 
    fontSize: 24, 
    fontWeight: '600', 
    lineHeight: 32, 
    color: Colors.textPrimary 
  },
  subheading: { 
    fontSize: 20, 
    fontWeight: '600', 
    lineHeight: 28, 
    color: Colors.textPrimary 
  },
  
  // 正文层级
  body: { 
    fontSize: 16, 
    fontWeight: '400', 
    lineHeight: 24, 
    color: Colors.textPrimary 
  },
  bodyLarge: { 
    fontSize: 18, 
    fontWeight: '400', 
    lineHeight: 27, 
    color: Colors.textPrimary 
  },
  
  // 辅助文字
  caption: { 
    fontSize: 14, 
    fontWeight: '400', 
    lineHeight: 20, 
    color: Colors.textSecondary 
  },
  small: { 
    fontSize: 12, 
    fontWeight: '400', 
    lineHeight: 16, 
    color: Colors.textTertiary 
  },
  
  // 特殊用途
  button: { 
    fontSize: 16, 
    fontWeight: '600', 
    lineHeight: 24, 
    color: Colors.backgroundElevated 
  },
  timer: { 
    fontSize: 40, 
    fontWeight: '700', 
    lineHeight: 48, 
    color: Colors.textPrimary 
  },
};

// 便捷组件
export const Title = (props: TextProps) => <Text style={[TextStyles.title, props.style]} {...props} />;
export const Heading = (props: TextProps) => <Text style={[TextStyles.heading, props.style]} {...props} />;
export const Subheading = (props: TextProps) => <Text style={[TextStyles.subheading, props.style]} {...props} />;
export const Body = (props: TextProps) => <Text style={[TextStyles.body, props.style]} {...props} />;
export const BodyLarge = (props: TextProps) => <Text style={[TextStyles.bodyLarge, props.style]} {...props} />;
export const Caption = (props: TextProps) => <Text style={[TextStyles.caption, props.style]} {...props} />;
export const Small = (props: TextProps) => <Text style={[TextStyles.small, props.style]} {...props} />;
export const ButtonText = (props: TextProps) => <Text style={[TextStyles.button, props.style]} {...props} />;
export const TimerText = (props: TextProps) => <Text style={[TextStyles.timer, props.style]} {...props} />;

