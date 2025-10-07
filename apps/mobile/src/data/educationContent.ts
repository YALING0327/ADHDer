export interface EducationCardData {
  id: string;
  category: string;
  title: string;
  bullets: string[];
  ctaText: string;
}

export const educationContent: EducationCardData[] = [
  // A. 认识 ADHD（5张）
  {
    id: 'adhd-1',
    category: '认识ADHD',
    title: '什么是 ADHD',
    bullets: [
      '核心表现：注意力难集中、多动、冲动',
      '需跨情境、持续≥6个月',
      '去医院评估最重要'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'adhd-2',
    category: '认识ADHD',
    title: '不同年龄的样子',
    bullets: [
      '学龄前更"动"',
      '入学后注意问题更明显',
      '青春期多动减但注意仍受影响'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'adhd-3',
    category: '认识ADHD',
    title: '常见共病',
    bullets: [
      '学习障碍、焦虑抑郁',
      '对立违抗/品行问题',
      '睡眠问题等，需一并评估'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'adhd-4',
    category: '认识ADHD',
    title: '诊断要点',
    bullets: [
      '起病多在12岁前',
      '多场景受影响',
      '排除其他身心疾病'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'adhd-5',
    category: '认识ADHD',
    title: '就诊准备清单',
    bullets: [
      '课堂/家庭表现记录',
      '起病经过、家族史',
      '量表与作业样本带齐'
    ],
    ctaText: '了解更多'
  },

  // B. 药物与随访（5张）
  {
    id: 'med-1',
    category: '药物与随访',
    title: '药物是长期方案的一部分',
    bullets: [
      '5岁以上多建议药物+行为干预',
      '定期随访、滴定剂量',
      '配合其他干预效果更好'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'med-2',
    category: '药物与随访',
    title: '常用药物',
    bullets: [
      '中枢兴奋剂（派甲酯）疗效确切',
      '非兴奋剂（托莫西汀）',
      '副反应可管理'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'med-3',
    category: '药物与随访',
    title: '监测什么',
    bullets: [
      '身高体重、食欲、睡眠',
      '血压/心率、情绪变化',
      '必要时调整或"药物假期"'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'med-4',
    category: '药物与随访',
    title: '误区澄清',
    bullets: [
      '规范用药不等于成瘾',
      '治疗目的是恢复功能',
      '不是"变乖"'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'med-5',
    category: '药物与随访',
    title: '何时考虑停药',
    bullets: [
      '漏服/假期仍表现稳定',
      '无功能受损时',
      '与医生商议'
    ],
    ctaText: '了解更多'
  },

  // C. 学习障碍与干预（5张）
  {
    id: 'learning-1',
    category: '学习障碍与干预',
    title: '学习困难 ≠ 学习障碍',
    bullets: [
      '后者指读写算等特定技能受损',
      '智力多为正常',
      '需要专业评估'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'learning-2',
    category: '学习障碍与干预',
    title: '识别要点',
    bullets: [
      '阅读慢且错别字多',
      '写作组织差',
      '计算/对位错误多等'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'learning-3',
    category: '学习障碍与干预',
    title: '共患很常见',
    bullets: [
      'ADHD与阅读/数学障碍双向影响',
      '需双轨干预',
      '越早识别越好'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'learning-4',
    category: '学习障碍与干预',
    title: '有效做法',
    bullets: [
      '结构化读写/拼读训练',
      '数学策略训练',
      '家校合作与适度考试调整'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'learning-5',
    category: '学习障碍与干预',
    title: '越早越好',
    bullets: [
      '8岁前开始干预',
      '改善机会显著提高',
      '不要等待'
    ],
    ctaText: '了解更多'
  },

  // D. 心理特征与情绪（5张）
  {
    id: 'emotion-1',
    category: '心理特征与情绪',
    title: '拒绝敏感性',
    bullets: [
      '被批评/拒绝时情绪反应大',
      '来得快，不是"矫情"',
      '可练习自我安抚'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'emotion-2',
    category: '心理特征与情绪',
    title: '情绪易激',
    bullets: [
      '高低起伏大',
      '父母与本人都需练"先情绪、后问题"',
      '理解比指责更重要'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'emotion-3',
    category: '心理特征与情绪',
    title: '过度聚焦',
    bullets: [
      '对兴趣超专注',
      '易忘时',
      '用计时与外部提醒保护节奏'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'emotion-4',
    category: '心理特征与情绪',
    title: '家长沟通四步',
    bullets: [
      '说感受→说行为→给方向→给鼓励',
      '不贴标签',
      '保持耐心'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'emotion-5',
    category: '心理特征与情绪',
    title: '求助清单',
    bullets: [
      '情绪影响到学业或关系时',
      '寻求专业心理/精神科支持',
      '不要独自承受'
    ],
    ctaText: '了解更多'
  },

  // E. 注意力训练与非药物（5张）
  {
    id: 'training-1',
    category: '注意力训练与非药物',
    title: '可选途径',
    bullets: [
      '家长行为管理、认知训练',
      '（部分场景）脑电反馈',
      '有氧运动、睡眠卫生'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'training-2',
    category: '注意力训练与非药物',
    title: '目标不是"变完美"',
    bullets: [
      '是把功能拉回来',
      '配合药物更可持续',
      '小步前进'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'training-3',
    category: '注意力训练与非药物',
    title: '番茄/微任务',
    bullets: [
      '小步走、快反馈',
      '更适合ADHD的节奏',
      '从5分钟开始'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'training-4',
    category: '注意力训练与非药物',
    title: '睡眠与作息',
    bullets: [
      '固定起卧时间',
      '减少睡前屏幕',
      '音景仅作辅助'
    ],
    ctaText: '了解更多'
  },
  {
    id: 'training-5',
    category: '注意力训练与非药物',
    title: '运动即良药',
    bullets: [
      '日常步行/跑跳',
      '对情绪与注意都加分',
      '每天30分钟'
    ],
    ctaText: '了解更多'
  },
];

export const getEducationCardsByCategory = (category: string): EducationCardData[] => {
  return educationContent.filter(card => card.category === category);
};

export const getAllCategories = (): string[] => {
  return [...new Set(educationContent.map(card => card.category))];
};
