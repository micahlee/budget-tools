App.cable.subscriptions.create({ channel: "ProgressChannel", kind: "ally"}, {
  connected: function() {
    console.log("CONNECTED");
  },
  disconnected: function() {
    console.log("DISCONNECTED");
  },
  received: function(data) {
    console.log(data);
    $("#ally_progress").text(data.message);
  }
});

App.cable.subscriptions.create({ channel: "ProgressChannel", kind: "bill_pay"});