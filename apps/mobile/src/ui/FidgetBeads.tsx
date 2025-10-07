import React, { useState, useEffect } from 'react';
import { View, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import * as Haptics from 'expo-haptics';
import { Colors } from './colors';
import { Spacing } from './spacing';
import { Caption } from './text';

interface FidgetBeadsProps {
  count?: number;
  onInteraction?: () => void;
  autoPromptDelay?: number; // 自动提示延迟（毫秒）
  onAutoPrompt?: () => void;
}

export const FidgetBeads: React.FC<FidgetBeadsProps> = ({
  count = 12,
  onInteraction,
  autoPromptDelay = 60000, // 60秒
  onAutoPrompt,
}) => {
  const [beads, setBeads] = useState<boolean[]>(new Array(count).fill(true)); // true = 左侧
  const [interactionCount, setInteractionCount] = useState(0);
  const autoPromptTimerRef = React.useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    // 设置自动提示定时器
    autoPromptTimerRef.current = setTimeout(() => {
      onAutoPrompt?.();
    }, autoPromptDelay);

    return () => {
      if (autoPromptTimerRef.current) {
        clearTimeout(autoPromptTimerRef.current);
      }
    };
  }, [autoPromptDelay, onAutoPrompt]);

  const toggleBead = (index: number) => {
    setBeads(prev => {
      const newBeads = [...prev];
      newBeads[index] = !newBeads[index];
      return newBeads;
    });
    
    setInteractionCount(prev => prev + 1);
    
    // 触觉反馈
    Haptics.selectionAsync();
    
    // 通知父组件
    onInteraction?.();
  };

  const resetBeads = () => {
    setBeads(new Array(count).fill(true));
    setInteractionCount(0);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
  };

  return (
    <View style={styles.container}>
      <View style={styles.beamContainer}>
        {beads.map((isLeft, index) => (
          <View key={index} style={styles.beadSlot}>
            <TouchableOpacity
              style={[
                styles.bead,
                {
                  backgroundColor: isLeft ? Colors.textTertiary : Colors.primary,
                  alignSelf: isLeft ? 'flex-start' : 'flex-end',
                },
              ]}
              onPress={() => toggleBead(index)}
              activeOpacity={0.7}
            />
          </View>
        ))}
      </View>
      
      <View style={styles.footer}>
        <Caption style={styles.interactionText}>
          已拨动 {interactionCount} 次
        </Caption>
        <TouchableOpacity onPress={resetBeads} style={styles.resetButton}>
          <Caption style={styles.resetText}>重置</Caption>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    padding: Spacing.l,
  },
  beamContainer: {
    flexDirection: 'row',
    backgroundColor: Colors.surface,
    borderRadius: 28,
    paddingHorizontal: Spacing.s,
    paddingVertical: Spacing.s,
    height: 56,
    alignItems: 'center',
    marginBottom: Spacing.m,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 1,
  },
  beadSlot: {
    flex: 1,
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  bead: {
    width: 18,
    height: 18,
    borderRadius: 9,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    shadowRadius: 2,
    elevation: 2,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    width: '100%',
  },
  interactionText: {
    color: Colors.textSecondary,
  },
  resetButton: {
    paddingHorizontal: Spacing.m,
    paddingVertical: Spacing.s,
    backgroundColor: Colors.surface,
    borderRadius: 16,
  },
  resetText: {
    color: Colors.primary,
    fontWeight: '500',
  },
});
