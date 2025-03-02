let DISCORD_ID = null;

window.addEventListener('message', (event) => {
  let data = event.data;

  if (data.type === 'open') {
    showMenu();
    updateMenu(data.data);
  } else if (data.type === 'close') {
    hideMenu();
  } else if (data.type === 'update') {
    updateMenu(data.data);
  }
})

const updateMenu = (data) => {
  document.getElementById('player-name').innerText = data.playerName;
  document.getElementById('job1name').innerText = data.playerJob == 'Disoccupato - Disoccupato' ? 'Disoccupato' : data.playerJob;
  document.getElementById('job2name').innerText = data.playerJob2 == 'Disoccupato - Disoccupato' ? 'Disoccupato' : data.playerJob2;
  if (!data.playerJob2 || data.playerJob2 == 'Unemployed - Unemployed') {
    document.getElementById('job2').style.display = 'none';
  } else {
    document.getElementById('job2').style.display = 'flex';
  }
  document.getElementById('citizen-id').innerText = data.citizenId;
}

const hideMenu = () => {
  document.getElementById('page').style.display = 'none';
  document.getElementById('page').style.backgroundColor = 'transparent';
}

const showMenu = () => {
  document.getElementById('page').style.display = 'flex';
  document.getElementById('page').style.backgroundColor = 'rgba(17, 17, 17, 0.74)';
}

document.getElementById('settings-btn').addEventListener('click', () => {
  fetch(`https://KF_PauseMenu/settings`);
})

document.getElementById('discord-btn').addEventListener('click', () => {
  fetch(`https://KF_PauseMenu/rules`);
  window.invokeNative("openUrl", "https://docs.google.com/document/d/1SaQmuQiD3M4GX92szuFnTt4eu9lA8MbyK5b3PFeZcao/edit?tab=t.0");
})

document.getElementById('map-btn').addEventListener('click', () => {
  fetch(`https://KF_PauseMenu/map`);
})

document.getElementById('exit-btn').addEventListener('click', () => {
  fetch(`https://KF_PauseMenu/exit`);
})

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    hideMenu();
    fetch(`https://KF_PauseMenu/close`);
  }
})

document.addEventListener('DOMContentLoaded', () => {
  fetch(`https://KF_PauseMenu/ready`);
  getAvatar();
});

document.querySelector('.player-login-info').addEventListener('click', () => {
  fetch(`https://KF_PauseMenu/checkDonations`);
})

async function getAvatar() {
  fetch(`https://KF_PauseMenu/GetDiscordAvatar`).then((res) => {
    res.json().then((data) => {
      let avatar = data.avatar;
      DISCORD_ID = data.discord_id;

      if (avatar) {
        if (avatar.startsWith('a_')) {
          avatar = `https://cdn.discordapp.com/avatars/${DISCORD_ID}/${data.avatar}.gif`;
        } else {
          avatar = `https://cdn.discordapp.com/avatars/${DISCORD_ID}/${data.avatar}.png`;
        }
      } else {
        // avatar = 'https://biografieonline.it/img/bio/box/b/Benito_Mussolini.jpg';
        avatar = "images/guest.png";
      }
        
      // console.log(avatar);
      document.getElementById('player-avatar').src = avatar;
    })
  })
}