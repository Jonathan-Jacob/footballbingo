import consumer from "./consumer";

const pickMessageSide = () => {
 // let messages = document.querySelectorAll(".message-container");
  let messages = document.querySelectorAll(".message-container");
  let container = document.getElementById("messages");

  if (messages.length > 0 && container) {
      // messages.forEach( (message) => {
        let message = messages[messages.length - 1];
        if (message.dataset.senderId === container.dataset.currentUser ) {
          message.classList.remove('buddy-message');
          message.classList.add('user-message');
        } else {
          message.classList.remove('user-message');
          message.classList.add('buddy-message');
        }
      // })
  }
}

const initChatroomCable = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId;

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        console.log(data);
        messagesContainer.insertAdjacentHTML('beforeend', data);
        // pickMessageSide();
      },
    });
  }
}

export { initChatroomCable };
