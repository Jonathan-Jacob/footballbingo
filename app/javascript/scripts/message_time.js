const initMessageTime = () => {
  if (document.getElementById('messages')) {
    const messagesContainer = document.getElementById('messages');
    if (messagesContainer.getElementsByClassName('user-message')) {
      const userMessages = messagesContainer.getElementsByClassName('user-message');
      for (let i = 0; i < userMessages.length; i++) {
        changeMessageTime(userMessages[i]);
      }
    }
    if (messagesContainer.getElementsByClassName('buddy-message')) {
      const buddyMessages = messagesContainer.getElementsByClassName('buddy-message');
      for (let i = 0; i < buddyMessages.length; i++) {
        changeMessageTime(buddyMessages[i]);
      }
    }
  }
}

const initMessageTimeNew = () => {
  const target = document.querySelector('#messages');

  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      for (let i = 0; i < mutation.addedNodes.length; i++) {
        if (mutation.addedNodes[i].className === "message-container"){
          changeMessageTime(mutation.addedNodes[i]);
        }
      }
    });
  });

  var config = {
    attributes: true,
    childList: true,
    characterData: true
  };

  observer.observe(target, config);
}

const changeMessageTime = (message) => {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  const utcDate = new Date(message.getElementsByClassName('time')[0].innerHTML);
  const now = new Date;
  const offset = now.getTimezoneOffset();
  const localDate = new Date(utcDate.getTime() - offset*60000)
  const day = localDate.getDate();
  const monthIndex = localDate.getMonth();
  const hours = localDate.getHours();
  const minutes = localDate.getMinutes();
  let buffer = "";
  if (minutes < 10){
    buffer = "0";
  }
  const dateString = `${months[monthIndex]} ${day}, ${hours}:${buffer}${minutes}`;
  message.getElementsByClassName('time')[0].innerHTML = dateString;
}

export { initMessageTime }
export { initMessageTimeNew }
