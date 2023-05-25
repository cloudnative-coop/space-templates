function DisplayKeys(castfile,commandId,keyId) {
  // TODO: test different key combinations and shortcuts
  var p = document.getElementById(keyId)

  var player = AsciinemaPlayer.create(castfile,document.getElementById(commandId),{
      autoPlay:true,
      url:castfile,
      preload:true,
      loop:true,
      theme:'solarized-dark'
  })
  if(keyId){

    player.addEventListener('input', (data) =>{

        value = ascii[data.data.toLowerCase()]
        if(value){
          p.textContent = value + " "
        }else{
          p.textContent +=  data.data
        }
        console.log(data)

    })
  }
}
const ascii = {
  "\x00": 'NUL',
  '\x01': 'Ctrl + A',
  '\x02': 'Ctrl + B',
  '\x03': 'Ctrl + C',
  '\t': 'Tab',
  '\r': 'Enter',
  '\x7f': 'Backspace',
  '\x1b[a': "Up Arrow",
  '\x1b[b' : "Down Arrow",
  '\x1b[d' : "Left Arrow",
  '\x1b[c' : "Right Arrow",
  '\x1b[3~': "Delete"


}
