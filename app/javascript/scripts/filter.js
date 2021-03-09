import Rails from '@rails/ujs';

const updateMatches = (event) => {
  const matchesInput = document.querySelector("#game_match_id")
  Rails.ajax({
    type: "GET",
    url: "/competition_matches",
    data: `[competition_id]=${event.currentTarget.value}`,
    success: (data) => {
      let optionsHtml = '<option value=""></option>'
      data.matches.forEach((match) => {
        optionsHtml += `<option value="${match.id}">${match.team_1} vs ${match.team_2} kickoff at ${match.date_time.strftime("%d. %B %Y %H:%M")}</option>`
      });
      matchesInput.innerHTML = optionsHtml
    }
  })
}


const initFilter = () => {
  const input = document.querySelector("#competition_match")
  input.addEventListener("change", updateMatches)
}
export {initFilter}
