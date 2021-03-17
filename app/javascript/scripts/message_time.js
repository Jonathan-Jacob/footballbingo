const initMessageTime = () => {
  if (document.getElementById('messages')) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    const messagesContainer = document.getElementById('messages');
    if (messagesContainer.getElementsByClassName('user-message')) {
      const userMessages = messagesContainer.getElementsByClassName('user-message');
      for (let i = 0; i < userMessages.length; i++) {
        const utcDate = new Date(userMessages[i].getElementsByClassName('time')[0].innerHTML);
        const now = new Date;
        const offset = now.getTimezoneOffset();
        const localDate = new Date(utcDate.getTime() - offset*60000)
        const day = localDate.getDate();
        const monthIndex = localDate.getMonth();
        const hours = localDate.getHours();
        const minutes = localDate.getMinutes();
        const years = 1900 + localDate.getYear();
        let buffer = "";
        if (minutes < 10){
          buffer = "0";
        }
        const dateString = `${months[monthIndex]} ${day}, ${years}, ${hours}:${buffer}${minutes}`;
        userMessages[i].getElementsByClassName('time')[0].innerHTML = dateString;
        // console.log(date)
        // userMessages[i].getElementsByClassName('time')[0] = `<span>${date}</span>`
      }
    }
    if (messagesContainer.getElementsByClassName('buddy-message')) {
      const buddyMessages = messagesContainer.getElementsByClassName('buddy-message');
      for (let i = 0; i < buddyMessages.length; i++) {
        console.log(buddyMessages[i].getElementsByClassName('time')[0]);
        const date = new Date(buddyMessages[i].getElementsByClassName('time')[0]);
        // console.log(date)
        // buddyMessages[i].getElementsByClassName('author')[0].insertAdjacentHTML('beforeend', '<span>test</span>');
      }
    }
  }
}

export { initMessageTime }
