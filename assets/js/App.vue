<template>
  <div id="request-container">
    <div class="q-pa-md">
      <q-stepper v-model="step" vertical color="primary" animated>
        <q-step :name="1" title="Select campaign settings" icon="settings" :done="step > 1">
          For each ad campaign that you create, you can control how much you're willing to
          spend on clicks and conversions, which networks and geographical locations you want
          your ads to show on, and more.
          <q-stepper-navigation>
            <q-btn @click="step = 2" color="primary" label="Continue"/>
          </q-stepper-navigation>
        </q-step>

        <q-step
          :name="2"
          title="Create an ad group"
          caption="Optional"
          icon="create_new_folder"
          :done="step > 2"
        >
          An ad group contains one or more ads which target a shared set of keywords.
          <q-stepper-navigation>
            <q-btn @click="step = 4" color="primary" label="Continue"/>
            <q-btn flat @click="step = 1" color="primary" label="Back" class="q-ml-sm"/>
          </q-stepper-navigation>
        </q-step>

        <q-step
          :name="3"
          title="Ad template"
          icon="assignment"
          disable
        >This step won't show up because it is disabled.</q-step>

        <q-step :name="4" title="Create an ad" icon="add_comment">
          Try out different ad text to see what brings in the most customers, and learn how to
          enhance your ads using features like ad extensions. If you run into any problems with
          your ads, find out how to tell if they're running and how to resolve approval issues.
          <q-stepper-navigation>
            <q-btn color="primary" label="Finish"/>
            <q-btn flat @click="step = 2" color="primary" label="Back" class="q-ml-sm"/>
          </q-stepper-navigation>
        </q-step>
      </q-stepper>
    </div>
  </div>
</template>

<script>
import { Quasar, QStepper, QStep, QStepperNavigation, QBtn, QIcon } from "quasar";

// Vue.use(Quasar, {
//   components: {
//     QStepper,
//     QStep,
//     QStepperNavigation
//   }
// })

import { Socket, Presence } from "phoenix";

export default {
  components: {
    QStepper,
    QStep,
    QStepperNavigation,
    QBtn,
    QIcon
  },
  data() {
    return {
      squares: [],
      scores: {},
      winner: null,
      messages: [],
      players: [],
      chatMessage: "",
      error: "",
      step: 1,
      iconSet: 'fontawesome-pro'
    };
  },
  methods: {
    sendMark(square) {
     
    },
    sendChat(event) {
     
    },
    joinChannel(authToken, gameName) {
    //   const socket = new Socket("/socket", { params: { token: authToken } });

    //   socket.connect();

    //   this.channel = socket.channel(`games:${gameName}`, {});

    //   this.channel.on("game_summary", summary => {
    //     this.squares = summary.squares;
    //     this.scores = summary.scores;
    //     this.winner = summary.winner;
    //     this.players = this.toPlayers(this.presences);
    //   });

    //   this.presences = {};

    //   this.channel.on("presence_state", state => {
    //     this.presences = Presence.syncState(this.presences, state);
    //     this.players = this.toPlayers(this.presences);
    //   });

    //   this.channel.on("presence_diff", diff => {
    //     this.presences = Presence.syncDiff(this.presences, diff);
    //     this.players = this.toPlayers(this.presences);
    //   });

    //   this.channel.on("new_chat_message", message => {
    //     this.messages.push(message);
    //   });

    //   this.channel
    //     .join()
    //     .receive("ok", response => {
    //       console.log(`Joined ${gameName} 😊`);
    //     })
    //     .receive("error", response => {
    //       this.error = `Joining ${gameName} failed 🙁`;
    //       console.log(this.error, response);
    //     });
    },
    toPlayers(presences) {
    //   const listBy = (name, { metas: [first, ...rest] }) => {
    //     const score = this.scores[name] || 0;
    //     return { name: name, color: first.color, score: score };
    //   };

    //   return Presence.list(presences, listBy);
    }
  },
  created: function() {
    const gameContainer = this.$parent.$el;

    const { authToken, gameName } = gameContainer.dataset;

    //this.joinChannel(authToken, gameName);
  }
};
</script>