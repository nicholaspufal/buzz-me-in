exports.handler = function(context, event, callback) {
  const twiml = new Twilio.twiml.VoiceResponse();
  twiml.say({ voice: "alice" }, "Opening the door");
  twiml.pause(3);
  twiml.play({ digits: '6w6w6w6w6w6w' });

  callback(null, twiml);
};
