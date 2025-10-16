package com.adhderapp.android.adhder.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.adhderapp.android.adhder.models.Achievement;
import com.adhderapp.android.adhder.models.ContentResult;
import com.adhderapp.android.adhder.models.FAQArticle;
import com.adhderapp.android.adhder.models.Skill;
import com.adhderapp.android.adhder.models.Tag;
import com.adhderapp.android.adhder.models.TutorialStep;
import com.adhderapp.android.adhder.models.WorldState;
import com.adhderapp.android.adhder.models.inventory.Customization;
import com.adhderapp.android.adhder.models.inventory.Equipment;
import com.adhderapp.android.adhder.models.inventory.Quest;
import com.adhderapp.android.adhder.models.inventory.QuestCollect;
import com.adhderapp.android.adhder.models.inventory.QuestDropItem;
import com.adhderapp.android.adhder.models.invitations.InviteResponse;
import com.adhderapp.android.adhder.models.members.Member;
import com.adhderapp.android.adhder.models.social.Challenge;
import com.adhderapp.android.adhder.models.social.ChatMessage;
import com.adhderapp.android.adhder.models.social.FindUsernameResult;
import com.adhderapp.android.adhder.models.social.Group;
import com.adhderapp.android.adhder.models.tasks.GroupAssignedDetails;
import com.adhderapp.android.adhder.models.tasks.Task;
import com.adhderapp.android.adhder.models.tasks.TaskList;
import com.adhderapp.android.adhder.models.user.OwnedItem;
import com.adhderapp.android.adhder.models.user.OwnedMount;
import com.adhderapp.android.adhder.models.user.OwnedPet;
import com.adhderapp.android.adhder.models.user.Purchases;
import com.adhderapp.android.adhder.models.user.User;
import com.adhderapp.android.adhder.models.user.auth.SocialAuthentication;
import com.adhderapp.android.adhder.utils.AchievementListDeserializer;
import com.adhderapp.android.adhder.utils.AssignedDetailsDeserializer;
import com.adhderapp.android.adhder.utils.BooleanAsIntAdapter;
import com.adhderapp.android.adhder.utils.ChallengeDeserializer;
import com.adhderapp.android.adhder.utils.ChallengeListDeserializer;
import com.adhderapp.android.adhder.utils.ChatMessageDeserializer;
import com.adhderapp.android.adhder.utils.ContentDeserializer;
import com.adhderapp.android.adhder.utils.CustomizationDeserializer;
import com.adhderapp.android.adhder.utils.DateDeserializer;
import com.adhderapp.android.adhder.utils.EquipmentListDeserializer;
import com.adhderapp.android.adhder.utils.FAQArticleListDeserilializer;
import com.adhderapp.android.adhder.utils.FeedResponseDeserializer;
import com.adhderapp.android.adhder.utils.FindUsernameResultDeserializer;
import com.adhderapp.android.adhder.utils.GroupSerialization;
import com.adhderapp.android.adhder.utils.InviteResponseDeserializer;
import com.adhderapp.android.adhder.utils.MemberSerialization;
import com.adhderapp.android.adhder.utils.NotificationDeserializer;
import com.adhderapp.android.adhder.utils.OwnedItemListDeserializer;
import com.adhderapp.android.adhder.utils.OwnedMountListDeserializer;
import com.adhderapp.android.adhder.utils.OwnedPetListDeserializer;
import com.adhderapp.android.adhder.utils.PurchasedDeserializer;
import com.adhderapp.android.adhder.utils.QuestCollectDeserializer;
import com.adhderapp.android.adhder.utils.QuestDeserializer;
import com.adhderapp.android.adhder.utils.QuestDropItemsListSerialization;
import com.adhderapp.android.adhder.utils.SkillDeserializer;
import com.adhderapp.android.adhder.utils.SocialAuthenticationDeserializer;
import com.adhderapp.android.adhder.utils.TaskListDeserializer;
import com.adhderapp.android.adhder.utils.TaskSerializer;
import com.adhderapp.android.adhder.utils.TaskTagDeserializer;
import com.adhderapp.android.adhder.utils.TutorialStepListDeserializer;
import com.adhderapp.android.adhder.utils.UserDeserializer;
import com.adhderapp.android.adhder.utils.WorldStateSerialization;
import com.adhderapp.common.adhder.models.Notification;
import com.adhderapp.shared.adhder.models.responses.FeedResponse;

import java.lang.reflect.Type;
import java.util.Date;
import java.util.List;

import io.realm.RealmList;
import retrofit2.converter.gson.GsonConverterFactory;

public class GSonFactoryCreator {

    public static Gson createGson() {
        Type skillListType = new TypeToken<List<Skill>>() {
        }.getType();
        Type taskTagClassListType = new TypeToken<RealmList<Tag>>() {
        }.getType();
        Type customizationListType = new TypeToken<RealmList<Customization>>() {
        }.getType();
        Type tutorialStepListType = new TypeToken<RealmList<TutorialStep>>() {
        }.getType();
        Type faqArticleListType = new TypeToken<RealmList<FAQArticle>>() {
        }.getType();
        Type itemDataListType = new TypeToken<RealmList<Equipment>>() {
        }.getType();
        Type questCollectListType = new TypeToken<RealmList<QuestCollect>>() {
        }.getType();
        Type chatMessageListType = new TypeToken<RealmList<ChatMessage>>() {
        }.getType();
        Type challengeListType = new TypeToken<List<Challenge>>() {
        }.getType();
        Type challengeRealmListType = new TypeToken<RealmList<Challenge>>() {
        }.getType();
        Type questDropItemListType = new TypeToken<RealmList<QuestDropItem>>() {
        }.getType();
        Type ownedItemListType = new TypeToken<RealmList<OwnedItem>>() {
        }.getType();
        Type ownedPetListType = new TypeToken<RealmList<OwnedPet>>() {
        }.getType();
        Type ownedMountListType = new TypeToken<RealmList<OwnedMount>>() {
        }.getType();
        Type achievementsListType = new TypeToken<List<Achievement>>() {
        }.getType();
        Type assignedDetailsListType = new TypeToken<RealmList<GroupAssignedDetails>>() {
        }.getType();

        return new GsonBuilder()
                .registerTypeAdapter(taskTagClassListType, new TaskTagDeserializer())
                .registerTypeAdapter(Boolean.class, new BooleanAsIntAdapter())
                .registerTypeAdapter(boolean.class, new BooleanAsIntAdapter())
                .registerTypeAdapter(skillListType, new SkillDeserializer())
                .registerTypeAdapter(TaskList.class, new TaskListDeserializer())
                .registerTypeAdapter(Purchases.class, new PurchasedDeserializer())
                .registerTypeAdapter(customizationListType, new CustomizationDeserializer())
                .registerTypeAdapter(tutorialStepListType, new TutorialStepListDeserializer())
                .registerTypeAdapter(faqArticleListType, new FAQArticleListDeserilializer())
                .registerTypeAdapter(Group.class, new GroupSerialization())
                .registerTypeAdapter(Date.class, new DateDeserializer())
                .registerTypeAdapter(itemDataListType, new EquipmentListDeserializer())
                .registerTypeAdapter(ChatMessage.class, new ChatMessageDeserializer())
                .registerTypeAdapter(Task.class, new TaskSerializer())
                .registerTypeAdapter(ContentResult.class, new ContentDeserializer())
                .registerTypeAdapter(FeedResponse.class, new FeedResponseDeserializer())
                .registerTypeAdapter(Challenge.class, new ChallengeDeserializer())
                .registerTypeAdapter(User.class, new UserDeserializer())
                .registerTypeAdapter(questCollectListType, new QuestCollectDeserializer())
                .registerTypeAdapter(challengeListType, new ChallengeListDeserializer())
                .registerTypeAdapter(challengeRealmListType, new ChallengeListDeserializer())
                .registerTypeAdapter(questDropItemListType, new QuestDropItemsListSerialization())
                .registerTypeAdapter(ownedItemListType, new OwnedItemListDeserializer())
                .registerTypeAdapter(ownedPetListType, new OwnedPetListDeserializer())
                .registerTypeAdapter(ownedMountListType, new OwnedMountListDeserializer())
                .registerTypeAdapter(achievementsListType, new AchievementListDeserializer())
                .registerTypeAdapter(assignedDetailsListType, new AssignedDetailsDeserializer())
                .registerTypeAdapter(Quest.class, new QuestDeserializer())
                .registerTypeAdapter(Member.class, new MemberSerialization())
                .registerTypeAdapter(InviteResponse.class, new InviteResponseDeserializer())
                .registerTypeAdapter(WorldState.class, new WorldStateSerialization())
                .registerTypeAdapter(FindUsernameResult.class, new FindUsernameResultDeserializer())
                .registerTypeAdapter(Notification.class, new NotificationDeserializer())
                .registerTypeAdapter(SocialAuthentication.class, new SocialAuthenticationDeserializer())
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .serializeNulls()
                .setLenient()
                .create();
    }

    public static GsonConverterFactory create() {
        return GsonConverterFactory.create(createGson());
    }
}
