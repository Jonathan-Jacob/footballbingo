import consumer from "./consumer";

const initBingoCardCable = () => {
  const bingoTilesContainer = document.getElementById('grid');
  if (bingoTilesContainer) {
    const id = bingoTilesContainer.dataset.bingoCardId;

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        console.log(data); // called when data is broadcast in the cable
      },
    });
  }
}

export { initChatroomCable };