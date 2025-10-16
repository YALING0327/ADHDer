/// 用户模型
class User {
  final String id;
  final String? username;
  final String? email;
  final Profile profile;
  final Stats stats;
  final DateTime? createdAt;

  User({
    required this.id,
    this.username,
    this.email,
    required this.profile,
    required this.stats,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['auth']?['local']?['username'] ?? json['username'],
      email: json['auth']?['local']?['email'] ?? json['email'],
      profile: Profile.fromJson(json['profile'] ?? {}),
      stats: Stats.fromJson(json['stats'] ?? {}),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile': profile.toJson(),
      'stats': stats.toJson(),
    };
  }
}

/// 用户资料
class Profile {
  final String name;
  final String? imageUrl;

  Profile({
    required this.name,
    this.imageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '未命名用户',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

/// 用户统计
class Stats {
  final int level;
  final int exp;
  final int gold;
  final int points; // 积分
  final double health;
  final double maxHealth;

  Stats({
    this.level = 1,
    this.exp = 0,
    this.gold = 0,
    this.points = 0,
    this.health = 50,
    this.maxHealth = 50,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      level: json['lvl'] ?? json['level'] ?? 1,
      exp: (json['exp'] ?? 0).toInt(),
      gold: (json['gp'] ?? json['gold'] ?? 0).toInt(),
      points: (json['points'] ?? 0).toInt(),
      health: (json['hp'] ?? json['health'] ?? 50).toDouble(),
      maxHealth: (json['maxHealth'] ?? 50).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'exp': exp,
      'gold': gold,
      'points': points,
      'health': health,
      'maxHealth': maxHealth,
    };
  }

  /// 经验值百分比
  double get expPercentage {
    final expToLevel = level * 100;
    return (exp / expToLevel).clamp(0.0, 1.0);
  }

  /// 健康值百分比
  double get healthPercentage {
    return (health / maxHealth).clamp(0.0, 1.0);
  }
}

