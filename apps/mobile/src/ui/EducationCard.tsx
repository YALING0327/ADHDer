import React from 'react';
import { View, TouchableOpacity, StyleSheet } from 'react-native';
import { Colors } from './colors';
import { Spacing } from './spacing';
import { Heading, Body, Caption } from './text';

interface EducationCardProps {
  title: string;
  bullets: string[];
  ctaText?: string;
  onPress?: () => void;
  style?: any;
}

export const EducationCard: React.FC<EducationCardProps> = ({
  title,
  bullets,
  ctaText = '了解更多',
  onPress,
  style,
}) => {
  return (
    <TouchableOpacity 
      style={[styles.card, style]} 
      onPress={onPress}
      activeOpacity={0.8}
    >
      <Heading style={styles.title}>{title}</Heading>
      
      <View style={styles.bulletsContainer}>
        {bullets.map((bullet, index) => (
          <View key={index} style={styles.bulletRow}>
            <View style={styles.bulletPoint} />
            <Body style={styles.bulletText}>{bullet}</Body>
          </View>
        ))}
      </View>
      
      <View style={styles.footer}>
        <Caption style={styles.ctaText}>{ctaText}</Caption>
        <View style={styles.arrow} />
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    backgroundColor: Colors.backgroundElevated,
    borderRadius: 12,
    padding: Spacing.l,
    marginBottom: Spacing.m,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 2,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  title: {
    marginBottom: Spacing.m,
    color: Colors.textPrimary,
  },
  bulletsContainer: {
    marginBottom: Spacing.l,
  },
  bulletRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: Spacing.s,
  },
  bulletPoint: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: Colors.primary,
    marginTop: 8,
    marginRight: Spacing.s,
  },
  bulletText: {
    flex: 1,
    color: Colors.textPrimary,
    lineHeight: 22,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: Spacing.s,
    borderTopWidth: 1,
    borderTopColor: Colors.divider,
  },
  ctaText: {
    color: Colors.primary,
    fontWeight: '500',
  },
  arrow: {
    width: 0,
    height: 0,
    borderLeftWidth: 6,
    borderRightWidth: 6,
    borderBottomWidth: 6,
    borderLeftColor: 'transparent',
    borderRightColor: 'transparent',
    borderBottomColor: Colors.primary,
    transform: [{ rotate: '90deg' }],
  },
});
