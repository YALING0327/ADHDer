import React, { useState } from 'react';
import { SafeAreaView, View, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { EducationCard } from '../src/ui/EducationCard';
import { Card } from '../src/ui/components';
import { Title, Body, Caption } from '../src/ui/text';
import { Colors } from '../src/ui/colors';
import { Spacing } from '../src/ui/spacing';
import { educationContent, getAllCategories, getEducationCardsByCategory, EducationCardData } from '../src/data/educationContent';

export default function EducationScreenNew() {
  const [selectedCategory, setSelectedCategory] = useState<string>('认识ADHD');
  const categories = getAllCategories();

  const renderCategoryTab = ({ item }: { item: string }) => (
    <TouchableOpacity
      style={[
        styles.categoryTab,
        selectedCategory === item && styles.categoryTabActive
      ]}
      onPress={() => setSelectedCategory(item)}
    >
      <Caption style={[
        styles.categoryTabText,
        selectedCategory === item && styles.categoryTabTextActive
      ]}>
        {item}
      </Caption>
    </TouchableOpacity>
  );

  const renderEducationCard = ({ item }: { item: EducationCardData }) => (
    <EducationCard
      title={item.title}
      bullets={item.bullets}
      ctaText={item.ctaText}
      onPress={() => {
        // 这里可以打开详细内容或外部链接
        console.log('打开教育卡片:', item.title);
      }}
    />
  );

  const currentCards = getEducationCardsByCategory(selectedCategory);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <View style={styles.header}>
          <Title style={styles.title}>ADHD 知识库</Title>
          <Caption style={styles.subtitle}>
            科学、准确的信息，帮助你更好地理解 ADHD
          </Caption>
        </View>

        <View style={styles.disclaimer}>
          <Card style={styles.disclaimerCard}>
            <Caption style={styles.disclaimerText}>
              ⚠️ 这些信息仅供参考，不能替代专业医疗建议。如有疑问，请咨询医生。
            </Caption>
          </Card>
        </View>

        <View style={styles.categoriesContainer}>
          <FlatList
            data={categories}
            renderItem={renderCategoryTab}
            keyExtractor={(item) => item}
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.categoriesList}
          />
        </View>

        <View style={styles.cardsContainer}>
          <FlatList
            data={currentCards}
            renderItem={renderEducationCard}
            keyExtractor={(item) => item.id}
            showsVerticalScrollIndicator={false}
            contentContainerStyle={styles.cardsList}
          />
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  content: {
    flex: 1,
    padding: Spacing.screenPadding,
  },
  header: {
    alignItems: 'center',
    marginBottom: Spacing.l,
  },
  title: {
    marginBottom: Spacing.s,
    textAlign: 'center',
  },
  subtitle: {
    textAlign: 'center',
    color: Colors.textSecondary,
  },
  disclaimer: {
    marginBottom: Spacing.l,
  },
  disclaimerCard: {
    backgroundColor: Colors.warning + '20', // 20% 透明度
    borderColor: Colors.warning,
  },
  disclaimerText: {
    color: Colors.warning,
    textAlign: 'center',
    lineHeight: 18,
  },
  categoriesContainer: {
    marginBottom: Spacing.l,
  },
  categoriesList: {
    paddingHorizontal: Spacing.s,
  },
  categoryTab: {
    paddingHorizontal: Spacing.m,
    paddingVertical: Spacing.s,
    marginHorizontal: Spacing.xs,
    borderRadius: 20,
    backgroundColor: Colors.surface,
    minHeight: Spacing.touchTarget,
    justifyContent: 'center',
  },
  categoryTabActive: {
    backgroundColor: Colors.primary,
  },
  categoryTabText: {
    color: Colors.textSecondary,
    fontWeight: '500',
  },
  categoryTabTextActive: {
    color: Colors.backgroundElevated,
  },
  cardsContainer: {
    flex: 1,
  },
  cardsList: {
    paddingBottom: Spacing.xxl,
  },
});
