module.exports = function (msg) {
  console.log("Processed: ", msg.data.name);
  return msg;
};
