<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-6 offset-3">
        <h1>{{ $t('contactUs') }}</h1>
        <p>
          {{ $t('reportAccountProblems') }}
          &colon;&nbsp;
          <a href="mailto:admin@adhder.com">admin&commat;adhder&period;com</a>
          <span v-if="user">
            <br>
            <a
              target="_blank"
              @click.prevent="openBugReportModal()"
            >
              {{ $t('reportBug') }}
            </a>
            <br>
            {{ $t('reportCommunityIssues') }}
            &colon;&nbsp;
            <a href="mailto:admin@adhder.com">admin&commat;adhder&period;com</a>
          </span>
          <span v-else>
            <br>
            {{ $t('reportBug') }}
            &colon;&nbsp;
            <a href="mailto:admin@adhder.com">admin&commat;adhder&period;com</a>
          </span>
          <br>
          {{ $t('subscriptionPaymentIssues') }}
          &colon;&nbsp;
          <a href="mailto:admin@adhder.com">admin&commat;adhder&period;com</a>
          <br>
          {{ $t('businessInquiries') }}
          &colon;&nbsp;
          <a href="mailto:admin@adhder.com">admin@adhder.com</a>
          <br>
          {{ $t('merchandiseInquiries') }}
          &colon;&nbsp;
          <a href="mailto:admin@adhder.com">admin&commat;adhder&period;com</a>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from '@/libs/store';
import { goToModForm } from '@/libs/modform';

export default {
  computed: {
    ...mapState({
      user: 'user.data',
    }),
  },
  mounted () {
    this.$store.dispatch('common:setTitle', {
      section: this.$t('contactUs'),
    });
  },
  methods: {
    modForm () {
      goToModForm(this.user);
    },
  },
};
</script>
