const time = document.getElementById('time')
const greeting = document.getElementById('greeting')
const Name = document.getElementById('name')
const Focus = document.getElementById('focus')

function formatNumber(n) {
  return n < 10 ? '0' + n : n
}

function showTime() {
  var today = new Date()
  var hour = formatNumber(today.getHours())
  var minutes = formatNumber(today.getMinutes())
  var seconds = formatNumber(today.getSeconds())

  time.innerHTML = `${hour}<span>:<span>${minutes}<span>:<span>${seconds}`

  setTimeout(showTime, 1000)
}

function showGreeting() {
  var today = new Date()
  var hour = formatNumber(today.getHours())

  if (hour < 10) {
    greeting.innerHTML = 'Good Morning'
    document.body.style.background = 'url(../img/Morning.jpg)'
  } else if (hour < 18) {
    greeting.innerHTML = 'Good Afternoon'
    document.body.style.background = 'url(../img/Afternoon.jpg)'
  } else {
    greeting.innerHTML = 'Good Evening'
    document.body.style.background = 'url(../img/Night.jpg)'
    document.body.style.color = 'white'
  }
}

function getName() {
  if (localStorage.getItem('name') === null) {
    Name.textContent = '[Enter Name]'
  } else {
    Name.textContent = localStorage.getItem('name')
  }
}

function getFocus() {
  if (localStorage.getItem('focus') === null) {
    Focus.textContent = '[Enter Focus]'
  } else {
    Focus.textContent = localStorage.getItem('focus')
  }
}

function setName(e) {
  if (e.type === 'keypress') {
    if (e.keyCode == 13) {
      localStorage.setItem('name', e.target.innerText)
      Name.blur()
    }
  } else {
    localStorage.setItem('name', e.target.innerText)
  }
}

function setFocus(e) {
  if (e.type === 'keypress') {
    if (e.keyCode == 13) {
      localStorage.setItem('focus', e.target.innerText)
      Focus.blur()
    }
  } else {
    localStorage.setItem('focus', e.target.innerText)
  }
}

Name.addEventListener('keypress', setName)
Name.addEventListener('blur', setName)

Focus.addEventListener('keypress', setFocus)
Focus.addEventListener('blur', setFocus)

showTime()
showGreeting()
getName()
getFocus()
