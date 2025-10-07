import React from 'react';
import { Text, TouchableOpacity, View, ViewStyle, TextStyle } from 'react-native';
import { Colors } from './colors';
import { Spacing } from './spacing';
import { TextStyles } from './text';

export const Screen: React.FC<{ style?: ViewStyle; children: React.ReactNode }> = ({ style, children }) => (
  <View style={[{ flex: 1, backgroundColor: Colors.background }, style]}>{children}</View>
);

export const Card: React.FC<{ style?: ViewStyle; children: React.ReactNode }> = ({ style, children }) => (
  <View
    style={[
      {
        backgroundColor: Colors.card,
        borderRadius: 12,
        padding: Spacing.l,
        shadowColor: '#000',
        shadowOpacity: 0.1,
        shadowRadius: 8,
        shadowOffset: { width: 0, height: 2 },
        borderWidth: 1,
        borderColor: Colors.border,
      },
      style,
    ]}
  >
    {children}
  </View>
);

export const PrimaryButton: React.FC<{ title: string; onPress: () => void; disabled?: boolean; style?: ViewStyle; textStyle?: TextStyle }> = ({ title, onPress, disabled, style, textStyle }) => (
  <TouchableOpacity
    onPress={onPress}
    disabled={disabled}
    style={[
      {
        backgroundColor: disabled ? Colors.disabled : Colors.primary,
        paddingVertical: Spacing.m,
        paddingHorizontal: Spacing.l,
        borderRadius: 12,
        minHeight: Spacing.buttonHeight,
        justifyContent: 'center',
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 2,
      },
      style,
    ]}
  >
    <Text style={[TextStyles.button, { textAlign: 'center' }, textStyle]}>{title}</Text>
  </TouchableOpacity>
);

export const Pill: React.FC<{ active?: boolean; title: string; onPress: () => void }> = ({ active, title, onPress }) => (
  <TouchableOpacity
    onPress={onPress}
    style={{
      paddingVertical: Spacing.s,
      paddingHorizontal: Spacing.m,
      borderRadius: 20,
      backgroundColor: active ? Colors.primary : Colors.surface,
      minHeight: Spacing.touchTarget,
      justifyContent: 'center',
      alignItems: 'center',
    }}
  >
    <Text style={{ 
      color: active ? Colors.backgroundElevated : Colors.textSecondary,
      fontSize: 14,
      fontWeight: '500',
    }}>{title}</Text>
  </TouchableOpacity>
);

export const Title: React.FC<{ children: React.ReactNode; style?: TextStyle }> = ({ children, style }) => (
  <Text style={[TextStyles.title, { color: Colors.text }, style]}>{children}</Text>
);

export const Caption: React.FC<{ children: React.ReactNode; style?: TextStyle }> = ({ children, style }) => (
  <Text style={[TextStyles.caption, { color: Colors.textSecondary }, style]}>{children}</Text>
);

