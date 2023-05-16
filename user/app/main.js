const bglData = document.getElementById("bglData");
const bgRate = document.getElementById("bgRate");
const timeStamp = document.getElementById("timeStamp");
const avgData = document.getElementById("avgData");
const sdData = document.getElementById("sdData");
const gmiData = document.getElementById("gmiData");
const highData = document.getElementById("highData");
const highDataBar = document.getElementById("highDataBar");
const inRangeData = document.getElementById("inRangeData");
const inRangeDataBar = document.getElementById("inRangeDataBar");
const lowData = document.getElementById("lowData");
const lowDataBar = document.getElementById("lowDataBar");

async function fetchData() {
  try {
    const response = await fetch('../user.json');

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    
    if (data.BGL && !isNaN(data.BGL)) {
      bglData.textContent = data.BGL;
    } else {
      bglData.textContent = '--';
    }

    if (data.BGR && !isNaN(data.BGR)) {
      bgRate.style.borderRadius = `${50 - 25 * Math.abs(data.BGR)}%`;
      if (data.BGR < 0) {
        bgRate.style.transform = 'rotateZ(-45deg)';
      } else {
        bgRate.style.transform = 'rotateZ(135deg)';
      }
    } else {
      bgRate.style.borderRadius = `50%`;
    }

    if (data.TimeStamp) {
      timeStamp.textContent = `${data.TimeStamp.initial}  -  ${data.TimeStamp.current}`;
    } else {
      timeStamp.textContent = '--/--/--';
    }

    if (data.AVG && !isNaN(data.AVG)) {
      avgData.textContent = data.AVG;
    } else {
      avgData.textContent = '--';
    }

    if (data.SD && !isNaN(data.SD)) {
      sdData.textContent = data.SD;
    } else {
      sdData.textContent = '--';
    }

    if (data.GMI && !isNaN(data.GMI)) {
      gmiData.textContent = data.GMI;
    } else {
      gmiData.textContent = '--';
    }

    if (data.TIR){
      if (data.TIR.high && !isNaN(data.TIR.high)) {
        highData.textContent = `${data.TIR.high} %`;
        highDataBar.style.width = `${data.TIR.high}%`;
    } else {
      highData.textContent = '--';
      highDataBar.style.width = 0;
    }
    
    if (data.TIR.inRange && !isNaN(data.TIR.inRange)) {
      inRangeData.textContent = `${data.TIR.inRange} %`;
      inRangeDataBar.style.width = `${data.TIR.inRange}%`;
    } else {
      inRangeData.textContent = '--';
      inRangeDataBar.style.width = 0;
    }
    
    if (data.TIR.low && !isNaN(data.TIR.low)) {
      lowData.textContent = `${data.TIR.low} %`;
      lowDataBar.style.width = `${data.TIR.low}%`;
    } else {
      lowData.textContent = '--';
      lowDataBar.style.width = 0;
    }
  }
  } catch (error) {
    bglData.textContent = '--';
    timeStamp.textContent = '--/--/--';
    avgData.textContent = '--';
    sdData.textContent = '--';
    gmiData.textContent = '--';
    highData.textContent = '--';
    highDataBar.style.width = 0;
    inRangeData.textContent = '--';
    inRangeDataBar.style.width = 0;
    lowData.textContent = '--';
    lowDataBar.style.width = 0;
    console.error('Error fetching JSON data:', error);
  }
}

fetchData();