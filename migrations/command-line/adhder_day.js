db.users.update(
  {},
  { $inc: { 'achievements.adhderDays': 1 } },
  { multi: 1 },
);
