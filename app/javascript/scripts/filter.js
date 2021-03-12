import Rails from '@rails/ujs';

const updateMatches = (event) => {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
   const matchesInput = document.querySelector("#game_match_id")
   Rails.ajax({
     type: "GET",
     url: "/competition_matches",
     data: `[competition_id]=${event.currentTarget.value}`,
     success: (data) => {
       let optionsHtml = '<option value=""></option>'
       data.matches.forEach((match) => {
         const match_date = new Date(match.date_time)
         console.log(match_date)
         const day = match_date.getDate()
         const monthIndex = match_date.getMonth()
         const hours = match_date.getHours()
         const minutes = match_date.getMinutes()
         const years = 1900 + match_date.getYear()
         let buffer = ""
         if (minutes < 10){
           buffer = "0"
         }
         optionsHtml += `<option value="${match.id}">${match.team_1} vs ${match.team_2} - ${day}.${months[monthIndex]} ${years} at ${hours}:${buffer}${minutes}h</option>`
       });
       matchesInput.innerHTML = optionsHtml
     }
   })
 }


const initFilter = () => {
  const input = document.querySelector("#competition_match")

  if (input) {
    input.addEventListener("change", updateMatches)
  }
}

export { initFilter }
