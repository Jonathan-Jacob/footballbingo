import consumer from "./consumer";
import swal from 'sweetalert';

const initBingoCardCable = () => {
  const bingoTilesContainer = document.getElementById('grid');
  if (bingoTilesContainer) {
    const id = bingoTilesContainer.dataset.bingoCardId;

    consumer.subscriptions.create({ channel: "BingoCardChannel", id: id }, {
      received(data) {
        console.log(data);
        if (data[0] == "bingo") {
          console.log("bingo!");
          swal({
            title: "⚽",
            text: "Bingo!",
            buttons: false,
            timer: 5000
          });
        }
        else if (document.getElementById(data[0]) && document.getElementById(data[0]).classList.contains("pending")) {
          if (data[1] == "happened") {
            document.getElementById(data[0]).classList.remove("pending");
            document.getElementById(data[0]).classList.add("accepted");
          }
        } else if (document.getElementById(data[0]) && document.getElementById(data[0]).classList.contains("accepted")) {
          if (data[1] == "not_happened") {
            document.getElementById(data[0]).classList.remove("accepted");
            document.getElementById(data[0]).classList.add("unchecked");
          }
        }
      },
    });
  }
}

export { initBingoCardCable };
